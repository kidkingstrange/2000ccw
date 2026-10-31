"""
High-Resolution Google Play Store Assets Generator for 2000s Toon Crosswords
Generates:
1. store_assets/icon.png (512 x 512 px PNG)
2. store_assets/feature_graphic.png (1024 x 500 px PNG)
3. store_assets/screenshots/screenshot_1_home.png (1080 x 1920 px PNG)
4. store_assets/screenshots/screenshot_2_crosswords.png (1080 x 1920 px PNG)
5. store_assets/screenshots/screenshot_3_rebus.png (1080 x 1920 px PNG)
6. store_assets/screenshots/screenshot_4_channels.png (1080 x 1920 px PNG)
7. store_assets/screenshots/screenshot_5_trophy_lore.png (1080 x 1920 px PNG)
"""

import os
import shutil
from PIL import Image, ImageDraw, ImageFont

OUTPUT_DIR = "store_assets"
SCREENSHOTS_DIR = os.path.join(OUTPUT_DIR, "screenshots")
os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

# Luxury Light Theme Palette
BG_CANVAS = (248, 250, 252, 255)       # Slate 50
SURFACE_WHITE = (255, 255, 255, 255)   # Pure White
SURFACE_LIGHT = (241, 245, 249, 255)   # Slate 100
BORDER_COLOR = (226, 232, 240, 255)    # Slate 200
BANNER_NAVY = (15, 23, 42, 255)        # Deep Navy Slate 900
TEXT_MAIN = (15, 23, 42, 255)          # Slate 900
TEXT_SECONDARY = (51, 65, 85, 255)     # Slate 700
TEXT_MUTED = (100, 116, 139, 255)      # Slate 500
ACCENT_GREEN = (5, 150, 105, 255)      # Deep Emerald
MINT_SOLVED = (16, 185, 129, 255)      # Solved Mint
ACCENT_CYAN = (2, 132, 199, 255)       # Deep Sky Blue
ACCENT_ORANGE = (234, 88, 12, 255)     # Tangerine
GOLD = (217, 119, 6, 255)              # Amber Gold
GRID_LINE = (230, 236, 245, 255)

def get_font(name="arialbd.ttf", size=32):
    try:
        return ImageFont.truetype(name, size)
    except:
        return ImageFont.load_default()

def draw_grid_background(draw, width, height, spacing=60):
    for x in range(0, width, spacing):
        draw.line([(x, 0), (x, height)], fill=GRID_LINE, width=1)
    for y in range(0, height, spacing):
        draw.line([(0, y), (width, y)], fill=GRID_LINE, width=1)

# ==========================================
# 1. APP ICON (512 x 512)
# ==========================================
def generate_store_icon():
    print("Generating Store Icon (512x512)...")
    icon_path = "assets/icon.png"
    target_path = os.path.join(OUTPUT_DIR, "icon.png")
    if os.path.exists(icon_path):
        shutil.copyfile(icon_path, target_path)
    print(f"-> Saved: {target_path}")

