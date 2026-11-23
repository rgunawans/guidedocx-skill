# GuideDOCX (`guidedocx-skill`)

An AI Agent Skill that analyzes a software repository or codebase and generates a crisp, anti-hallucination, anti-slop **End-User Guide (`USER_GUIDE.docx`)** in Microsoft Word format using `python-docx`.

## Features

- **Mandatory Repository Validation**: Stops and asks which repository or codebase to document if no target path or workspace is specified.
- **Anti-Hallucination & Anti-Slop Grounding**: Extracts exact UI labels, button names, and validation messages from the source code while banning generic AI filler prose.
- **Smart Visual Capture**:
  - **Web UI**: Captures desktop viewport screenshots (`1280x800`, `full_page=False`) constrained to `6.3 inches` wide with subtle borders.
  - **Mobile / Android**: Checks `adb devices` first and **always asks confirmation** before launching an Android Emulator.
  - **Safe Fallback**: Inserts styled `[SCREENSHOT: ...]` callout boxes when live capture is unavailable.
- **5 Curated Word Themes**: Includes **Corporate Cobalt** (default), **Slate & Steel**, **Emerald Operations**, **Deep Teal & Cyan**, and **Amber & Charcoal**.

## Installation

### Option 1: Using `npx skills`
```bash
npx skills add rgunawans/guidedocx-skill