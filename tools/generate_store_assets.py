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

# Color Palette Constants
BG_DARK = (18, 18, 30, 255)       # #12121E
SURFACE_DARK = (26, 26, 46, 255)  # #1A1A2E
SURFACE_LIGHT = (40, 40, 70, 255)
ACCENT_GREEN = (57, 255, 20, 255) # #39FF14 (Neon Slime Green)
ACCENT_CYAN = (0, 240, 255, 255)  # #00F0FF (Electric Cyan)
ACCENT_ORANGE = (255, 107, 53, 255)# #FF6B35
TEXT_WHITE = (240, 240, 255, 255)
TEXT_MUTED = (160, 160, 192, 255)
GRID_LINE = (35, 35, 60, 255)
GOLD = (255, 215, 0, 255)

# Fonts
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
    else:
        # Fallback procedural icon
        img = Image.new("RGBA", (512, 512), BG_DARK)
        draw = ImageDraw.Draw(img)
        draw_grid_background(draw, 512, 512, 40)
        draw.rounded_rectangle([60, 100, 452, 430], radius=40, fill=ACCENT_ORANGE, outline=(0,0,0,255), width=8)
        draw.rounded_rectangle([90, 130, 370, 390], radius=24, fill=ACCENT_CYAN, outline=(0,180,200,255), width=4)
        img.save(target_path, "PNG")
    print(f"-> Saved: {target_path}")