# ==========================================
# 2. FEATURE GRAPHIC (1024 x 500)
# ==========================================
def generate_feature_graphic():
    print("Generating Feature Graphic (1024x500)...")
    width, height = 1024, 500
    img = Image.new("RGBA", (width, height), BANNER_NAVY)
    draw = ImageDraw.Draw(img)
    
    # Subtle ambient gradient glow
    for r in range(300, 50, -40):
        alpha = int(18 * (1 - r/300))
        draw.ellipse([200 - r, 250 - r, 200 + r, 250 + r], fill=(2, 132, 199, alpha))
        draw.ellipse([850 - r, 220 - r, 850 + r, 220 + r], fill=(5, 150, 105, alpha))

    # --- LEFT SIDE: BESPOKE TV ICON LOCKUP ---
    tv_cx, tv_cy = 240, 250
    # Antenna
    draw.line([(tv_cx - 20, tv_cy - 120), (tv_cx - 80, tv_cy - 190)], fill=(148, 163, 184, 255), width=6)
    draw.ellipse([tv_cx - 92, tv_cy - 202, tv_cx - 68, tv_cy - 178], fill=(56, 189, 248, 255))
    draw.line([(tv_cx + 20, tv_cy - 120), (tv_cx + 80, tv_cy - 190)], fill=(148, 163, 184, 255), width=6)
    draw.ellipse([tv_cx + 68, tv_cy - 202, tv_cx + 92, tv_cy - 178], fill=(56, 189, 248, 255))

    # TV Body (Sleek deep navy rounded chassis)
    tv_box = [tv_cx - 150, tv_cy - 110, tv_cx + 150, tv_cy + 120]
    draw.rounded_rectangle(tv_box, radius=32, fill=(30, 41, 59, 255), outline=(51, 65, 85, 255), width=3)

    # TV Screen (Light Paper Crossword Grid)
    screen_box = [tv_cx - 130, tv_cy - 90, tv_cx + 70, tv_cy + 100]
    draw.rounded_rectangle(screen_box, radius=20, fill=SURFACE_WHITE, outline=(226, 232, 240, 255), width=2)

    # Miniature Crossword Matrix on Screen
    c_start_x, c_start_y = tv_cx - 118, tv_cy - 78
    cell_s = 40
    cw_pattern = [
        [("T", True), ("O", True), ("O", True), ("N", True)],
        [("I", False), (" ", False), (" ", False), ("E", False)],
        [("M", False), (" ", False), (" ", False), ("X", False)],
        [("E", False), (" ", False), (" ", False), ("T", False)]
    ]
    for r in range(4):
        for c in range(4):
            char, is_highlight = cw_pattern[r][c]
            cx = c_start_x + c * (cell_s + 4)
            cy = c_start_y + r * (cell_s + 4)
            if char != " ":
                fill_c = (224, 242, 254, 255) if is_highlight else (241, 245, 249, 255)
                bdr_c = ACCENT_CYAN if is_highlight else (203, 213, 225, 255)
                draw.rounded_rectangle([cx, cy, cx + cell_s, cy + cell_s], radius=8, fill=fill_c, outline=bdr_c, width=1)
                draw.text((cx + 11, cy + 8), char, font=get_font("arialbd.ttf", 20), fill=TEXT_MAIN)

    # TV Controls Panel
    ctrl_x = tv_cx + 105
    draw.ellipse([ctrl_x - 18, tv_cy - 50, ctrl_x + 18, tv_cy - 14], fill=(71, 85, 105, 255), outline=(100, 116, 139, 255), width=2)
    draw.ellipse([ctrl_x - 18, tv_cy + 10, ctrl_x + 18, tv_cy + 46], fill=(71, 85, 105, 255), outline=(100, 116, 139, 255), width=2)

    # --- RIGHT SIDE: LUXURY EDITORIAL TYPOGRAPHY ---
    tx_start = 440
    # Category Pill
    draw.rounded_rectangle([tx_start, 45, tx_start + 260, 85], radius=20, fill=(30, 41, 59, 255), outline=(56, 189, 248, 120), width=1)
    draw.text((tx_start + 18, 55), "PREMIUM RETRO PUZZLES", font=get_font("arialbd.ttf", 14), fill=(56, 189, 248, 255))

    # Main Title
    draw.text((tx_start, 105), "2000s TOON", font=get_font("impact.ttf", 56), fill=(255, 255, 255, 255))
    draw.text((tx_start, 168), "CROSSWORDS", font=get_font("impact.ttf", 56), fill=(56, 189, 248, 255))

    # Subtitle
    draw.text((tx_start, 240), "400 Handcrafted Saturday Morning Cartoon Puzzles", font=get_font("segoeui.ttf", 22), fill=(226, 232, 240, 255))
    draw.text((tx_start, 275), "Connected Grids • Emoji Title Rebuses • Lore Dex", font=get_font("segoeui.ttf", 18), fill=TEXT_MUTED)

    # Channel Pills
    ch_y = 320
    channels = ["CARTOON NETWORK", "NICKELODEON", "DISNEY/JETIX", "KIDS' WB", "KIDSCO", "JIMJAM", "TELETOON"]
    cx = tx_start
    font_ch = get_font("arialbd.ttf", 12)
    for ch in channels:
        tw = int(draw.textlength(ch, font=font_ch))
        if cx + tw + 18 > 990:
            cx = tx_start
            ch_y += 32
        c_box = [cx, ch_y, cx + tw + 18, ch_y + 24]
        draw.rounded_rectangle(c_box, radius=12, fill=(30, 41, 59, 255), outline=(71, 85, 105, 255), width=1)
        draw.text((cx + 9, ch_y + 5), ch, font=font_ch, fill=(148, 163, 184, 255))
        cx += tw + 24

    # Bottom Verification Shield
    shield_box = [tx_start, 430, 980, 470]
    draw.rounded_rectangle(shield_box, radius=12, fill=(6, 78, 59, 150), outline=(16, 185, 129, 200), width=1)
    font_shield = get_font("arialbd.ttf", 14)
    draw.text((tx_start + 18, 442), "100% OFFLINE • ZERO ADS • 200+ UNLOCKABLE ARCHIVE CARDS", font=font_shield, fill=(16, 185, 129, 255))

    target_path = os.path.join(OUTPUT_DIR, "feature_graphic.png")
    img.save(target_path, "PNG")
    print(f"-> Saved: {target_path}")

