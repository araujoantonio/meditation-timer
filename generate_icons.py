#!/usr/bin/env python3
"""Generate meditation bell app icons for macOS, iOS, and Android."""

from PIL import Image, ImageDraw
import math
import os

NAVY = (26, 26, 46)       # #1A1A2E
LAVENDER = (168, 181, 226) # #A8B5E2

BASE_DIR = "/Users/kaya/dev-env/meditation-timer"


def draw_bell_icon(size):
    """Draw a meditation singing bowl with striker on a dark navy background."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Rounded rectangle background
    corner_radius = int(size * 0.18)
    draw.rounded_rectangle(
        [(0, 0), (size - 1, size - 1)],
        radius=corner_radius,
        fill=NAVY,
    )

    # All coordinates relative to size for scalability
    cx = size / 2
    cy = size / 2

    # --- Singing Bowl ---
    # The bowl: a wide, shallow curved vessel shape
    bowl_top_y = cy + size * 0.02       # top rim of the bowl
    bowl_bottom_y = cy + size * 0.30    # bottom of the bowl
    bowl_width = size * 0.54            # total width at rim

    # Draw bowl as a smooth U-shape using bezier-like polygon
    # Left side curves inward, meets at a smooth rounded bottom, right side mirrors
    points = []
    steps = 80
    for i in range(steps + 1):
        t = i / steps  # 0 = left rim, 0.5 = bottom center, 1 = right rim
        # Parametric: x goes from left to right, y forms a U shape
        # x: linear from left edge to right edge
        x_left = cx - bowl_width / 2
        x_right = cx + bowl_width / 2
        x = x_left + (x_right - x_left) * t

        # y: parabolic U shape - deepest at center (t=0.5)
        # Normalize t to [-1, 1] centered at 0.5
        tn = (t - 0.5) * 2  # -1 to 1
        # U shape: y = bowl_top at edges, bowl_bottom at center
        depth = bowl_bottom_y - bowl_top_y
        y = bowl_top_y + depth * (1 - tn ** 2.5 * (1 if tn >= 0 else 1))
        # Use absolute value for symmetry
        y = bowl_top_y + depth * (1 - abs(tn) ** 2.2)

        points.append((x, y))

    draw.polygon(points, fill=LAVENDER)

    # Bowl rim highlight - a thin ellipse at the top of the bowl
    rim_thickness = max(1, int(size * 0.015))
    draw.ellipse(
        [cx - bowl_width / 2 - size * 0.01, bowl_top_y - rim_thickness,
         cx + bowl_width / 2 + size * 0.01, bowl_top_y + rim_thickness * 2],
        fill=LAVENDER,
    )

    # --- Striker / Mallet ---
    # A simple diagonal stick resting on the bowl
    # Stick: from upper-right area, angling down-left to touch the bowl rim
    stick_tip_x = cx + size * 0.04
    stick_tip_y = bowl_top_y + size * 0.01
    stick_end_x = cx + size * 0.30
    stick_end_y = cy - size * 0.30

    stick_width = max(2, int(size * 0.028))

    # Draw the stick as a line with rounded ends
    draw.line(
        [(stick_tip_x, stick_tip_y), (stick_end_x, stick_end_y)],
        fill=LAVENDER,
        width=stick_width,
    )

    # Rounded ends
    r = stick_width / 2
    draw.ellipse([stick_tip_x - r, stick_tip_y - r, stick_tip_x + r, stick_tip_y + r], fill=LAVENDER)
    draw.ellipse([stick_end_x - r, stick_end_y - r, stick_end_x + r, stick_end_y + r], fill=LAVENDER)

    # Striker head (larger ball at the tip that strikes the bowl)
    head_r = max(2, int(size * 0.038))
    draw.ellipse(
        [stick_tip_x - head_r, stick_tip_y - head_r,
         stick_tip_x + head_r, stick_tip_y + head_r],
        fill=LAVENDER,
    )

    # --- Sound waves (subtle arcs above the bowl) ---
    wave_center_x = cx
    wave_center_y = bowl_top_y - size * 0.02

    for i, radius_mult in enumerate([0.10, 0.16, 0.22]):
        radius = size * radius_mult
        arc_width = max(1, int(size * 0.014))
        bbox = [
            wave_center_x - radius, wave_center_y - radius,
            wave_center_x + radius, wave_center_y + radius,
        ]
        # Draw arcs spanning upward (from ~210 to ~330 degrees)
        # Use semi-transparent lavender for subtlety
        wave_color = LAVENDER[:3] + (int(180 - i * 40),)
        # Create a temporary image for the arc with alpha
        arc_img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        arc_draw = ImageDraw.Draw(arc_img)
        arc_draw.arc(bbox, start=220, end=320, fill=wave_color, width=arc_width)
        img = Image.alpha_composite(img, arc_img)

    return img


def save_icon(img, path, target_size):
    """Resize and save icon to path."""
    resized = img.resize((target_size, target_size), Image.LANCZOS)
    # Convert to RGB for formats that don't support alpha, keep RGBA for PNG
    resized.save(path, "PNG")
    print(f"  Saved: {path} ({target_size}x{target_size})")


def generate_macos_icons(master):
    """Generate macOS app icons."""
    print("\n--- macOS Icons ---")
    out_dir = os.path.join(BASE_DIR, "macos/Runner/Assets.xcassets/AppIcon.appiconset")
    os.makedirs(out_dir, exist_ok=True)

    sizes = [16, 32, 64, 128, 256, 512, 1024]
    for s in sizes:
        save_icon(master, os.path.join(out_dir, f"app_icon_{s}.png"), s)


def generate_ios_icons(master):
    """Generate iOS app icons."""
    print("\n--- iOS Icons ---")
    out_dir = os.path.join(BASE_DIR, "ios/Runner/Assets.xcassets/AppIcon.appiconset")
    os.makedirs(out_dir, exist_ok=True)

    # Map of (base_size, scale) -> pixel_size
    ios_icons = [
        ("20x20", "1x", 20),
        ("20x20", "2x", 40),
        ("20x20", "3x", 60),
        ("29x29", "1x", 29),
        ("29x29", "2x", 58),
        ("29x29", "3x", 87),
        ("40x40", "1x", 40),
        ("40x40", "2x", 80),
        ("40x40", "3x", 120),
        ("60x60", "2x", 120),
        ("60x60", "3x", 180),
        ("76x76", "1x", 76),
        ("76x76", "2x", 152),
        ("83.5x83.5", "2x", 167),
        ("1024x1024", "1x", 1024),
    ]

    for size_str, scale, pixels in ios_icons:
        filename = f"Icon-App-{size_str}@{scale}.png"
        save_icon(master, os.path.join(out_dir, filename), pixels)


def generate_android_icons(master):
    """Generate Android app icons."""
    print("\n--- Android Icons ---")
    res_dir = os.path.join(BASE_DIR, "android/app/src/main/res")

    densities = [
        ("mipmap-mdpi", 48),
        ("mipmap-hdpi", 72),
        ("mipmap-xhdpi", 96),
        ("mipmap-xxhdpi", 144),
        ("mipmap-xxxhdpi", 192),
    ]

    for folder, s in densities:
        out_dir = os.path.join(res_dir, folder)
        os.makedirs(out_dir, exist_ok=True)
        save_icon(master, os.path.join(out_dir, "ic_launcher.png"), s)


def main():
    print("Generating meditation bell app icons...")

    # Generate master icon at highest resolution
    master_size = 1024
    master = draw_bell_icon(master_size)

    generate_macos_icons(master)
    generate_ios_icons(master)
    generate_android_icons(master)

    print("\nDone! All icons generated successfully.")


if __name__ == "__main__":
    main()
