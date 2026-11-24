---
name: guidedocx
description: "Generate a structured, anti-hallucination, anti-slop End-User Guide (USER_GUIDE.docx) in Microsoft Word format from a software repository or codebase. Use when the user asks to create a user guide, user documentation, user manual, or .docx end-user handbook from a repository, codebase, or project folder."
---

# GuideDOCX - Repo End-User Guide Generator

Analyze a software repository or codebase and generate a crisp, professionally styled Microsoft Word User Guide (`USER_GUIDE.docx`) tailored for non-technical end-users, free from AI writing fluff ("anti-slop") and unverified claims.

## When to Use

- The user asks to generate a User Guide, User Manual, or End-User Documentation from a codebase or repository.
- The user wants documentation exported directly into a styled `.docx` file.

## Workflow

### Step 1: Validate Target Project, Output Language & Color Theme (Mandatory)

Before reading files or generating any documentation, verify three required inputs:

1. **Target Codebase / Project Selection**:
   - If no codebase, workspace context, or repository parameter is provided, **STOP immediately** and ask which codebase or repository to document.
   - **Multi-Project / Monorepo Detection**: If the workspace or root directory contains multiple distinct project folders, solutions, or apps (e.g., separate `.csproj` apps, `packages/*`, `apps/*`, or multiple subfolders with their own manifests), **DO NOT guess or merge them blindly**. List the detected project folders and ask the user:
     "Multiple projects were detected in this workspace: [list detected folders/projects]. Which specific project folder would you like me to generate `USER_GUIDE.docx` for (or should I cover a specific combination)?"
2. **Document Output Language**:
   - Check if the user already specified the language for `USER_GUIDE.docx`.
   - If not specified, **STOP and ask the user** which language the document should be written in (offering **English**, **Bahasa Indonesia**, or **any custom language** the user specifies—while always preserving exact UI button/menu text from the source code).
3. **DOCX Color Theme / Scheme**:
   - Check if the user already specified a color theme or custom hex palette.
   - If not specified, **STOP and ask the user** to pick a theme before generating the file (listing the 5 curated palettes from `references/docx-style-spec.md`):
     1. **Corporate Cobalt** (`#1E3A8A`) - Enterprise SaaS, ERP & Admin Systems *(Default)*
     2. **Slate & Steel** (`#0F172A`) - Cybersecurity, DevOps & Server Tools
     3. **Emerald Operations** (`#065F46`) - Finance, Healthcare & Inventory/Logistics
     4. **Deep Teal & Cyan** (`#115E59`) - IoT, Hardware Kiosks & Analytics
     5. **Amber & Charcoal** (`#1F2937` / `#D97706`) - Mobile Scanners, Retail POS & Industrial
     *(Or provide a custom primary hex color code, e.g., `#2B579A`.)*

*(Important: Consolidate all missing questions into **one single concise message** so the user can answer target project, language, and color theme together in one reply.)*

### Step 2: Codebase Extraction, Versioning & Anti-Hallucination Rules

Inspect UI views, forms, components, controllers/services, authorization rules, and configuration files thoroughly while enforcing strict grounding and concise technical writing:

- **Auto-Detect Application Version**: Extract the application version directly from project manifests or version sources (such as `<Version>` in `.csproj`, `"version"` in `package.json`, `version:` in `pubspec.yaml`, `AssemblyInfo`, or latest Git tag). Use `v1.0.0` only if no version metadata exists in the repository.
- **Exact UI Labels**: Use the exact menu names, button labels, tab titles, input field labels, and validation messages found in the UI source code—even when writing narrative prose in another language, keep UI labels verbatim (or show `Exact UI Label (Translated Hint)` if helpful). Never invent UI elements.
- **End-User Language**: Write in direct operational language matching the user's chosen document language. Exclude code snippets, internal class names, SQL table names, and backend architecture jargon unless they explicitly appear on the user interface.
- **Strict Anti-Slop Writing Rules**:
  - **Ban AI Filler & Marketing Fluff**: Never use empty corporate superlatives or generic AI phrases in any language (such as *"seamlessly"*, *"empower"*, *"streamline"*, *"robust"*, *"cutting-edge"*, *"intuitive"*, *"delve into"*, *"secara mulus"*, *"memberdayakan"*, *"solusi canggih"*, or *"di era digital yang serba cepat"*).
  - **Action-First Sentences**: Start every instruction with a concrete imperative verb (*Click / Klik*, *Select / Pilih*, *Enter / Masukkan*, *Verify / Periksa*, *Download / Unduh*) and state exact screen outcomes instead of abstract benefits.
  - **Zero Redundant Transitions**: Do not write filler paragraphs summarizing what a section is about to say or repeating what was just said. Jump straight to the steps, tables, or facts.
  - **Concrete Specifics Over Vagueness**: Replace vague advice (*"configure the appropriate settings"*) with exact field names and values extracted from the codebase.
- **Flag Missing Context**: If a workflow depends on external configuration or incomplete code, mark it explicitly as `[NEEDS TEAM VERIFICATION]`.

### Step 3: Screenshot Capture & Visual Evidence Policy (Mandatory Visuals in Every Guide)

Every generated `USER_GUIDE.docx` **MUST include visual evidence** (either real captured screenshots OR styled `[SCREENSHOT: ...]` callout boxes—never omit visual blocks from the document):

