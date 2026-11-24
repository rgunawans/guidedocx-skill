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
- **Detect App Type & Login Requirement** (feeds Step 3): Classify the project and note the entry point to launch it.

  | Signal in repo | App type | Launch hint |
  |---|---|---|
  | `*.razor`, `Program.cs` with `AddRazorComponents`/`MapBlazorHub`, `wwwroot/` | Blazor Server / WebAssembly / Web App | `dotnet run` → URL from `Properties/launchSettings.json` |
  | `*.cshtml`, MVC/Razor Pages, `package.json` with a `dev`/`start` script, Django/Flask/Laravel/Rails | Web | project dev command → local URL |
  | `net*-windows*`, `.xaml` + `WPF`/`WinUI`/`UseWindowsForms` | Windows desktop (WPF, WinForms, WinUI) | `dotnet run` or built `.exe` |
  | MAUI (`UseMaui`, `Platforms/`) | MAUI | Prefer the `-windows` target; `-android`/`-ios`/`-maccatalyst` per mobile rules |
  | MAUI + `BlazorWebView` / `MauiProgram` with `AddMauiBlazorWebView` | Blazor Hybrid | Same as MAUI (Windows target first) |
  | `electron` / `tauri.conf.json` | Electron / Tauri | `npm run start` / `npm run tauri dev` |
  | `Avalonia`, Qt, JavaFX, Tkinter, PyQt | Other desktop | project run command |
  | `pubspec.yaml` | Flutter | `flutter run -d chrome` / `-d windows` (cheaper) before `-d <emulator>` |
  | `AndroidManifest.xml`, `android/` | Android | emulator rules in Step 3 |

  Detect login: search for login pages/forms, `[Authorize]`, Identity/JWT/cookie auth, `AuthenticationStateProvider`, SSO/OIDC config (`AddOpenIdConnect`, `AzureAd`), seeded users (`HasData`, seeders, fixtures), and the connection string in `appsettings*.json` / `.env`.

### Step 3: Screenshot Capture & Visual Evidence Policy (Mandatory Visuals in Every Guide)

Every generated `USER_GUIDE.docx` **MUST include visual evidence** (either real captured screenshots OR styled `[SCREENSHOT: ...]` callout boxes—never omit visual blocks from the document). Always try live capture first; fall back to placeholders only when capture is impossible or declined.

#### 3.1 Resolve Login Before Launching (Ask Once, Only If a Login Exists)

If the app requires sign-in and the user has not already supplied test credentials, **STOP and ask one concise message**:

"The app requires login. How should I get past it for screenshots?
1. **Dummy account** - create a dummy user in the local/dev database (or use a user already seeded by the repo).
2. **Bypass login** - temporary, uncommitted dev-only bypass (auto sign-in as a test user), reverted afterwards.
3. **Reset password** - set a known password on an existing user in the local/dev database; the original value is restored afterwards.
4. **I provide credentials** - you give me a test account.
5. **Placeholders only** - skip live capture; insert `[SCREENSHOT: ...]` callouts."

Rules for each option:

- **Safety gate (applies to options 1-3)**: Read the connection string / data source first. Proceed only if it points to `localhost`, `127.0.0.1`, `(localdb)`, a local file (SQLite), a local container, or a host whose name is clearly dev/test. If the target is production, shared, or unclear, **STOP and ask**; never write to it.
- **Dummy account**: Prefer the repo's own seed data, seeder, or registration page. Otherwise create the user through the app's own hashing/registration code path (never store plaintext passwords the app would hash). Give the user a role matching each documented role if multiple roles must be shown. Generate the password yourself; record it in the project's seed/example-config file or tell the user to see it there, and **do not repeat it in chat or in `USER_GUIDE.docx`**.
- **Bypass login**: Implement with the smallest change behind a dev-only flag (e.g., `ASPNETCORE_ENVIRONMENT=Development` + env var, auto-authenticated test principal, or a dev-only startup parameter). Keep it uncommitted: note the touched files, and revert via `git checkout -- <files>`/`git stash` after capture. Never leave it in the working tree.
- **Reset password**: Save the original hash/value first (in the scratchpad/temp folder), set a new value using the app's hashing method, and **restore the original after capture**. Tell the user which user was changed.
- **Dummy data for screenshots**: If tables are empty, add clearly fake records (e.g., "Contoh Pelanggan", "Test Item 001") via the UI or seeding. Do not capture real customer data, emails, tokens, or secrets; crop or blur if unavoidable.
- **SSO/OIDC/MFA/CAPTCHA** that cannot run locally: do not attempt to bypass external identity providers or CAPTCHAs. Use Dummy/Bypass for the local app only if the app has a local auth path; otherwise use placeholders and mark `[NEEDS TEAM VERIFICATION]`.

#### 3.2 Capture by App Type

Use a fixed, repeatable window/viewport, take one screenshot per documented screen (Login, Dashboard, every Core Feature step), and name files in order (`01-login.png`, `02-dashboard.png`, ...). Work in a temp folder (scratchpad), never inside the repository.

- **Web, Blazor Server/WebAssembly/Web App, MVC/Razor Pages, SPA (Proactive Live Browser Auto-Capture)**:
  - Launch the app (`dotnet run`, `npm run dev`, etc.), wait until the URL responds, then capture with Playwright (`pip install playwright` + `playwright install chromium` if needed) or the available browser tools.
  - Fixed desktop viewport **`1280x800`** (or `1366x768`), **viewport-only** (`full_page=False`) by default. Use `full_page=True` only if total page height is under `1200px` (Login, compact forms).
  - For Blazor, wait for interactivity (`wait_for_selector` on a post-render element or `networkidle`) so the "Reconnecting"/loading overlay is not captured.
  - For modals, dialogs, or specific cards, crop to the container so labels stay legible.
  - Embed at a maximum width of **`6.3` inches**, preserving aspect ratio, with a `1 pt` `#CBD5E1` border.

