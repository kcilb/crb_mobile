/**
 * Builds assets/images/credittrack_app_icon.png from an embedded SVG (layered squircle + mark),
 * then regenerates Android mipmaps + adaptive foregrounds, iOS AppIcon, web icons,
 * ic_launch_screen_icon, LaunchScreenAppIcon, and drawable-nodpi:
 * launch_splash_wordmark.png, launch_splash_bottom_dots.png, launch_splash_branding_strip.png.
 *
 * Theme colors align with lib/dialog_theme.dart (kFieldFill, kFieldBorder, kPrimaryBlue, kThemeBg).
 *
 * Run: cd tool && npm install && node generate_launcher_icons.mjs
 */
import sharp from 'sharp';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, '..');
const src = path.join(root, 'assets/images/credittrack_app_icon.png');

/** Layered icon like the CreditTrack reference art, recolored to app theme (no raster source required). */
function credittrackAppIconSvg() {
  const fieldFill = '#FFF7ED';
  const fieldBorder = '#FED7AA';
  const primary = '#EA580C';
  const primaryLight = '#FB923C';
  const brown = '#7C2D12';
  return `
<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <linearGradient id="ct_outer" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="${fieldFill}"/>
      <stop offset="100%" stop-color="${fieldBorder}"/>
    </linearGradient>
    <linearGradient id="ct_inner" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="${primaryLight}"/>
      <stop offset="100%" stop-color="${primary}"/>
    </linearGradient>
  </defs>
  <rect x="36" y="36" width="952" height="952" rx="214" ry="214" fill="url(#ct_outer)"/>
  <rect x="146" y="158" width="768" height="768" rx="172" ry="172" fill="${brown}" opacity="0.22"/>
  <rect x="128" y="128" width="768" height="768" rx="172" ry="172" fill="url(#ct_inner)"/>
  <g transform="translate(512 512) rotate(9)">
    <path fill="#FFFFFF" d="M 32 -200 C 142 -218 236 -132 252 -22 C 268 88 192 188 72 202 C 28 208 -12 196 -46 170 L -158 238 L -118 108 C -202 78 -242 -32 -214 -128 C -186 -224 -72 -200 32 -200 Z"/>
    <path fill="${primary}" d="M 58 -102 C 128 -122 198 -72 208 8 C 218 98 152 162 72 152 C 8 145 -32 88 -18 22 C -6 -32 38 -72 58 -102 Z"/>
  </g>
</svg>`.trim();
}

fs.mkdirSync(path.dirname(src), { recursive: true });
await sharp(Buffer.from(credittrackAppIconSvg()))
  .resize(1024, 1024)
  .png()
  .toFile(src);
console.log('Wrote master', src);

const androidMip = [
  ['mipmap-mdpi', 48],
  ['mipmap-hdpi', 72],
  ['mipmap-xhdpi', 96],
  ['mipmap-xxhdpi', 144],
  ['mipmap-xxxhdpi', 192],
];
const androidFg = [
  ['drawable-mdpi', 108],
  ['drawable-hdpi', 162],
  ['drawable-xhdpi', 216],
  ['drawable-xxhdpi', 324],
  ['drawable-xxxhdpi', 432],
];

for (const [folder, size] of androidMip) {
  const out = path.join(root, 'android/app/src/main/res', folder, 'ic_launcher.png');
  await sharp(src).resize(size, size).png().toFile(out);
  console.log('Wrote', out);
}
for (const [folder, size] of androidFg) {
  const out = path.join(root, 'android/app/src/main/res', folder, 'ic_launcher_foreground.png');
  await sharp(src).resize(size, size).png().toFile(out);
  console.log('Wrote', out);
}

// Native splash: copies of credittrack_app_icon.png at launcher-style densities (not mipmap/ic_launcher).
const androidLaunchScreenIcon = [
  ['drawable-mdpi', 48],
  ['drawable-hdpi', 72],
  ['drawable-xhdpi', 96],
  ['drawable-xxhdpi', 144],
  ['drawable-xxxhdpi', 192],
];
for (const [folder, size] of androidLaunchScreenIcon) {
  const out = path.join(
    root,
    'android/app/src/main/res',
    folder,
    'ic_launch_screen_icon.png',
  );
  await sharp(src).resize(size, size).png().toFile(out);
  console.log('Wrote', out);
}

const launchAssetPng = path.join(root, 'assets/images/credittrack_launch_screen_icon.png');
await sharp(src).resize(192, 192).png().toFile(launchAssetPng);
console.log('Wrote', launchAssetPng);

// Native splash: wordmark under icon (layer-list / pre–API 31).
function launchSplashWordmarkSvg() {
  const fill = '#4B5563';
  return `
<svg xmlns="http://www.w3.org/2000/svg" width="560" height="200" viewBox="0 0 560 200">
  <text x="280" y="168" text-anchor="middle" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="44" font-weight="700" fill="${fill}" letter-spacing="0.5">CreditTrack</text>
</svg>`.trim();
}