- **Web Applications (Proactive Live Browser Auto-Capture)**:
  - When a web UI is running or startable locally (e.g., via `dotnet run`, `npm run dev`, or local URL), **actively attempt to launch or connect to it** and capture live screenshots using browser/Playwright tools (`pip install playwright` if needed).
  - Configure a fixed desktop viewport of **`1280x800`** (or `1366x768`) and capture **viewport-only** screenshots (`full_page=False`) by default so tall pages do not shrink to unreadable proportions inside Word margins. Only use `full_page=True` if total page height is under `1200px` (such as Login screens or compact forms).
  - For modals, dialogs, or specific input cards, crop or focus on the relevant container so field labels remain crisp and legible.
  - Embed captured desktop images into `USER_GUIDE.docx` constrained to a maximum width of **`6.3` inches** while preserving aspect ratio, with a subtle `1 pt` `#CBD5E1` border.

- **Mobile / Android Applications (Mandatory Emulator Confirmation)**:
  - When the codebase is detected as a mobile/Android project (e.g., `.NET MAUI` / `net*-android`, `AndroidManifest.xml`, `pubspec.yaml`, or `android/`), first check if an active device or emulator is already connected (`adb devices`).
  - If no device/emulator is currently running, **DO NOT launch an Android Emulator automatically** (as it consumes heavy RAM/CPU and may require active backend APIs or physical peripherals). **STOP and ask the user**:
    "This project is detected as a mobile/Android application. Would you like me to start an Android Emulator to capture live screenshots (requires additional RAM/CPU and an active backend API), or proceed using `[SCREENSHOT: ...]` placeholders instead?"
  - If an active device is approved or emulator launch is confirmed, capture portrait screenshots (`adb exec-out screencap -p`) and embed them into `USER_GUIDE.docx` constrained to **`2.5` to `2.8` inches** wide (optionally arranged side-by-side in a borderless 2-column layout table) with a `1 pt` `#CBD5E1` border so vertical screens fit cleanly without overflowing pages.

- **Mandatory Placeholder Callout Boxes (When Live Capture Is Not Possible)**:
  - Whenever an application cannot be launched locally (e.g., requires external SSO, physical barcode/printer hardware, or missing runtime secrets), no browser/device capture tool is available, or the user declines running an emulator, **you MUST still insert a styled left-bordered `[SCREENSHOT: ...]` callout box** at every major screen step (Login, Dashboard, and each Core Feature workflow) so the user knows the exact screens to capture and insert manually. Never silently skip screenshot blocks.

### Step 4: Document Structure (`USER_GUIDE.docx`)

Organize the Word document into the following sections (localizing all headings, table headers, and callout titles into the user's chosen document language):

1. **Title Banner, Document Control & Revision History Table**:
   - Application name (from project manifest/config), auto-detected application version, generation date, and target user roles.
   - Compact **Revision History** table (`Version`, `Date`, `Summary of Changes`, `Author`) immediately below Document Control so future updates remain traceable.
2. **Chapter 1: Application Overview & User Access Matrix**: Concise operational scope (max 3-4 sentences) and a role-based access table mapping each user role to its responsibilities and accessible menus/features.
3. **Chapter 2: Getting Started**: System/device prerequisites, initial setup or login/logout steps, and an overview of the main workspace (dashboard, navigation menu, status panels), plus a Login/Dashboard screenshot or `[SCREENSHOT: ...]` callout box.
4. **Chapter 3: Core Feature Guides (Step-by-Step)**: Grouped by end-to-end operational workflows. Each feature must include **Objective** (1 crisp sentence), **Prerequisites**, **Numbered Steps (1, 2, 3...)** with **bold** UI button and field names, **Expected Result**, and **at least one captured screenshot or `[SCREENSHOT: ...]` callout box**.
5. **Chapter 4: Search, Filtering, Import & Report Export**: Instructions for searching records, applying filters, printing documents, and exporting reports (Excel, PDF, CSV) supported by the codebase.
6. **Chapter 5: FAQ & Common Troubleshooting**: Real validation messages and error prompts extracted from the codebase paired with causes and practical end-user resolutions.

### Step 5: DOCX Styling & Generation

Read `references/docx-style-spec.md` for exact color codes, typography, and layout rules matching the selected theme:

- Generate `USER_GUIDE.docx` in the selected project root directory using a Python script with `python-docx`.
- Execute the Python script, verify `USER_GUIDE.docx` is created without errors, remove any temporary generator script and temporary raw screenshot files if embedded, and output a concise summary of generated chapters alongside a list of all embedded screenshots or `[SCREENSHOT: ...]` placeholders included in the document.

## Gotchas

- Never proceed to Step 2 until target project (including disambiguating multi-project folders), document language, and color theme are all confirmed.
- Never start an Android Emulator without explicit user confirmation.
- Never silently omit screenshots or `[SCREENSHOT: ...]` callout boxes from Chapter 2 and Chapter 3.
- Never use `full_page=True` on long scrolling web pages, as the resulting vertical image shrinks illegibly when fitted into a `.docx` page.
- Never pad chapters with generic AI prose; every paragraph must convey concrete UI behavior from the repository.
- If `python-docx` is not installed in the active environment, install it via `pip install python-docx` before running the generator script.