# ==========================================
# 2. FEATURE GRAPHIC (1024 x 500)
# ==========================================
def generate_feature_graphic():
    print("Generating Feature Graphic (1024x500)...")
    width, height = 1024, 500
    img = Image.new("RGBA", (width, height), BG_DARK)
    draw = ImageDraw.Draw(img)
    draw_grid_background(draw, width, height, 50)

    # Ambient glow blobs
    # Slime glow left
    for r in range(200, 50, -30):
        alpha = int(12 * (1 - r/200))
        draw.ellipse([80 - r, 250 - r, 80 + r, 250 + r], fill=(57, 255, 20, alpha))
    # Cyan glow right
    for r in range(250, 60, -30):
        alpha = int(15 * (1 - r/250))
        draw.ellipse([900 - r, 200 - r, 900 + r, 200 + r], fill=(0, 240, 255, alpha))

    # --- LEFT SIDE: RETRO CRT TV ILLUSTRATION ---
    tv_cx, tv_cy = 240, 250
    # Antenna
    draw.line([(tv_cx - 20, tv_cy - 120), (tv_cx - 90, tv_cy - 200)], fill=(180, 180, 200, 255), width=8)
    draw.ellipse([tv_cx - 105, tv_cy - 215, tv_cx - 75, tv_cy - 185], fill=(220, 220, 240, 255))
    draw.line([(tv_cx + 20, tv_cy - 120), (tv_cx + 90, tv_cy - 200)], fill=(180, 180, 200, 255), width=8)
    draw.ellipse([tv_cx + 75, tv_cy - 215, tv_cx + 105, tv_cy - 185], fill=(220, 220, 240, 255))

    # TV Body
    tv_box = [tv_cx - 160, tv_cy - 120, tv_cx + 160, tv_cy + 130]
    draw.rounded_rectangle(tv_box, radius=36, fill=ACCENT_ORANGE, outline=(0, 0, 0, 255), width=7)

    # TV Screen
    screen_box = [tv_cx - 140, tv_cy - 100, tv_cx + 80, tv_cy + 110]
    draw.rounded_rectangle(screen_box, radius=24, fill=(15, 15, 28, 255), outline=(0, 0, 0, 255), width=4)

    # Crossword tiles on TV screen
    tile_w = 40
    for r in range(4):
        for c in range(4):
            tx = screen_box[0] + 16 + c * (tile_w + 6)
            ty = screen_box[1] + 16 + r * (tile_w + 6)
            is_green = (r, c) in [(1, 1), (1, 2), (2, 2)]
            col = ACCENT_GREEN if is_green else (240, 240, 255, 255)
            draw.rounded_rectangle([tx, ty, tx + tile_w, ty + tile_w], radius=6, fill=col)

    # Slime drip over TV corner
    slime_pts = [
        (tv_cx - 120, tv_cy - 100), (tv_cx - 80, tv_cy - 70), (tv_cx - 70, tv_cy - 40),
        (tv_cx - 85, tv_cy - 45), (tv_cx - 110, tv_cy - 80)
    ]
    draw.polygon(slime_pts, fill=ACCENT_GREEN)

    # TV Knobs & Speaker grille
    knob_x = tv_cx + 118
    draw.ellipse([knob_x - 18, tv_cy - 70, knob_x + 18, tv_cy - 34], fill=(50, 50, 60, 255), outline=(0,0,0,255), width=3)
    draw.ellipse([knob_x - 18, tv_cy - 15, knob_x + 18, tv_cy + 21], fill=(50, 50, 60, 255), outline=(0,0,0,255), width=3)
    for g in range(4):
        gy = tv_cy + 50 + g * 12
        draw.line([(knob_x - 18, gy), (knob_x + 18, gy)], fill=(40, 40, 50, 255), width=4)

    # --- RIGHT SIDE: TYPOGRAPHY & HOOKS ---
    tx_start = 450
    # Top Tagline Badge
    badge_box = [tx_start, 60, tx_start + 450, 102]
    draw.rounded_rectangle(badge_box, radius=20, fill=(35, 35, 60, 255), outline=ACCENT_GREEN, width=2)
    font_badge = get_font("arialbd.ttf", 20)
    draw.text((tx_start + 24, 70), "★ 400 HANDCRAFTED NOSTALGIC LEVELS ★", font=font_badge, fill=ACCENT_GREEN)

    # Main Headline
    font_title1 = get_font("impact.ttf", 58)
    font_title2 = get_font("impact.ttf", 52)
    draw.text((tx_start, 115), "2000s TOON", font=font_title1, fill=(255, 255, 255, 255))
    draw.text((tx_start, 175), "CROSSWORDS", font=font_title2, fill=ACCENT_CYAN)

    # Core Value Prop
    font_sub = get_font("arialbd.ttf", 22)
    draw.text((tx_start, 245), "Are you a child of the 2000s? You must play this!", font=font_sub, fill=ACCENT_ORANGE)

    font_body = get_font("segoeui.ttf", 20)
    draw.text((tx_start, 280), "• Dual Modes: Classic Crosswords & Emoji Title Rebuses", font=font_body, fill=TEXT_WHITE)
    draw.text((tx_start, 310), "• 100% Offline • Zero Ads • No Trackers • Infinite Replay", font=font_body, fill=TEXT_WHITE)

    # Channel Pack Badges Footer
    ch_y = 360
    channels = ["CARTOON NETWORK", "NICKELODEON", "DISNEY/JETIX", "KIDS' WB", "KIDSCO", "JIMJAM", "TELETOON"]
    cx = tx_start
    font_ch = get_font("arialbd.ttf", 13)
    for ch in channels:
        tw = int(draw.textlength(ch, font=font_ch))
        if cx + tw + 16 > 990:
            cx = tx_start
            ch_y += 34
        c_box = [cx, ch_y, cx + tw + 16, ch_y + 26]
        draw.rounded_rectangle(c_box, radius=12, fill=(28, 28, 48, 255), outline=(60, 60, 90, 255), width=1)
        draw.text((cx + 8, ch_y + 5), ch, font=font_ch, fill=ACCENT_CYAN)
        cx += tw + 22

    # Bottom Right Verification Shield
    shield_box = [tx_start, 430, 980, 470]
    draw.rounded_rectangle(shield_box, radius=10, fill=(20, 35, 25, 255), outline=ACCENT_GREEN, width=1)
    font_shield = get_font("arialbd.ttf", 16)
    draw.text((tx_start + 18, 440), "🔒 100% PREMIUM OFFLINE EXPERIENCE • UNLOCK 200+ TRIVIA LORE CARDS", font=font_shield, fill=ACCENT_GREEN)

    target_path = os.path.join(OUTPUT_DIR, "feature_graphic.png")
    img.save(target_path, "PNG")
    print(f"-> Saved: {target_path}")

