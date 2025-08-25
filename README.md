# Operational Command
Alternate-history Cold War RTS focused on command-post gameplay and voice radio orders.

## Layout
- `docs` — Documentation for the project
- `extras` — Extra assets associated with the project
- `src/` — The main project files
  - `addons/` — GDExtensions, editor plugins (build artifacts live here).
  - `audio/` — bus layout, SFX, UI sounds.
  - `data/` — JSON databases (units, maps, briefs/intel).
  - `maps/` — map imagery and height/feature layers.
  - `scenes/` — .tscn scenes for menus, HQ table, tactical map, etc.
  - `scripts/` — GDScript source (see that folder’s docs).
  - `third_party/` — external models/libs (Vosk, VAD).

## Conventions
- Paths are stable IDs; JSON refers to assets with `id` fields matching filenames.
- All JSON is UTF-8, LF line endings.

# Workflow
## 1. Clone the repo
```bash
git clone https://github.com/operationalCommandTeam/Operational-Command.git
cd operational-command
```

## 2. Create a feature branch from the latest main
```bash
git fetch origin
git checkout -b <branch-name> origin/main
```

### Branch naming convention
https://conventional-branch.github.io/#summary
```
<type>/<description>
```
- feature/: For new features (e.g., feature/add-login-page)
- bugfix/: For bug fixes (e.g., bugfix/fix-header-bug)
- hotfix/: For urgent fixes (e.g., hotfix/security-patch)
- release/: For branches preparing a release (e.g., release/v1.2.0)
- chore/: For non-code tasks like dependency, docs updates (e.g., chore/update-dependencies)

## 3. Make changes and commit
```bash
git add -A
git commit -m <commit message>
```

### Commit message convention
https://www.conventionalcommits.org/en/v1.0.0/
```
<type[optional scope]: <description>

[optional body]
```
- fix: For bug patches
- feat: For new features
- BREAKING CHANGE: For changes introducing a breaking API change
- chore: For non-code changes
- docs: For documntation changes
- refactor: For code refactors

## 4. Push your branch
```bash
git push -u origin <branch-name>
```

## 5. Open a Pull Request
- Describe the what/why (add screenshots if UI).
- Link related issues.
- Request a review from the appropriate teammate(s)/team (almost always Tapawingo).