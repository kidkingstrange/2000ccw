import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps native keyboard integration and lifecycle soft-focus recovery.
/// Implements [WidgetsBindingObserver] so when the app is backgrounded and resumed,
/// the native keyboard soft focus re-attaches cleanly without freezing.
class NativeKeyboardWrapper extends StatefulWidget {
  final Widget child;
  final Function(String letter) onLetter;
  final VoidCallback onDelete;
  final bool autoFocus;

  const NativeKeyboardWrapper({
    super.key,
    required this.child,
    required this.onLetter,
    required this.onDelete,
    this.autoFocus = true,
  });

  @override
  State<NativeKeyboardWrapper> createState() => _NativeKeyboardWrapperState();
}

class _NativeKeyboardWrapperState extends State<NativeKeyboardWrapper>
    with WidgetsBindingObserver {
  late final FocusNode _focusNode;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode = FocusNode();

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestKeyboardFocus();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-request focus upon app resume, preventing Android keyboard detachment
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestKeyboardFocus();
      });
    }
  }

  void _requestKeyboardFocus() {
    if (mounted && _focusNode.canRequestFocus) {
      _focusNode.requestFocus();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        widget.onDelete();
      } else {
        final char = event.character;
        if (char != null && RegExp(r'^[a-zA-Z0-9]$').hasMatch(char)) {
          widget.onLetter(char.toUpperCase());
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _requestKeyboardFocus,
        child: widget.child,
      ),
    );
  }
}

/// Tactile Virtual Keypad Bar (for quick tapping or when soft-keyboard is closed)
class ToonKeyboardBar extends StatelessWidget {
  final Function(String letter) onLetter;
  final VoidCallback onDelete;

  const ToonKeyboardBar({
    super.key,
    required this.onLetter,
    required this.onDelete,
  });

  static const List<String> row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  static const List<String> row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  static const List<String> row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF161626),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(row1),
          const SizedBox(height: 4),
          _buildRow(row2),
          const SizedBox(height: 4),
          _buildRow3(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((k) => _buildKey(k)).toList(),
    );
  }

  Widget _buildRow3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...row3.map((k) => _buildKey(k)),
        _buildActionKey(
          icon: Icons.backspace_outlined,
          onTap: () {
            HapticFeedback.lightImpact();
            onDelete();
          },
        ),
      ],
    );
  }

  Widget _buildKey(String char) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Material(
          color: const Color(0xFF282842),
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              HapticFeedback.lightImpact();
              onLetter(char);
            },
            child: Container(
              height: 44,
              alignment: Alignment.center,
              child: Text(
                char,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({required IconData icon, required VoidCallback onTap}) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Material(
          color: const Color(0xFFFF4757),
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
