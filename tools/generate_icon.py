"""
Procedural High-Resolution App Icon Generator for 2000s Toon Crosswords
Generates 512x512 store icon and all Android/Web mipmap launcher densities:
- Motif: Retro bubble CRT television with antenna ears broadcasting lime-green
  slime splatters over puzzle grid squares.
- Color Palette: Slime Green (#39FF14), Electric Cyan (#00F0FF),
  Cheerful Orange (#FF6B35), Deep Space Black (#12121E).
"""

import os
from PIL import Image, ImageDraw

def create_brand_icon():
    size = (512, 512)
    img = Image.new("RGBA", size, (18, 18, 30, 255)) # Deep Space Black
    draw = ImageDraw.Draw(img)

    # 1. Background Crossword Grid Motif
    grid_color = (30, 30, 50, 255)
    line_color = (45, 45, 75, 255)
    for r in range(4):
        for c in range(4):
            x0 = 40 + c * 110
            y0 = 40 + r * 110
            draw.rectangle([x0, y0, x0 + 100, y0 + 100], fill=grid_color, outline=line_color, width=3)

    # 2. Antenna Ears (Rabbit Ears with Foil Balls)
    # Left antenna
    draw.line([(256, 170), (140, 50)], fill=(180, 180, 200, 255), width=10)
    draw.ellipse([125, 35, 155, 65], fill=(220, 220, 240, 255), outline=(100, 100, 120, 255), width=3)
    # Right antenna
    draw.line([(256, 170), (370, 50)], fill=(180, 180, 200, 255), width=10)
    draw.ellipse([355, 35, 385, 65], fill=(220, 220, 240, 255), outline=(100, 100, 120, 255), width=3)

    # 3. Retro Bubble CRT TV Body (Cheerful Orange #FF6B35)
    tv_outer = [70, 140, 442, 450]
    draw.rounded_rectangle(tv_outer, radius=48, fill=(255, 107, 53, 255), outline=(0, 0, 0, 255), width=8)

    # TV Drop shadow line
    draw.arc(tv_outer, start=0, end=180, fill=(200, 60, 20, 255), width=6)

    # 4. CRT Bezel & Screen (Electric Cyan #00F0FF)
    bezel = [100, 170, 370, 420]
    draw.rounded_rectangle(bezel, radius=32, fill=(20, 20, 35, 255), outline=(0, 0, 0, 255), width=6)

    screen = [112, 182, 358, 408]
    draw.rounded_rectangle(screen, radius=24, fill=(0, 240, 255, 255), outline=(0, 180, 200, 255), width=4)

    # 5. Inside Screen: Crossword Tiles (White & Black)
    tile_size = 46
    # 2x2 grid inside screen
    coords = [
        (150, 230, "T"),
        (200, 230, "O"),
        (250, 230, "O"),
        (200, 280, "N")
    ]
    for x, y, letter in coords:
        draw.rectangle([x, y, x + tile_size, y + tile_size], fill=(255, 253, 247, 255), outline=(0, 0, 0, 255), width=3)

    # 6. TV Control Knobs on Right Side
    # Knob 1
    draw.ellipse([385, 200, 425, 240], fill=(40, 40, 55, 255), outline=(0, 0, 0, 255), width=4)
    draw.line([(405, 205), (405, 235)], fill=(255, 255, 255, 255), width=4)
    # Knob 2
    draw.ellipse([385, 260, 425, 300], fill=(40, 40, 55, 255), outline=(0, 0, 0, 255), width=4)
    draw.line([(390, 280), (420, 280)], fill=(255, 255, 255, 255), width=4)
    # Speaker grille lines
    for sy in [330, 345, 360, 375, 390]:
        draw.line([(385, sy), (425, sy)], fill=(30, 30, 40, 255), width=3)

    # 7. Lime-Green Slime Splatters (#39FF14)
    slime_color = (57, 255, 20, 255)
    slime_outline = (20, 160, 10, 255)

    # Top slime drip on TV edge
    draw.ellipse([140, 125, 220, 165], fill=slime_color, outline=slime_outline, width=3)
    draw.ellipse([160, 150, 185, 200], fill=slime_color) # drip 1
    draw.ellipse([200, 150, 218, 185], fill=slime_color) # drip 2

    # Corner slime splatter
    draw.ellipse([300, 360, 380, 430], fill=slime_color, outline=slime_outline, width=3)
    draw.ellipse([360, 340, 390, 370], fill=slime_color)
    draw.ellipse([280, 410, 310, 435], fill=slime_color)
    draw.ellipse([320, 420, 345, 455], fill=slime_color) # hanging drip

    # Random flying droplet
    draw.ellipse([90, 270, 115, 295], fill=slime_color, outline=slime_outline, width=2)
    draw.ellipse([310, 130, 325, 145], fill=slime_color)

    return img

def main():
    icon = create_brand_icon()
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    # 1. Save Master 512x512 Store Icon
    store_icon_path = os.path.join(base_dir, "assets", "icon.png")
    os.makedirs(os.path.dirname(store_icon_path), exist_ok=True)
    icon.save(store_icon_path, "PNG")
    print(f"Generated Master Store Icon: {store_icon_path}")

    # 2. Save Android Launcher Mipmaps
    res_dir = os.path.join(base_dir, "android", "app", "src", "main", "res")
    densities = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }

    for folder, dim in densities.items():
        folder_path = os.path.join(res_dir, folder)
        os.makedirs(folder_path, exist_ok=True)
        target_path = os.path.join(folder_path, "ic_launcher.png")
        resized = icon.resize((dim, dim), Image.Resampling.LANCZOS)
        resized.save(target_path, "PNG")
        print(f"Generated Android {folder} ({dim}x{dim}): {target_path}")

    # 3. Save Web Icons
    web_icons_dir = os.path.join(base_dir, "web", "icons")
    os.makedirs(web_icons_dir, exist_ok=True)
    icon.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, "Icon-192.png"), "PNG")
    icon.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, "Icon-512.png"), "PNG")
    icon.resize((32, 32), Image.Resampling.LANCZOS).save(os.path.join(base_dir, "web", "favicon.png"), "PNG")
    print("Generated Web Icons & Favicon.")

if __name__ == "__main__":
    main()
