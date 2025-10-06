# Contributing

## Prerequisites
- Godot **4.5.x** (stable)
- Git, Git LFS (if large binary assets are introduced)

## Local Dev Setup
1. Clone the repo.
2. Open `project.godot` in Godot 4.5.
3. Run the default scene.

## Workflow
**Branching**
- Default branch: `main`
- Feature branches: `feature/<short-topic>`
- Fix branches: `hotfix/<short-topic>`
- Chore/tooling: `chore/<short-topic>`
- Example: `featature/terrain-effects`, `hotfix/navmesh-stall`

**Commits**
- Use [Conventional Commits](https://www.conventionalcommits.org/):  
  `feat: add morale penalties in heavy weather`  
  `fix(ui): prevent double-click crash in unit panel`

**Pull Requests**
- Small, focused PRs are ideal.
- Include a short description, screenshots/GIFs for UI.
- Checklist before opening:
  - [ ] Compiles (Editor & headless smoke compile)
  - [ ] No new warnings/errors in logs
  - [ ] In-code docs added/updated (see **Code Style**)

**Reviews & Merges**
- At least one approval required.
- Squash-merge with a clean title (Conventional Commit style).

**Releases**
- Tag `vX.Y.Z` ([semver](https://semver.org/)). Changelog uses merged PR titles.

## Code Style

**Language**
- GDScript for gameplay code.

**Documentation comments**
- Document **scripts, signals, enums, constants, `@export`s, and functions**.
- Keep comments **short and precise**.
- Use Godot’s [GDScript documentation comment format](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html) (Godot 4.5).
- Example:
```python
  class_name MissionFlow
  extends Node
  ## Controls mission state and transitions.
  ## @tutorial(Dev Docs) res://docs/mission_flow.md

  ## emitted when mission is completed.
  signal mission_completed(result: int)

  ## Current mission state
  enum State { INIT, RUNNING, DEBRIEF }

  ## Hard cap to keep perf predictable.
  const MAX_UNITS := 64
  
  ## Applied to combat calc.
  @export_range(0.0, 1.0, 0.05) var morale_modifier: float = 0.0

  ## Start mission runtime systems.
  func start() -> void:
      pass
```
- Prefer clear names, early returns, small functions.

## Testing & CI
- Full tests:
```bash
  make all # or `make all-fix` to auto-format files
```
- CI should at minimum run format and lint on PRs.

## Project Conventions
- Scenes: Keep scenes focused; avoid monoliths. Use composition.
- Data: Use Resources for scenario/config data with serializers to JSON for rest; keep them diff-friendly.
- Performance: Avoid heavy per-frame work; prefer signals/timers/state machines.
- Assets: Large binaries through Git LFS; avoid committing private licensed content.

## Issue Labels
- `Type: Feature`, `Type: Hotfix`, `Type: Chore`, `Type: Docs`
- `Area: AI`, `Area: UI`, `Area: Programming`, `Area: Art`, `Area: Sound`, `Area: Writing`
- `Status: Help Wanted`, `Status: Blocked`

## Security & Secrets
- Never commit signing certificates.
- Use environment variables or local files ignored by Git.

## Communications
- Keep design discussions on issues/PRs for traceability.
- Link to relevant parts of the [Game Design Doc](https://github.com/operationalCommandTeam/Operational-Command/blob/main/docs/game_design.md) when decisions affect gameplay.
- Other communication on discord.