- **Windows Desktop (WPF, WinForms, WinUI, MAUI Windows, Blazor Hybrid on Windows, Avalonia, Qt, JavaFX)**:
  - Prefer the **Windows target** for MAUI/Flutter apps because it needs no emulator.
  - Build and launch (`dotnet run -f net*-windows10.0.19041.0`, built `.exe`, etc.), then capture **only the app window**, not the whole desktop:
    1. **Preferred (scripted, repeatable)**: Python with `pywinauto` (find window by title/process, `set_focus`, `capture_as_image()`), or `pygetwindow` + `PIL.ImageGrab.grab(bbox=...)`. Install via `pip install pywinauto pillow` if missing. Use UI Automation (`pywinauto` `backend="uia"`) to click menus/buttons and fill fields by their exact labels.
    2. **Alternative**: the computer-use tools (`request_access` for the app, then `screenshot`, `left_click`, `type`) when scripting cannot reach the controls.
  - Set a consistent window size (e.g., `1280x800`), 100% display scaling if possible, and wait for the first render before capturing.
  - Embed at a maximum width of **`6.3` inches** with a `1 pt` `#CBD5E1` border.
  - Ask before launching if the app talks to physical hardware (printers, scanners, serial ports) or external production services.

- **Electron / Tauri**: Launch with the project's dev command. For Electron, Playwright's `_electron.launch()` can screenshot the window directly; otherwise use the Windows Desktop method above.

- **macOS / Linux Desktop**: Use `screencapture -l <windowid>` (macOS) or `import -window <id>` / `gnome-screenshot -w` (Linux) when the host OS matches; otherwise use placeholders.

- **Mobile / Android Applications (Mandatory Emulator Confirmation)**:
  - When the codebase is a mobile project (`.NET MAUI` / `net*-android`, `AndroidManifest.xml`, `pubspec.yaml`, `android/`), first check for an active device or emulator (`adb devices`).
  - If none is running, **DO NOT launch an Android Emulator automatically** (heavy RAM/CPU, may need an active backend API or physical peripherals). **STOP and ask the user**:
    "This project is detected as a mobile/Android application. Would you like me to start an Android Emulator to capture live screenshots (requires additional RAM/CPU and an active backend API), capture the Windows/desktop/Web target instead if the project has one, or proceed using `[SCREENSHOT: ...]` placeholders?"
  - If approved, capture portrait screenshots (`adb exec-out screencap -p`) and drive the UI with `adb shell input tap/text` or `uiautomator dump` to find elements by their labels. Embed at **`2.5` to `2.8` inches** wide (optionally side-by-side in a borderless 2-column table) with a `1 pt` `#CBD5E1` border.
  - **iOS Simulator** (macOS only): `xcrun simctl io booted screenshot <file>`; same confirmation rule as the Android emulator.

- **Mandatory Placeholder Callout Boxes (When Live Capture Is Not Possible)**:
  - Whenever capture fails or is not possible (build errors, missing runtime secrets or backend, external SSO, physical hardware, no capture tool, or the user chose placeholders), **you MUST still insert a styled left-bordered `[SCREENSHOT: ...]` callout box** at every major screen step (Login, Dashboard, and each Core Feature workflow) describing the exact screen to capture manually. Never silently skip screenshot blocks.
  - Mixing is allowed: embed real captures where they succeeded and use placeholders for the rest.

#### 3.3 Capture Hygiene & Cleanup

- Verify each image is not blank, not an error page, and shows the intended screen before embedding. Retry once, then fall back to a placeholder for that screen.
- Never run destructive actions (delete, submit real payments, send emails) in the app just to get a screenshot; capture the confirmation dialog, then cancel.
- After capture: stop every process you started (dev server, app window, emulator you started), revert login bypass changes, restore any reset password, and remove temporary dummy data/users you created unless the user asked to keep them. Report each of these in the final summary.

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

Never write dummy/test credentials into the document; describe login steps with the field labels only (or `[credentials provided by your administrator]`).

### Step 5: DOCX Styling & Generation

Read `references/docx-style-spec.md` for exact color codes, typography, and layout rules matching the selected theme:

- Generate `USER_GUIDE.docx` in the selected project root directory using a Python script with `python-docx`.
- Execute the Python script, verify `USER_GUIDE.docx` is created without errors, remove any temporary generator script and temporary raw screenshot files if embedded, and output a concise summary of generated chapters alongside a list of all embedded screenshots and `[SCREENSHOT: ...]` placeholders, the login method used (if any), and the temporary changes that were reverted.

## Gotchas

- Never proceed to Step 2 until target project (including disambiguating multi-project folders), document language, and color theme are all confirmed.
- Never start an Android Emulator or iOS Simulator without explicit user confirmation.
- Never modify, seed, or reset a database unless the connection string is verified as local/dev; if unsure, ask.
- Never commit login bypass code, dummy users' credentials, or temporary seed changes; always revert/restore and report it.
- Never put passwords or tokens in chat output or in `USER_GUIDE.docx`.
- Never try to bypass external SSO, MFA, or CAPTCHA; use placeholders instead.
- Never capture the full desktop when a single app window is the target; crop to the app window.
- Never silently omit screenshots or `[SCREENSHOT: ...]` callout boxes from Chapter 2 and Chapter 3.
- Never use `full_page=True` on long scrolling web pages, as the resulting vertical image shrinks illegibly when fitted into a `.docx` page.
- Never pad chapters with generic AI prose; every paragraph must convey concrete UI behavior from the repository.
- If `python-docx` is not installed in the active environment, install it via `pip install python-docx` before running the generator script.