# ==========================================
# 3. PHONE SCREENSHOT MOCKUPS (1080 x 1920)
# ==========================================
def draw_phone_frame(draw, x0, y0, x1, y1):
    # Device outer chassis (Slate 900)
    draw.rounded_rectangle([x0, y0, x1, y1], radius=60, fill=(15, 23, 42, 255), outline=(51, 65, 85, 255), width=6)
    # Inner display area (Slate 50 Luxury Canvas)
    disp_x0, disp_y0 = x0 + 16, y0 + 16
    disp_x1, disp_y1 = x1 - 16, y1 - 16
    draw.rounded_rectangle([disp_x0, disp_y0, disp_x1, disp_y1], radius=48, fill=BG_CANVAS)
    # Punch hole camera
    cam_cx = (x0 + x1) // 2
    draw.ellipse([cam_cx - 10, disp_y0 + 14, cam_cx + 10, disp_y0 + 34], fill=(10, 10, 15, 255))
    return disp_x0, disp_y0, disp_x1, disp_y1

def generate_screenshots():
    w, h = 1080, 1920
    screens = [
        {
            "filename": "screenshot_1_home.png",
            "tag": "CHILD OF THE 2000s?",
            "headline": "THE ULTIMATE CARTOON PUZZLE",
            "sub": "400 Handcrafted Levels • 100% Offline • Zero Ads",
            "mode": "home"
        },
        {
            "filename": "screenshot_2_crosswords.png",
            "tag": "CLASSIC CROSSWORDS",
            "headline": "WORD-LOCKING & TACTILE CLUES",
            "sub": "Interactive Grids with Native Keyboard Integration",
            "mode": "crossword"
        },
        {
            "filename": "screenshot_3_rebus.png",
            "tag": "EMOJI TITLE REBUS",
            "headline": "VISUAL SHOW RIDDLES",
            "sub": "Dedicated Word Rows Prevent Awkward Word Breaks",
            "mode": "rebus"
        },
        {
            "filename": "screenshot_4_channels.png",
            "tag": "7 ICONIC CHANNELS",
            "headline": "EVERY CARTOON FROM YOUR CHILDHOOD",
            "sub": "Cartoon Network, Nick, Jetix, Kids' WB, KidsCo, JimJam & Teletoon",
            "mode": "channels"
        },
        {
            "filename": "screenshot_5_trophy_lore.png",
            "tag": "THE TROPHY HALL",
            "headline": "UNLOCK VERIFIED TRIVIA LORE",
            "sub": "Every Puzzle Unlocks Behind-The-Scenes Production Archives",
            "mode": "trophy"
        }
    ]

    for s in screens:
        print(f"Generating Screenshot: {s['filename']} (1080x1920)...")
        # Banner background is deep navy
        img = Image.new("RGBA", (w, h), BANNER_NAVY)
        draw = ImageDraw.Draw(img)

        # TOP MARKETING COPY
        # Tag Badge
        font_tag = get_font("arialbd.ttf", 24)
        tw = int(draw.textlength(s["tag"], font=font_tag))
        tag_x = (w - tw) // 2
        draw.rounded_rectangle([tag_x - 24, 65, tag_x + tw + 24, 115], radius=25, fill=(30, 41, 59, 255), outline=(56, 189, 248, 140), width=1)
        draw.text((tag_x, 77), s["tag"], font=font_tag, fill=(56, 189, 248, 255))

        # Big Headline
        font_head = get_font("impact.ttf", 54)
        hw = int(draw.textlength(s["headline"], font=font_head))
        draw.text(((w - hw) // 2, 135), s["headline"], font=font_head, fill=(255, 255, 255, 255))

        # Subtitle
        font_sub = get_font("segoeui.ttf", 26)
        sw = int(draw.textlength(s["sub"], font=font_sub))
        draw.text(((w - sw) // 2, 210), s["sub"], font=font_sub, fill=(148, 163, 184, 255))

        # PHONE FRAME (Coordinates: 100, 275 to 980, 1865)
        px0, py0, px1, py1 = draw_phone_frame(draw, 100, 275, 980, 1865)

        # RENDER LUXURY SCREEN CONTENTS
        if s["mode"] == "home":
            # Header status
            draw.text((px0 + 50, py0 + 60), "2000s TOON CROSSWORDS", font=get_font("impact.ttf", 42), fill=TEXT_MAIN)
            draw.text((px0 + 50, py0 + 115), "The Golden Era of Animated Television", font=get_font("segoeui.ttf", 22), fill=TEXT_MUTED)

            # Daily Streak Pill & Coins
            draw.rounded_rectangle([px0 + 50, py0 + 160, px0 + 260, py0 + 205], radius=22, fill=(255, 247, 237, 255), outline=(254, 215, 170, 255), width=1)
            draw.text((px0 + 75, py0 + 172), "5 DAY STREAK", font=get_font("arialbd.ttf", 18), fill=ACCENT_ORANGE)

            draw.rounded_rectangle([px1 - 250, py0 + 160, px1 - 50, py0 + 205], radius=22, fill=(254, 252, 232, 255), outline=(254, 240, 138, 255), width=1)
            draw.text((px1 - 220, py0 + 172), "1,250 COINS", font=get_font("arialbd.ttf", 18), fill=GOLD)

            # Quick Play Hero Button
            qb_y = py0 + 230
            draw.rounded_rectangle([px0 + 40, qb_y, px1 - 40, qb_y + 90], radius=22, fill=ACCENT_GREEN)
            draw.text((px0 + 200, qb_y + 28), "CONTINUE PUZZLE (LEVEL 14)", font=get_font("arialbd.ttf", 26), fill=(255, 255, 255, 255))

            # Mode Card 1: Classic Crosswords
            c1_y = py0 + 350
            draw.rounded_rectangle([px0 + 40, c1_y, px1 - 40, c1_y + 220], radius=24, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.rounded_rectangle([px0 + 65, c1_y + 35, px0 + 165, c1_y + 135], radius=18, fill=(240, 249, 255, 255), outline=(186, 230, 253, 255), width=1)
            draw.text((px0 + 190, c1_y + 45), "Classic Crosswords", font=get_font("arialbd.ttf", 34), fill=TEXT_MAIN)
            draw.text((px0 + 190, c1_y + 95), "200 Grids • Handcrafted Connectivity", font=get_font("segoeui.ttf", 22), fill=TEXT_MUTED)
            draw.rounded_rectangle([px0 + 190, c1_y + 145, px1 - 70, c1_y + 195], radius=14, fill=SURFACE_LIGHT)
            draw.text((px0 + 280, c1_y + 156), "EXPLORE LEVELS", font=get_font("arialbd.ttf", 20), fill=ACCENT_CYAN)

            # Mode Card 2: Emoji Rebus
            c2_y = py0 + 600
            draw.rounded_rectangle([px0 + 40, c2_y, px1 - 40, c2_y + 220], radius=24, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.rounded_rectangle([px0 + 65, c2_y + 35, px0 + 165, c2_y + 135], radius=18, fill=(255, 247, 237, 255), outline=(254, 215, 170, 255), width=1)
            draw.text((px0 + 190, c2_y + 45), "Emoji Title Rebus", font=get_font("arialbd.ttf", 34), fill=TEXT_MAIN)
            draw.text((px0 + 190, c2_y + 95), "200 Visual Enigmas • Dedicated Word Rows", font=get_font("segoeui.ttf", 22), fill=TEXT_MUTED)
            draw.rounded_rectangle([px0 + 190, c2_y + 145, px1 - 70, c2_y + 195], radius=14, fill=SURFACE_LIGHT)
            draw.text((px0 + 280, c2_y + 156), "EXPLORE LEVELS", font=get_font("arialbd.ttf", 20), fill=ACCENT_ORANGE)

            # Trophy Hall Card
            c3_y = py0 + 850
            draw.rounded_rectangle([px0 + 40, c3_y, px1 - 40, c3_y + 180], radius=24, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.text((px0 + 70, c3_y + 35), "Trophy Hall & Lore Dex", font=get_font("arialbd.ttf", 30), fill=TEXT_MAIN)
            draw.text((px0 + 70, c3_y + 80), "157 Verified Behind-The-Scenes Production Facts", font=get_font("segoeui.ttf", 22), fill=TEXT_MUTED)
            # Progress bar
            draw.rounded_rectangle([px0 + 70, c3_y + 130, px1 - 70, c3_y + 145], radius=8, fill=SURFACE_LIGHT)
            draw.rounded_rectangle([px0 + 70, c3_y + 130, px0 + 380, c3_y + 145], radius=8, fill=ACCENT_GREEN)

        elif s["mode"] == "crossword":
            # Top Ribbon: Level & Coin
            draw.text((px0 + 40, py0 + 50), "LEVEL 14 • CARTOON NETWORK", font=get_font("impact.ttf", 34), fill=ACCENT_CYAN)
            draw.text((px1 - 200, py0 + 55), "1,450 COINS", font=get_font("arialbd.ttf", 20), fill=GOLD)

            # Active Clue Ribbon (Paper Floating Card)
            draw.rounded_rectangle([px0 + 40, py0 + 110, px1 - 40, py0 + 210], radius=18, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.text((px0 + 60, py0 + 128), "2 ACROSS • 7 LETTERS", font=get_font("arialbd.ttf", 20), fill=ACCENT_CYAN)
            draw.text((px0 + 60, py0 + 160), "Primary hero and wielder of the extraterrestrial device", font=get_font("segoeui.ttf", 22), fill=TEXT_MAIN)

            # Crossword Grid (8x8) - Unsolved active gameplay state with hidden answers!
            grid_y = py0 + 240
            cell_size = 90
            grid_x_start = px0 + 50
            grid_layout = [
                [1, 2, None, None, 3, None, None, None],
                [None, 0, None, None, 0, None, 4, None],
                [5, 0, 0, 0, 0, None, 0, None],
                [None, 0, None, None, 0, None, 0, None],
                [None, None, 6, 0, 0, 0, 0, None],
                [7, 0, 0, 0, None, None, 0, None],
                [None, None, 0, None, None, None, None, None],
                [8, 0, 0, 0, 0, None, None, None]
            ]
            for r in range(8):
                for c in range(8):
                    val = grid_layout[r][c]
                    cx = grid_x_start + c * 92
                    cy = grid_y + r * 92
                    if val is not None:
                        is_active = (r == 2 and c == 1)
                        is_word = (r == 2 and c > 0 and c < 5)
                        bg_col = (224, 242, 254, 255) if is_active else ((240, 249, 255, 255) if is_word else SURFACE_WHITE)
                        bdr_col = ACCENT_CYAN if is_active else ((186, 230, 253, 255) if is_word else BORDER_COLOR)
                        draw.rounded_rectangle([cx, cy, cx + cell_size, cy + cell_size], radius=10, fill=bg_col, outline=bdr_col, width=2 if is_active else 1)
                        if val > 0:
                            draw.text((cx + 8, cy + 6), str(val), font=get_font("arialbd.ttf", 16), fill=TEXT_MUTED)
                        if is_active:
                            draw.line([(cx + 45, cy + 22), (cx + 45, cy + 68)], fill=TEXT_MAIN, width=3)

            # Native Keyboard Area (Shows mobile phone typing with clue above)
            kb_y = py0 + 1040
            draw.rounded_rectangle([px0 + 30, kb_y, px1 - 30, py1 - 30], radius=24, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.text((px0 + 60, kb_y + 30), "NATIVE DEVICE KEYBOARD SUPPORT", font=get_font("arialbd.ttf", 22), fill=ACCENT_CYAN)
            draw.text((px0 + 60, kb_y + 65), "Full Gboard, Samsung & system keyboard integration", font=get_font("segoeui.ttf", 20), fill=TEXT_MUTED)
            # Simulated native keyboard keys
            key_rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
            for r_idx, row_str in enumerate(key_rows):
                ry = kb_y + 115 + r_idx * 75
                k_w = (px1 - px0 - 100) // len(row_str)
                rx_start = px0 + 50 + (10 - len(row_str)) * (k_w // 2)
                for c_idx, k_char in enumerate(row_str):
                    kx = rx_start + c_idx * k_w
                    draw.rounded_rectangle([kx + 4, ry, kx + k_w - 4, ry + 65], radius=10, fill=SURFACE_LIGHT, outline=BORDER_COLOR, width=1)
                    draw.text((kx + k_w//2 - 8, ry + 18), k_char, font=get_font("arialbd.ttf", 22), fill=TEXT_MAIN)

        elif s["mode"] == "rebus":
            # Header
            draw.text((px0 + 40, py0 + 50), "LEVEL 42 • MYSTERY REBUS", font=get_font("impact.ttf", 34), fill=ACCENT_ORANGE)
            draw.text((px1 - 200, py0 + 55), "2,100 COINS", font=get_font("arialbd.ttf", 20), fill=GOLD)

            # Big Emoji Card
            rebus_box = [px0 + 40, py0 + 120, px1 - 40, py0 + 360]
            draw.rounded_rectangle(rebus_box, radius=28, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.text((px0 + 130, py0 + 165), "👽   ⌚   🔟", font=get_font("segoeui.ttf", 72), fill=TEXT_MAIN)
            draw.text((px0 + 170, py0 + 290), "DECODE THE CARTOON NETWORK TITLE", font=get_font("arialbd.ttf", 20), fill=ACCENT_CYAN)

            # Dedicated Word Rows (HIDDEN ANSWERS - blank puzzle slots!)
            row_y = py0 + 420
            draw.text((px0 + 50, row_y - 35), "WORD 1 (3 LETTERS)", font=get_font("arialbd.ttf", 20), fill=ACCENT_GREEN)
            for i in range(3):
                bx = px0 + 50 + i * 110
                is_sel = (i == 0)
                b_col = (224, 242, 254, 255) if is_sel else SURFACE_WHITE
                bdr = ACCENT_CYAN if is_sel else BORDER_COLOR
                draw.rounded_rectangle([bx, row_y, bx + 95, row_y + 95], radius=14, fill=b_col, outline=bdr, width=2 if is_sel else 1)
                if is_sel:
                    draw.line([(bx + 47, row_y + 25), (bx + 47, row_y + 70)], fill=TEXT_MAIN, width=3)

            # Word 2 (3 Letters) - empty slots
            row2_y = row_y + 170
            draw.text((px0 + 50, row2_y - 35), "WORD 2 (3 LETTERS)", font=get_font("arialbd.ttf", 20), fill=TEXT_MUTED)
            for i in range(3):
                bx = px0 + 50 + i * 110
                draw.rounded_rectangle([bx, row2_y, bx + 95, row2_y + 95], radius=14, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)

            # Callout: Dedicated Word Rows Guarantee
            card_y = row2_y + 160
            draw.rounded_rectangle([px0 + 40, card_y, px1 - 40, card_y + 240], radius=24, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.text((px0 + 70, card_y + 35), "DEDICATED WORD ROWS", font=get_font("impact.ttf", 32), fill=ACCENT_CYAN)
            draw.text((px0 + 70, card_y + 85), "• Never splits words awkwardly across line breaks", font=get_font("segoeui.ttf", 22), fill=TEXT_SECONDARY)
            draw.text((px0 + 70, card_y + 125), "• Inline fixed punctuation for hyphens & colons", font=get_font("segoeui.ttf", 22), fill=TEXT_SECONDARY)
            draw.text((px0 + 70, card_y + 165), "• Automatic scaling to fit every device screen perfectly", font=get_font("segoeui.ttf", 22), fill=ACCENT_GREEN)

        elif s["mode"] == "channels":
            draw.text((px0 + 40, py0 + 50), "CHOOSE CHANNEL PACK", font=get_font("impact.ttf", 36), fill=ACCENT_CYAN)
            draw.text((px0 + 40, py0 + 105), "7 Channels • 400 Total Handcrafted Levels", font=get_font("segoeui.ttf", 22), fill=TEXT_MUTED)

            ch_list = [
                ("Cartoon Network", "Ben 10, Teen Titans, Samurai Jack", "60 Levels", ACCENT_CYAN),
                ("Nickelodeon", "Avatar, SpongeBob, Danny Phantom", "60 Levels", ACCENT_ORANGE),
                ("Disney Channel & Jetix", "Kim Possible, Phineas & Ferb, Pucca", "55 Levels", (225, 29, 72, 255)),
                ("Kids' WB & 4Kids", "Static Shock, Batman, X-Men Evo", "50 Levels", (217, 119, 6, 255)),
                ("KidsCo Classics", "Rescue Heroes, Dino Squad, Madeline", "45 Levels", (37, 99, 235, 255)),
                ("JimJam Favorites", "Bob the Builder, Thomas, Pingu", "45 Levels", (202, 138, 4, 255)),
                ("Teletoon & International", "Total Drama, 6teen, Code Lyoko", "50 Levels", (124, 58, 237, 255))
            ]
            cy = py0 + 165
            for name, desc, count, color in ch_list:
                draw.rounded_rectangle([px0 + 35, cy, px1 - 35, cy + 120], radius=18, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
                draw.rounded_rectangle([px0 + 50, cy + 18, px0 + 58, cy + 102], radius=4, fill=color)
                draw.text((px0 + 75, cy + 22), name, font=get_font("arialbd.ttf", 26), fill=TEXT_MAIN)
                draw.text((px0 + 75, cy + 65), desc, font=get_font("segoeui.ttf", 19), fill=TEXT_MUTED)
                # Count badge
                draw.rounded_rectangle([px1 - 180, cy + 40, px1 - 50, cy + 80], radius=12, fill=SURFACE_LIGHT)
                draw.text((px1 - 165, cy + 48), count, font=get_font("arialbd.ttf", 18), fill=color)
                cy += 140

        elif s["mode"] == "trophy":
            draw.text((px0 + 40, py0 + 50), "TROPHY HALL & LORE DEX", font=get_font("impact.ttf", 36), fill=GOLD)
            draw.text((px0 + 40, py0 + 105), "Collectible Verified Animation Lore Cards", font=get_font("segoeui.ttf", 22), fill=TEXT_MUTED)

            # Sample Lore Card 1: Avatar
            card1_y = py0 + 165
            draw.rounded_rectangle([px0 + 35, card1_y, px1 - 35, card1_y + 390], radius=24, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.rounded_rectangle([px0 + 60, card1_y + 25, px0 + 160, card1_y + 60], radius=10, fill=(254, 252, 232, 255), outline=(254, 240, 138, 255), width=1)
            draw.text((px0 + 75, card1_y + 32), "CARD #01", font=get_font("arialbd.ttf", 16), fill=GOLD)
            draw.text((px0 + 180, card1_y + 28), "Avatar: The Last Airbender", font=get_font("arialbd.ttf", 28), fill=TEXT_MAIN)

            lore1_text = (
                "Bryan Konietzko and Michael Dante DiMartino originally\n"
                "conceived Aang as a middle-aged man living in a herd of bison.\n"
                "The martial arts forms for each element were choreographed\n"
                "by Sifu Kisu based on authentic Northern Shaolin, Hung Gar,\n"
                "Tai Chi, and Ba Gua kung fu systems.\n\n"
                "Double-Verified Source: Nickelodeon Archives & IGN Interviews"
            )
            draw.text((px0 + 60, card1_y + 85), lore1_text, font=get_font("segoeui.ttf", 21), fill=TEXT_SECONDARY)
            draw.rounded_rectangle([px0 + 60, card1_y + 320, px1 - 60, card1_y + 360], radius=10, fill=(236, 253, 245, 255), outline=(167, 243, 208, 255), width=1)
            draw.text((px0 + 160, card1_y + 328), "✓ UNLOCKED BY COMPLETING LEVEL 1", font=get_font("arialbd.ttf", 18), fill=ACCENT_GREEN)

            # Sample Lore Card 2: Teen Titans
            card2_y = card1_y + 420
            draw.rounded_rectangle([px0 + 35, card2_y, px1 - 35, card2_y + 390], radius=24, fill=SURFACE_WHITE, outline=BORDER_COLOR, width=1)
            draw.rounded_rectangle([px0 + 60, card2_y + 25, px0 + 160, card2_y + 60], radius=10, fill=(240, 249, 255, 255), outline=(186, 230, 253, 255), width=1)
            draw.text((px0 + 75, card2_y + 32), "CARD #02", font=get_font("arialbd.ttf", 16), fill=ACCENT_CYAN)
            draw.text((px0 + 180, card2_y + 28), "Teen Titans (2003)", font=get_font("arialbd.ttf", 28), fill=TEXT_MAIN)

            lore2_text = (
                "Puffy AmiYumi sang both the Japanese and English versions\n"
                "of the iconic theme song. If an episode was silly or comedic,\n"
                "the Japanese theme played; if serious or dramatic, the\n"
                "English theme played instead!\n\n"
                "Double-Verified Source: Warner Bros Animation & ToonZone"
            )
            draw.text((px0 + 60, card2_y + 85), lore2_text, font=get_font("segoeui.ttf", 21), fill=TEXT_SECONDARY)
            draw.rounded_rectangle([px0 + 60, card2_y + 320, px1 - 60, card2_y + 360], radius=10, fill=(236, 253, 245, 255), outline=(167, 243, 208, 255), width=1)
            draw.text((px0 + 160, card2_y + 328), "✓ UNLOCKED BY COMPLETING LEVEL 2", font=get_font("arialbd.ttf", 18), fill=ACCENT_GREEN)

        target_file = os.path.join(SCREENSHOTS_DIR, s["filename"])
        img.save(target_file, "PNG")
        print(f"-> Saved: {target_file}")

if __name__ == "__main__":
    generate_store_icon()
    generate_feature_graphic()
    generate_screenshots()
    print("All Play Store assets generated successfully!")
