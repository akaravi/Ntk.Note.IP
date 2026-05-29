"""Generate IPNote.ir brand icons with bold 'IP' lettering."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]

# Brand palette (light + dark friendly)
COLOR_TOP = (124, 58, 237)       # #7c3aed
COLOR_BOTTOM = (26, 22, 37)      # #1a1625
TEXT_COLOR = (255, 255, 255)
ACCENT_RING = (167, 139, 250, 90)  # soft violet ring


def _lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def _rounded_gradient(size: int, radius_ratio: float = 0.22) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = img.load()
    radius = size * radius_ratio

    for y in range(size):
        t = y / max(size - 1, 1)
        r = _lerp(COLOR_TOP[0], COLOR_BOTTOM[0], t)
        g = _lerp(COLOR_TOP[1], COLOR_BOTTOM[1], t)
        b = _lerp(COLOR_TOP[2], COLOR_BOTTOM[2], t)
        for x in range(size):
            px[x, y] = (r, g, b, 255)

    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size - 1, size - 1), radius=radius, fill=255)
    img.putalpha(mask)
    return img


def _load_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "C:/Windows/Fonts/segoeuib.ttf",
        "C:/Windows/Fonts/arialbd.ttf",
        "C:/Windows/Fonts/calibrib.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
    ]
    for path in candidates:
        p = Path(path)
        if p.exists():
            return ImageFont.truetype(str(p), size=size)
    return ImageFont.load_default()


def render_icon(size: int) -> Image.Image:
    canvas = _rounded_gradient(size)

    draw = ImageDraw.Draw(canvas)
    ring = max(2, size // 64)
    inset = size * 0.08
    draw.rounded_rectangle(
        (inset, inset, size - inset, size - inset),
        radius=size * 0.16,
        outline=ACCENT_RING,
        width=ring,
    )

    font_size = max(10, int(size * 0.46))
    font = _load_font(font_size)
    text = "IP"

    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    x = (size - tw) / 2 - bbox[0]
    y = (size - th) / 2 - bbox[1] - size * 0.02

    # Subtle shadow for legibility on small sizes
    if size >= 48:
        shadow = max(1, size // 128)
        draw.text((x + shadow, y + shadow), text, font=font, fill=(0, 0, 0, 120))
    draw.text((x, y), text, font=font, fill=TEXT_COLOR)

    return canvas.convert("RGBA")


def save_png(path: Path, size: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    render_icon(size).save(path, format="PNG", optimize=True)


def save_ico(path: Path) -> None:
    sizes = [16, 32, 48, 64, 128, 256]
    images = [render_icon(s).convert("RGBA") for s in sizes]
    path.parent.mkdir(parents=True, exist_ok=True)
    images[0].save(
        path,
        format="ICO",
        sizes=[(s, s) for s in sizes],
        append_images=images[1:],
    )


def main() -> None:
    outputs: list[tuple[Path, int]] = [
        (ROOT / "src/Web/ClientApp/src/favicon.png", 48),
        (ROOT / "src/Web/ClientApp/src/apple-touch-icon.png", 180),
        (ROOT / "src/Web/ClientApp/src/assets/icons/icon-192.png", 192),
        (ROOT / "src/Web/ClientApp/src/assets/icons/icon-512.png", 512),
        (ROOT / "src/Web/ClientApp-React/public/favicon.png", 48),
        (ROOT / "src/Web/ClientApp-React/public/apple-touch-icon.png", 180),
        (ROOT / "src/Web/ClientApp-React/public/icon-192.png", 192),
        (ROOT / "src/Web/ClientApp-React/public/icon-512.png", 512),
        (ROOT / "src/Mobile/ntk_note_ip_app/assets/brand/app_icon.png", 1024),
        (ROOT / ".template.config/icon.png", 256),
    ]

    wwwroot = ROOT / "src/Web/wwwroot"
    outputs.extend([
        (wwwroot / "favicon.png", 48),
        (wwwroot / "apple-touch-icon.png", 180),
        (wwwroot / "assets/icons/icon-192.png", 192),
        (wwwroot / "assets/icons/icon-512.png", 512),
    ])

    for path, size in outputs:
        save_png(path, size)
        print(f"Wrote {path} ({size}x{size})")

    save_ico(ROOT / "src/Web/ClientApp-React/public/favicon.ico")
    print(f"Wrote {ROOT / 'src/Web/ClientApp-React/public/favicon.ico'}")


if __name__ == "__main__":
    main()