// Bottom-of-screen dots only (kThemeBg, kPrimaryBlue, kFieldBorder).
function launchSplashBottomDotsSvg() {
  const brown = '#7C2D12';
  const primary = '#EA580C';
  const peach = '#FED7AA';
  return `
<svg xmlns="http://www.w3.org/2000/svg" width="240" height="56" viewBox="0 0 240 56">
  <circle cx="88" cy="28" r="9" fill="${brown}"/>
  <circle cx="120" cy="28" r="9" fill="${primary}"/>
  <circle cx="152" cy="28" r="9" fill="${peach}"/>
</svg>`.trim();
}

// API 31+ branding strip: title + colored dots at bottom slot.
function launchSplashBrandingStripSvg() {
  const title = '#4B5563';
  const brown = '#7C2D12';
  const primary = '#EA580C';
  const peach = '#FED7AA';
  return `
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="112" viewBox="0 0 400 112">
  <text x="200" y="36" text-anchor="middle" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="22" font-weight="700" fill="${title}" letter-spacing="0.4">CreditTrack</text>
  <circle cx="176" cy="82" r="8" fill="${brown}"/>
  <circle cx="200" cy="82" r="8" fill="${primary}"/>
  <circle cx="224" cy="82" r="8" fill="${peach}"/>
</svg>`.trim();
}

const nodpiDir = path.join(root, 'android/app/src/main/res/drawable-nodpi');
fs.mkdirSync(nodpiDir, { recursive: true });
const wordmarkOut = path.join(nodpiDir, 'launch_splash_wordmark.png');
await sharp(Buffer.from(launchSplashWordmarkSvg())).png().toFile(wordmarkOut);
console.log('Wrote', wordmarkOut);
const bottomDotsOut = path.join(nodpiDir, 'launch_splash_bottom_dots.png');
await sharp(Buffer.from(launchSplashBottomDotsSvg())).png().toFile(bottomDotsOut);
console.log('Wrote', bottomDotsOut);
const brandingStripOut = path.join(nodpiDir, 'launch_splash_branding_strip.png');
await sharp(Buffer.from(launchSplashBrandingStripSvg())).png().toFile(brandingStripOut);
console.log('Wrote', brandingStripOut);

const launchIosDir = path.join(
  root,
  'ios/Runner/Assets.xcassets/LaunchScreenAppIcon.imageset',
);
fs.mkdirSync(launchIosDir, { recursive: true });
const iosLaunchPt = 120;
const iosScales = [
  ['LaunchScreenAppIcon.png', 1],
  ['LaunchScreenAppIcon@2x.png', 2],
  ['LaunchScreenAppIcon@3x.png', 3],
];
for (const [filename, mul] of iosScales) {
  const px = iosLaunchPt * mul;
  const out = path.join(launchIosDir, filename);
  await sharp(src).resize(px, px).png().toFile(out);
  console.log('Wrote', out);
}
const launchIosContents = {
  images: [
    {
      idiom: 'universal',
      filename: 'LaunchScreenAppIcon.png',
      scale: '1x',
    },
    {
      idiom: 'universal',
      filename: 'LaunchScreenAppIcon@2x.png',
      scale: '2x',
    },
    {
      idiom: 'universal',
      filename: 'LaunchScreenAppIcon@3x.png',
      scale: '3x',
    },
  ],
  info: { version: 1, author: 'xcode' },
};
fs.writeFileSync(
  path.join(launchIosDir, 'Contents.json'),
  `${JSON.stringify(launchIosContents, null, 2)}\n`,
);

const contentsPath = path.join(
  root,
  'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json',
);
const contents = JSON.parse(fs.readFileSync(contentsPath, 'utf8'));
const scaleMul = { '1x': 1, '2x': 2, '3x': 3 };

for (const img of contents.images) {
  if (!img.filename || !img.size || !img.scale) continue;
  const base = parseFloat(img.size.split('x')[0]);
  const px = Math.round(base * scaleMul[img.scale]);
  const out = path.join(
    root,
    'ios/Runner/Assets.xcassets/AppIcon.appiconset',
    img.filename,
  );
  await sharp(src).resize(px, px).png().toFile(out);
  console.log('Wrote', out, px);
}

const webDir = path.join(root, 'web/icons');
for (const [name, size] of [
  ['Icon-192.png', 192],
  ['Icon-512.png', 512],
  ['Icon-maskable-192.png', 192],
  ['Icon-maskable-512.png', 512],
]) {
  const out = path.join(webDir, name);
  await sharp(src).resize(size, size).png().toFile(out);
  console.log('Wrote', out);
}

console.log('Done.');