# ==========================================
# 3. PHONE SCREENSHOT MOCKUPS (1080 x 1920)
# ==========================================
def draw_phone_frame(draw, x0, y0, x1, y1):
    # Device outer chassis
    draw.rounded_rectangle([x0, y0, x1, y1], radius=60, fill=(30, 30, 42, 255), outline=(70, 70, 95, 255), width=8)
    # Inner display area
    disp_x0, disp_y0 = x0 + 16, y0 + 16
    disp_x1, disp_y1 = x1 - 16, y1 - 16
    draw.rounded_rectangle([disp_x0, disp_y0, disp_x1, disp_y1], radius=48, fill=BG_DARK)
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
            "sub": "Interactive Grids from Easy 8x8 to Expert 12x12",
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
            "sub": "Every Puzzle Reveals Behind-The-Scenes Production Secrets",
            "mode": "trophy"
        }
    ]

    for s in screens:
        print(f"Generating Screenshot: {s['filename']} (1080x1920)...")
        img = Image.new("RGBA", (w, h), BG_DARK)
        draw = ImageDraw.Draw(img)
        draw_grid_background(draw, w, h, 60)

        # TOP MARKETING COPY
        # Tag Badge
        font_tag = get_font("arialbd.ttf", 26)
        tw = int(draw.textlength(s["tag"], font=font_tag))
        tag_x = (w - tw) // 2
        draw.rounded_rectangle([tag_x - 24, 70, tag_x + tw + 24, 120], radius=25, fill=(30, 45, 35, 255), outline=ACCENT_GREEN, width=2)
        draw.text((tag_x, 80), s["tag"], font=font_tag, fill=ACCENT_GREEN)

        # Big Headline
        font_head = get_font("impact.ttf", 56)
        hw = int(draw.textlength(s["headline"], font=font_head))
        draw.text(((w - hw) // 2, 140), s["headline"], font=font_head, fill=TEXT_WHITE)

        # Subtitle
        font_sub = get_font("segoeui.ttf", 28)
        sw = int(draw.textlength(s["sub"], font=font_sub))
        draw.text(((w - sw) // 2, 215), s["sub"], font=font_sub, fill=ACCENT_CYAN)

        # PHONE FRAME (Coordinates: 80, 290 to 1000, 1850)
        px0, py0, px1, py1 = draw_phone_frame(draw, 100, 280, 980, 1860)

        # RENDER SCREEN CONTENTS
        if s["mode"] == "home":
            # Header
            draw.text((px0 + 50, py0 + 60), "2000s TOON CROSSWORDS", font=get_font("impact.ttf", 46), fill=ACCENT_GREEN)
            draw.text((px0 + 50, py0 + 120), "Retro Puzzle Station • v1.0.0", font=get_font("segoeui.ttf", 24), fill=TEXT_MUTED)

            # Daily Streak Banner
            draw.rounded_rectangle([px0 + 40, py0 + 180, px1 - 40, py0 + 300], radius=24, fill=SURFACE_DARK, outline=ACCENT_ORANGE, width=3)
            draw.text((px0 + 70, py0 + 205), "🔥 5 DAY STREAK", font=get_font("arialbd.ttf", 34), fill=ACCENT_ORANGE)
            draw.text((px0 + 70, py0 + 250), "+100 Coins Daily Streak Bonus Awarded!", font=get_font("segoeui.ttf", 22), fill=TEXT_WHITE)

            # Mode Card 1: Classic Crosswords
            c1_y = py0 + 340
            draw.rounded_rectangle([px0 + 40, c1_y, px1 - 40, c1_y + 240], radius=28, fill=SURFACE_DARK, outline=(50, 70, 90, 255), width=2)
            draw.rounded_rectangle([px0 + 65, c1_y + 35, px0 + 175, c1_y + 145], radius=18, fill=ACCENT_CYAN)
            draw.text((px0 + 95, c1_y + 60), "✏️", font=get_font("segoeui.ttf", 44), fill=BG_DARK)
            draw.text((px0 + 200, c1_y + 45), "Classic Crosswords", font=get_font("arialbd.ttf", 36), fill=TEXT_WHITE)
            draw.text((px0 + 200, c1_y + 95), "200 Grids • 7x7 to 12x12 • Word Lock", font=get_font("segoeui.ttf", 24), fill=ACCENT_CYAN)
            draw.rounded_rectangle([px0 + 200, c1_y + 150, px1 - 70, c1_y + 205], radius=16, fill=ACCENT_GREEN)
            draw.text((px0 + 320, c1_y + 162), "PLAY NOW", font=get_font("arialbd.ttf", 26), fill=BG_DARK)

            # Mode Card 2: Emoji Rebus
            c2_y = py0 + 610
            draw.rounded_rectangle([px0 + 40, c2_y, px1 - 40, c2_y + 240], radius=28, fill=SURFACE_DARK, outline=(50, 70, 90, 255), width=2)
            draw.rounded_rectangle([px0 + 65, c2_y + 35, px0 + 175, c2_y + 145], radius=18, fill=ACCENT_ORANGE)
            draw.text((px0 + 95, c2_y + 60), "🧩", font=get_font("segoeui.ttf", 44), fill=BG_DARK)
            draw.text((px0 + 200, c2_y + 45), "Emoji Title Rebus", font=get_font("arialbd.ttf", 36), fill=TEXT_WHITE)
            draw.text((px0 + 200, c2_y + 95), "200 Riddles • Visual Puns • Dedicated Rows", font=get_font("segoeui.ttf", 24), fill=ACCENT_ORANGE)
            draw.rounded_rectangle([px0 + 200, c2_y + 150, px1 - 70, c2_y + 205], radius=16, fill=ACCENT_CYAN)
            draw.text((px0 + 320, c2_y + 162), "PLAY NOW", font=get_font("arialbd.ttf", 26), fill=BG_DARK)

            # Trophy Hall Card
            c3_y = py0 + 880
            draw.rounded_rectangle([px0 + 40, c3_y, px1 - 40, c3_y + 200], radius=28, fill=SURFACE_DARK, outline=(60, 60, 85, 255), width=2)
            draw.text((px0 + 70, c3_y + 40), "🏆 The Trophy Dex & Lore Hall", font=get_font("arialbd.ttf", 32), fill=GOLD)
            draw.text((px0 + 70, c3_y + 90), "48 / 400 Verified Trivia Lore Cards Unlocked", font=get_font("segoeui.ttf", 24), fill=TEXT_MUTED)
            # Progress bar
            draw.rounded_rectangle([px0 + 70, c3_y + 140, px1 - 70, c3_y + 160], radius=10, fill=(40, 40, 60, 255))
            draw.rounded_rectangle([px0 + 70, c3_y + 140, px0 + 280, c3_y + 160], radius=10, fill=GOLD)

        elif s["mode"] == "crossword":
            # Top Ribbon: Level & Coin
            draw.text((px0 + 40, py0 + 50), "LEVEL 14: CARTOON NETWORK", font=get_font("impact.ttf", 36), fill=ACCENT_GREEN)
            draw.text((px1 - 200, py0 + 55), "💰 1,450 COINS", font=get_font("arialbd.ttf", 22), fill=GOLD)

            # Clue Ribbon
            draw.rounded_rectangle([px0 + 40, py0 + 110, px1 - 40, py0 + 200], radius=16, fill=(35, 45, 65, 255), outline=ACCENT_CYAN, width=2)
            draw.text((px0 + 60, py0 + 125), "2 ACROSS (7 Letters)", font=get_font("arialbd.ttf", 24), fill=ACCENT_CYAN)
            draw.text((px0 + 60, py0 + 158), "Wielder of the Omnitrix alien device (First & Last)", font=get_font("segoeui.ttf", 22), fill=TEXT_WHITE)

            # Crossword Grid (8x8)
            grid_y = py0 + 230
            cell_size = 90
            grid_x_start = px0 + 50
            sample_grid = [
                ["B","E","N","T","E","N","N","Y"],
                [None,None,"A",None,None,None,"E",None],
                ["S","A","M","U","R","A","I",None],
                [None,None,"U",None,None,None,"T",None],
                [None,None,"R",None,"R","E","X",None],
                ["C","H","O","W","D","E","R",None],
                [None,None,"I",None,None,None,None,None],
                ["F","L","A","P","J","A","C","K"]
            ]
            for r in range(8):
                for c in range(8):
                    char = sample_grid[r][c]
                    cx = grid_x_start + c * 92
                    cy = grid_y + r * 92
                    if char is not None:
                        is_locked = (r == 0 or r == 5)
                        bg_col = (45, 140, 55, 255) if is_locked else SURFACE_DARK
                        bdr_col = ACCENT_GREEN if is_locked else (80, 80, 110, 255)
                        draw.rounded_rectangle([cx, cy, cx + cell_size, cy + cell_size], radius=12, fill=bg_col, outline=bdr_col, width=2)
                        draw.text((cx + 30, cy + 22), char, font=get_font("impact.ttf", 40), fill=TEXT_WHITE)
                        if is_locked:
                            draw.text((cx + cell_size - 22, cy + 4), "✓", font=get_font("arialbd.ttf", 16), fill=ACCENT_GREEN)

            # Keyboard area
            kb_y = py0 + 1010
            draw.rounded_rectangle([px0 + 30, kb_y, px1 - 30, py1 - 30], radius=24, fill=(22, 22, 34, 255), outline=(50, 50, 70, 255), width=2)
            # Hint bar
            draw.rounded_rectangle([px0 + 50, kb_y + 20, px0 + 280, kb_y + 80], radius=14, fill=(40, 55, 45, 255), outline=ACCENT_GREEN, width=1)
            draw.text((px0 + 75, kb_y + 36), "💡 1st Letter (50)", font=get_font("arialbd.ttf", 20), fill=ACCENT_GREEN)
            draw.rounded_rectangle([px0 + 300, kb_y + 20, px0 + 530, kb_y + 80], radius=14, fill=(55, 45, 40, 255), outline=ACCENT_ORANGE, width=1)
            draw.text((px0 + 325, kb_y + 36), "🎲 Random (100)", font=get_font("arialbd.ttf", 20), fill=ACCENT_ORANGE)
            draw.rounded_rectangle([px0 + 550, kb_y + 20, px1 - 50, kb_y + 80], radius=14, fill=(50, 35, 60, 255), outline=(220, 100, 255, 255), width=1)
            draw.text((px0 + 575, kb_y + 36), "⚡ Solve Word (250)", font=get_font("arialbd.ttf", 20), fill=(220, 150, 255, 255))

        elif s["mode"] == "rebus":
            # Header
            draw.text((px0 + 40, py0 + 50), "LEVEL 42: MYSTERY REBUS", font=get_font("impact.ttf", 36), fill=ACCENT_ORANGE)
            draw.text((px1 - 200, py0 + 55), "💰 2,100 COINS", font=get_font("arialbd.ttf", 22), fill=GOLD)

            # Big Emoji Card
            rebus_box = [px0 + 40, py0 + 120, px1 - 40, py0 + 360]
            draw.rounded_rectangle(rebus_box, radius=32, fill=SURFACE_DARK, outline=ACCENT_ORANGE, width=3)
            draw.text((px0 + 120, py0 + 170), "👽   ⌚   🔟", font=get_font("segoeui.ttf", 72), fill=TEXT_WHITE)
            draw.text((px0 + 180, py0 + 290), "DECODE THE CARTOON NETWORK TITLE", font=get_font("arialbd.ttf", 22), fill=ACCENT_CYAN)

            # Dedicated Word Rows Feature Highlight
            row_y = py0 + 420
            # Word 1: [B][E][N]
            draw.text((px0 + 50, row_y - 35), "WORD 1 (3 LETTERS)", font=get_font("arialbd.ttf", 20), fill=ACCENT_GREEN)
            for i, letter in enumerate(["B", "E", "N"]):
                bx = px0 + 50 + i * 110
                draw.rounded_rectangle([bx, row_y, bx + 95, row_y + 95], radius=16, fill=(35, 120, 45, 255), outline=ACCENT_GREEN, width=3)
                draw.text((bx + 32, row_y + 22), letter, font=get_font("impact.ttf", 44), fill=TEXT_WHITE)

            # Word 2: [1][0] or [T][E][N]
            row2_y = row_y + 170
            draw.text((px0 + 50, row2_y - 35), "WORD 2 (3 LETTERS)", font=get_font("arialbd.ttf", 20), fill=TEXT_MUTED)
            for i, letter in enumerate(["T", "E", "N"]):
                bx = px0 + 50 + i * 110
                draw.rounded_rectangle([bx, row2_y, bx + 95, row2_y + 95], radius=16, fill=(35, 120, 45, 255), outline=ACCENT_GREEN, width=3)
                draw.text((bx + 32, row2_y + 22), letter, font=get_font("impact.ttf", 44), fill=TEXT_WHITE)

            # Solved Card Callout
            card_y = row2_y + 160
            draw.rounded_rectangle([px0 + 40, card_y, px1 - 40, card_y + 360], radius=24, fill=(20, 40, 30, 255), outline=ACCENT_GREEN, width=2)
            draw.text((px0 + 70, card_y + 35), "🎉 LEVEL SOLVED: BEN 10!", font=get_font("impact.ttf", 36), fill=ACCENT_GREEN)
            draw.text((px0 + 70, card_y + 90), "+100 Coins Earned  •  Trivia Lore Unlocked", font=get_font("arialbd.ttf", 24), fill=GOLD)

            trivia_text = (
                "Created by Man of Action, Ben 10 debuted on Cartoon\n"
                "Network in December 2005. The Omnitrix originally allowed\n"
                "Ben Tennyson to transform into 10 alien superheroes\n"
                "starting with Heatblast, Diamondhead, and XLR8!"
            )
            draw.text((px0 + 70, card_y + 150), trivia_text, font=get_font("segoeui.ttf", 22), fill=TEXT_WHITE)

        elif s["mode"] == "channels":
            draw.text((px0 + 40, py0 + 50), "CHOOSE CHANNEL PACK", font=get_font("impact.ttf", 38), fill=ACCENT_CYAN)
            draw.text((px0 + 40, py0 + 105), "7 Channels • 400 Total Pre-Compiled Levels", font=get_font("segoeui.ttf", 24), fill=TEXT_MUTED)

            ch_list = [
                ("Cartoon Network", "Ben 10, Teen Titans, Samurai Jack", "60 Levels", ACCENT_GREEN),
                ("Nickelodeon", "Avatar, SpongeBob, Danny Phantom", "60 Levels", ACCENT_ORANGE),
                ("Disney Channel & Jetix", "Kim Possible, Phineas & Ferb, Pucca", "55 Levels", ACCENT_CYAN),
                ("Kids' WB & 4Kids", "Static Shock, Batman, X-Men Evo", "50 Levels", (255, 80, 120, 255)),
                ("KidsCo Classics", "Rescue Heroes, Dino Squad, Madeline", "45 Levels", (255, 215, 0, 255)),
                ("JimJam Favorites", "Bob the Builder, Thomas, Pingu", "45 Levels", (100, 220, 255, 255)),
                ("Teletoon & International", "Total Drama, 6teen, Code Lyoko", "50 Levels", (180, 120, 255, 255))
            ]
            cy = py0 + 170
            for name, desc, count, color in ch_list:
                draw.rounded_rectangle([px0 + 35, cy, px1 - 35, cy + 125], radius=20, fill=SURFACE_DARK, outline=(50, 50, 75, 255), width=2)
                draw.rounded_rectangle([px0 + 50, cy + 20, px0 + 60, cy + 105], radius=5, fill=color)
                draw.text((px0 + 80, cy + 22), name, font=get_font("arialbd.ttf", 28), fill=TEXT_WHITE)
                draw.text((px0 + 80, cy + 65), desc, font=get_font("segoeui.ttf", 20), fill=TEXT_MUTED)
                # Count badge
                draw.rounded_rectangle([px1 - 200, cy + 40, px1 - 55, cy + 85], radius=14, fill=(35, 35, 55, 255), outline=color, width=1)
                draw.text((px1 - 180, cy + 48), count, font=get_font("arialbd.ttf", 20), fill=color)
                cy += 145

        elif s["mode"] == "trophy":
            draw.text((px0 + 40, py0 + 50), "TROPHY HALL & LORE DEX", font=get_font("impact.ttf", 38), fill=GOLD)
            draw.text((px0 + 40, py0 + 105), "Collectible Verified Animation Lore Cards", font=get_font("segoeui.ttf", 24), fill=TEXT_MUTED)

            # Sample Lore Card 1: Avatar
            card1_y = py0 + 170
            draw.rounded_rectangle([px0 + 35, card1_y, px1 - 35, card1_y + 400], radius=26, fill=SURFACE_DARK, outline=GOLD, width=2)
            draw.rounded_rectangle([px0 + 60, card1_y + 30, px0 + 160, card1_y + 68], radius=12, fill=(80, 60, 20, 255), outline=GOLD, width=1)
            draw.text((px0 + 75, card1_y + 36), "CARD #01", font=get_font("arialbd.ttf", 18), fill=GOLD)
            draw.text((px0 + 180, card1_y + 32), "Avatar: The Last Airbender", font=get_font("arialbd.ttf", 30), fill=TEXT_WHITE)

            lore1_text = (
                "Bryan Konietzko and Michael Dante DiMartino originally\n"
                "conceived Aang as a middle-aged man living in a herd of bison.\n"
                "The martial arts forms for each element were choreographed\n"
                "by Sifu Kisu based on authentic Northern Shaolin, Hung Gar,\n"
                "Tai Chi, and Ba Gua kung fu systems.\n\n"
                "Double-Verified Source: Nickelodeon Archives & IGN Interviews"
            )
            draw.text((px0 + 60, card1_y + 90), lore1_text, font=get_font("segoeui.ttf", 22), fill=(220, 220, 240, 255))
            draw.rounded_rectangle([px0 + 60, card1_y + 320, px1 - 60, card1_y + 365], radius=12, fill=(30, 50, 35, 255), outline=ACCENT_GREEN, width=1)
            draw.text((px0 + 160, card1_y + 330), "✓ UNLOCKED BY COMPLETING LEVEL 1", font=get_font("arialbd.ttf", 20), fill=ACCENT_GREEN)

            # Sample Lore Card 2: Teen Titans
            card2_y = card1_y + 430
            draw.rounded_rectangle([px0 + 35, card2_y, px1 - 35, card2_y + 400], radius=26, fill=SURFACE_DARK, outline=ACCENT_CYAN, width=2)
            draw.rounded_rectangle([px0 + 60, card2_y + 30, px0 + 160, card2_y + 68], radius=12, fill=(20, 50, 70, 255), outline=ACCENT_CYAN, width=1)
            draw.text((px0 + 75, card2_y + 36), "CARD #02", font=get_font("arialbd.ttf", 18), fill=ACCENT_CYAN)
            draw.text((px0 + 180, card2_y + 32), "Teen Titans (2003)", font=get_font("arialbd.ttf", 30), fill=TEXT_WHITE)

            lore2_text = (
                "Puffy AmiYumi sang both the Japanese and English versions\n"
                "of the iconic theme song. If an episode was silly or comedic,\n"
                "the Japanese theme played; if serious or dramatic, the\n"
                "English theme played instead!\n\n"
                "Double-Verified Source: Warner Bros Animation & ToonZone"
            )
            draw.text((px0 + 60, card2_y + 90), lore2_text, font=get_font("segoeui.ttf", 22), fill=(220, 220, 240, 255))
            draw.rounded_rectangle([px0 + 60, card2_y + 320, px1 - 60, card2_y + 365], radius=12, fill=(30, 50, 35, 255), outline=ACCENT_GREEN, width=1)
            draw.text((px0 + 160, card2_y + 330), "✓ UNLOCKED BY COMPLETING LEVEL 2", font=get_font("arialbd.ttf", 20), fill=ACCENT_GREEN)

        target_file = os.path.join(SCREENSHOTS_DIR, s["filename"])
        img.save(target_file, "PNG")
        print(f"-> Saved: {target_file}")

if __name__ == "__main__":
    generate_store_icon()
    generate_feature_graphic()
    generate_screenshots()
    print("All Play Store assets generated successfully!")
