# DOCX Visual Themes & Layout Specification

Apply these formatting rules when generating `USER_GUIDE.docx` with `python-docx`.

## 1. Curated Word Color Themes

Select **one** cohesive palette matching the target application's domain (or explicit user preference). Do not mix palettes within the same document.

| Theme Name | Best For | Primary (`Banner / H1 / Table Header`) | Accent (`Borders / Sub-accents`) | Subtitle / Soft Tint | Zebra Row Fill |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Corporate Cobalt** *(Default)* | Enterprise SaaS, ERP, Event & Admin Systems | `#1E3A8A` | `#2563EB` | `#DBEAFE` | `#F8FAFC` |
| **2. Slate & Steel** | Cybersecurity, DevOps, Server & Infrastructure Tools | `#0F172A` | `#334155` | `#E2E8F0` | `#F8FAFC` |
| **3. Emerald Operations** | Finance, Healthcare, Inventory & Field Logistics | `#065F46` | `#059669` | `#D1FAE5` | `#F4FBF8` |
| **4. Deep Teal & Cyan** | IoT, Hardware Kiosks, Analytics & Data Platforms | `#115E59` | `#0D9488` | `#CCFBF1` | `#F4FBFB` |
| **5. Amber & Charcoal** | Mobile Scanners, Retail POS & Industrial Workflows | `#1F2937` | `#D97706` | `#FEF3C7` | `#F9FAFB` |

### Semantic Callout Box Colors (Consistent Across All Themes)
- **`[SCREENSHOT PLACEHOLDER]`**: Background `#EFF6FF`, Left Border `#2563EB` (`sz="24"`), Title `#1E3A8A`.
- **Important Notes / Warnings**: Background `#FFFBEB`, Left Border `#D97706` (`sz="24"`), Title `#92400E`.
- **Support / Helpdesk**: Background `#F0FDF4`, Left Border `#16A34A` (`sz="24"`), Title `#166534`.

---

## 2. Typography & Page Geometry

- **Page Margins**: `0.8 inches` on all sides (Top, Bottom, Left, Right), leaving `6.9 inches` printable width on Letter/A4.
- **Font Family**: `Segoe UI` (primary) or `Calibri` (cross-platform fallback). Avoid mixing serif and sans-serif fonts.
- **Body Text**: `10.5 pt`, `#1F2937` dark charcoal (softer and cleaner than pure `#000000`), `1.15` line spacing, `4 pt` space after paragraphs.
- **Title Banner**: Full-width single-cell table (`6.9 inches`) filled with **Primary** color, generous cell padding (`top/bottom: 220 dxa`, `left/right: 240 dxa`), `20 pt` bold `#FFFFFF` title, and `11 pt` **Subtitle / Soft Tint** tagline.
- **Section Headings**:
  - `H1`: `14 pt` bold **Primary** color with a crisp bottom paragraph border (`sz="8"`, **Primary** color) and `keep_with_next = True`.
  - `H2`: `11.5 pt` bold `#0F172A` with `keep_with_next = True`.
- **Tables (Document Control, Role Matrix, FAQ)**:
  - Header row shaded with **Primary** color, bold `#FFFFFF` text (`9.5 pt`), `repeatHeader` enabled so headers repeat across page breaks.
  - Body rows alternating `#FFFFFF` and **Zebra Row Fill**, subtle horizontal borders (`#E2E8F0`, `sz="4"`), vertical borders omitted for a modern clean look, and cell padding (`top/bottom: 75 dxa`, `left/right: 110 dxa`).
  - Set `cantSplit` on table rows so rows never break awkwardly mid-sentence across pages.

---

## 3. Embedded Screenshots & Visual Framing

- **Desktop / Web UI**: Capture at fixed `1280x800` viewport (`full_page=False` unless height < `1200px`). Constrain width to max `6.3 inches` preserving aspect ratio.
- **Mobile / Android UI**: Capture portrait screen (`adb exec-out screencap -p`). Constrain width to `2.5` to `2.8 inches` (optionally placed side-by-side in a borderless 2-column table) so tall screens do not overflow pages.
- **Image Frame**: Apply a subtle `1 pt` `#CBD5E1` border around all embedded screenshots so light-themed screens remain distinct against white pages.
- **Fallback**: Use a `[SCREENSHOT: ...]` callout box whenever the app cannot be rendered locally or emulator launch is declined.

---

## 4. Headers & Footers

- **Header**: Right-aligned `8.5 pt` `#64748B` text showing `<APPLICATION NAME> — END-USER GUIDE` (suppressed on page 1 via `different_first_page_header_footer = True`).
- **Footer**: Centered `8.5 pt` `#64748B` text displaying `Version <X.Y.Z>  •  Page X of Y` using native Word XML `PAGE` and `NUMPAGES` fields.