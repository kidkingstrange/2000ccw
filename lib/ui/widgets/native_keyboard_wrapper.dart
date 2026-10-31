import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps native mobile keyboard integration (Gboard, Samsung Keyboard, iOS)
/// and manages lifecycle soft-focus recovery via [WidgetsBindingObserver].
///
/// Eliminates any custom/extra virtual on-screen keyboards and channels
/// all user keystrokes from the phone's native keyboard directly into the game.
class NativeKeyboardWrapper extends StatefulWidget {
  final Widget child;
  final ValueChanged<String> onLetter;
  final VoidCallback onDelete;
  final VoidCallback? onSubmit;

  const NativeKeyboardWrapper({
    super.key,
    required this.child,
    required this.onLetter,
    required this.onDelete,
    this.onSubmit,
  });

  static NativeKeyboardWrapperState? of(BuildContext context) =>
      context.findAncestorStateOfType<NativeKeyboardWrapperState>();

  @override
  State<NativeKeyboardWrapper> createState() => NativeKeyboardWrapperState();
}

class NativeKeyboardWrapperState extends State<NativeKeyboardWrapper>
    with WidgetsBindingObserver {
  late final FocusNode _focusNode;
  final TextEditingController _controller = TextEditingController();

  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode = FocusNode();

    // Sentinel character so Backspace is reliably detected across all Android/iOS OEM keyboards
    _controller.text = ' ';
    _controller.selection = const TextSelection.collapsed(offset: 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestFocus();
    });
  }

  /// Explicitly requests soft keyboard focus
  void requestFocus() {
    if (mounted) {
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
      SystemChannels.textInput.invokeMethod('TextInput.show');
    }
  }

  /// Hides the native keyboard
  void hideKeyboard() {
    if (mounted) {
      _focusNode.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-request focus upon app resume, preventing Android keyboard detachment
      WidgetsBinding.instance.addPostFrameCallback((_) {
        requestFocus();
      });
    }
  }

  void _onTextChanged(String newText) {
    if (newText.isEmpty) {
      // User pressed Backspace / Delete on phone keyboard!
      HapticFeedback.lightImpact();
      widget.onDelete();
      _resetController();
    } else if (newText.length > 1) {
      // User typed a character!
      final char = newText.substring(1);
      final lastChar = char.isNotEmpty ? char[char.length - 1] : '';
      if (RegExp(r'^[a-zA-Z0-9]$').hasMatch(lastChar)) {
        HapticFeedback.lightImpact();
        widget.onLetter(lastChar.toUpperCase());
      }
      _resetController();
    } else if (newText != ' ') {
      // Replacement character
      if (RegExp(r'^[a-zA-Z0-9]$').hasMatch(newText)) {
        HapticFeedback.lightImpact();
        widget.onLetter(newText.toUpperCase());
      }
      _resetController();
    }
  }

  void _resetController() {
    _controller.value = const TextEditingValue(
      text: ' ',
      selection: TextSelection.collapsed(offset: 1),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Invisible input field seamlessly connected to the device's native keyboard
        Positioned(
          left: -100,
          top: -100,
          child: SizedBox(
            width: 10,
            height: 10,
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              onChanged: _onTextChanged,
              onSubmitted: (_) {
                widget.onSubmit?.call();
                _resetController();
                requestFocus();
              },
            ),
          ),
        ),
        // Main Screen UI
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: requestFocus,
          child: widget.child,
        ),
      ],
    );
  }
}
