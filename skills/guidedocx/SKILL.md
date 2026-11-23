---
name: guidedocx
description: Generate a structured, anti-hallucination, anti-slop End-User Guide (USER_GUIDE.docx) in Microsoft Word format from a software repository or codebase. Use when the user asks to create a user guide, user documentation, user manual, or .docx end-user handbook from a repository, codebase, or project folder.
---
# Repo User Guide DOCX Generator

Analyze a software repository or codebase and generate a crisp, professionally styled Microsoft Word User Guide (`USER_GUIDE.docx`) tailored for non-technical end-users—free from AI writing fluff ("anti-slop") and unverified claims.

## When to Use

- The user asks to generate a User Guide, User Manual, or End-User Documentation from a codebase or repository.
- The user wants documentation exported directly into a styled `.docx` file.

## Workflow

### Step 1: Validate Target Codebase & Color Theme Preference (Mandatory)

Before reading files or generating any documentation, verify two required inputs:

1. **Target Codebase / Repository**:
   - If no codebase, workspace context, or repository parameter is provided in the prompt or current workspace, **STOP immediately** and ask the user:
     "Which codebase or repository would you like me to generate the `USER_GUIDE.docx` documentation for? Please provide the repository path, workspace folder, or upload the codebase bundle."
2. **DOCX Color Theme / Scheme**:
   - Check if the user already specified a color theme or custom hex palette in their prompt.
   - If no color theme was specified, **STOP and ask the user** to pick a theme before generating the file (listing the 5 curated palettes from `references/docx-style-spec.md`):
     "Which color theme would you like for `USER_GUIDE.docx`?
     1. **Corporate Cobalt** (`#1E3A8A`) - Enterprise SaaS, ERP & Admin Systems *(Default)*
     2. **Slate & Steel** (`#0F172A`) - Cybersecurity, DevOps & Server Tools
     3. **Emerald Operations** (`#065F46`) - Finance, Healthcare & Inventory/Logistics
     4. **Deep Teal & Cyan** (`#115E59`) - IoT, Hardware Kiosks & Analytics
     5. **Amber & Charcoal** (`#1F2937` / `#D97706`) - Mobile Scanners, Retail POS & Industrial
     *(Or provide your own primary hex color code, e.g., `#2B579A`.)*"

### Step 2: Codebase Extraction, Anti-Hallucination & Anti-Slop Rules

Inspect UI views, forms, components, controllers/services, authorization rules, and configuration files thoroughly while enforcing strict grounding and concise technical writing:

- **Exact UI Labels**: Use the exact menu names, button labels, tab titles, input field labels, and validation messages found in the UI source code. Never invent UI elements.
- **End-User Language**: Write in direct operational language. Exclude code snippets, internal class names, SQL table names, and backend architecture jargon unless they explicitly appear on the user interface.
- **Strict Anti-Slop Writing Rules**:
  - **Ban AI Filler & Marketing Fluff**: Never use empty corporate superlatives or generic AI phrases such as *"seamlessly"*, *"empower"*, *"streamline"*, *"robust"*, *"cutting-edge"*, *"intuitive"*, *"delve into"*, *"in today's fast-paced..."*, *"let's explore"*, or *"harness the power of"*.
  - **Action-First Sentences**: Start every instruction with a concrete imperative verb (*Click*, *Select*, *Enter*, *Verify*, *Download*) and state exact screen outcomes instead of abstract benefits.
  - **Zero Redundant Transitions**: Do not write filler paragraphs summarizing what a section is about to say or repeating what was just said. Jump straight to the steps, tables, or facts.
  - **Concrete Specifics Over Vagueness**: Replace vague advice (*"configure the appropriate settings"*) with exact field names and values extracted from the codebase.
- **Flag Missing Context**: If a workflow depends on external configuration or incomplete code, mark it explicitly as `[NEEDS TEAM VERIFICATION]`.

### Step 3: Screenshot Capture & Visual Evidence Policy

Handle screenshots based on the detected application platform and environment capabilities:

- **Web Applications (Live Browser Auto-Capture)**:
  - When a web UI is running or startable locally and browser/Playwright capture tools are available, configure a fixed desktop viewport of **`1280x800`** (or `1366x768`).
  - Capture **viewport-only** screenshots (`full_page=False`) by default so tall pages do not shrink to unreadable proportions inside Word margins. Only use `full_page=True` if total page height is under `1200px` (such as Login screens or compact forms).
  - For modals, dialogs, or specific input cards, crop or focus on the relevant container so field labels remain crisp and legible.
  - Embed captured desktop images into `USER_GUIDE.docx` constrained to a maximum width of **`6.3` inches** while preserving aspect ratio, with a subtle `1 pt` `#CBD5E1` border.

- **Mobile / Android Applications (Mandatory Emulator Confirmation)**:
  - When the codebase is detected as a mobile/Android project (e.g., `.NET MAUI` / `net*-android`, `AndroidManifest.xml`, `pubspec.yaml`, or `android/`), first check if an active device or emulator is already connected (`adb devices`).
  - If no device/emulator is currently running, **DO NOT launch an Android Emulator automatically** (as it consumes heavy RAM/CPU and may require active backend APIs or physical peripherals). **STOP and ask the user**:
    "This project is detected as a mobile/Android application. Would you like me to start an Android Emulator to capture live screenshots (requires additional RAM/CPU and an active backend API), or proceed using `[SCREENSHOT: ...]` placeholders instead?"
  - If an active device is approved or emulator launch is confirmed, capture portrait screenshots (`adb exec-out screencap -p`) and embed them into `USER_GUIDE.docx` constrained to **`2.5`–`2.8` inches** wide (optionally arranged side-by-side in a borderless 2-column layout table) with a `1 pt` `#CBD5E1` border so vertical screens fit cleanly without overflowing pages.

- **Safe Fallback to Placeholders**:
  - Whenever an application cannot be launched locally (e.g., requires external SSO, physical barcode/printer hardware, or missing runtime secrets), no capture tool is available, or the user declines running an emulator, **do not fail or capture error screens**. Insert a styled callout placeholder formatted as `[SCREENSHOT: Specific description of the screen and UI elements to capture]`.

### Step 4: Document Structure (`USER_GUIDE.docx`)

Organize the Word document into the following sections:

1. **Title Banner & Document Control Table**: Application name (from project manifest/config), version, generation date, and target user roles.
2. **Chapter 1: Application Overview & User Access Matrix**: Concise operational scope (max 3-4 sentences) and a role-based access table mapping each user role to its responsibilities and accessible menus/features.
3. **Chapter 2: Getting Started**: System/device prerequisites, initial setup or login/logout steps, and an overview of the main workspace (dashboard, navigation menu, status panels).
4. **Chapter 3: Core Feature Guides (Step-by-Step)**: Grouped by end-to-end operational workflows. Each feature must include **Objective** (1 crisp sentence), **Prerequisites**, **Numbered Steps (1, 2, 3...)** with **bold** UI button and field names, and **Expected Result**, accompanied by either captured screenshots or `[SCREENSHOT: ...]` callout boxes.
5. **Chapter 4: Search, Filtering, Import & Report Export**: Instructions for searching records, applying filters, printing documents, and exporting reports (Excel, PDF, CSV) supported by the codebase.
6. **Chapter 5: FAQ & Common Troubleshooting**: Real validation messages and error prompts extracted from the codebase paired with causes and practical end-user resolutions.

### Step 5: DOCX Theme Selection, Styling & Generation

Read `references/docx-style-spec.md` for color themes, typography, and layout rules:

- **Theme Selection**: Select the most fitting color theme from `references/docx-style-spec.md` based on the application domain (or user preference), defaulting to **Corporate Cobalt** (`#1E3A8A`) for general enterprise/ERP apps.
- Generate `USER_GUIDE.docx` in the project root directory using a Python script with `python-docx`.
- Execute the Python script, verify `USER_GUIDE.docx` is created without errors, remove any temporary generator script and temporary raw screenshot files if embedded, and output a concise summary of generated chapters alongside any remaining screenshot placeholders to capture manually.

## Gotchas

- Never proceed to Step 2 if the target repository or codebase is unspecified.
- Never start an Android Emulator without explicit user confirmation.
- Never use `full_page=True` on long scrolling web pages, as the resulting vertical image shrinks illegibly when fitted into a `.docx` page.
- Never pad chapters with generic AI prose; every paragraph must convey concrete UI behavior from the repository.
- If `python-docx` is not installed in the active environment, install it via `pip install python-docx` before running the generator script.