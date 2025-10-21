PY            ?= python
SRC           ?= ./src
DOCS          ?= ./docs
PATHS         ?= $(SRC)
LINE_LEN      ?= 100
COLOR         ?= always
PIP_QUIET     ?= 2
PROJECT_ROOT  ?= $(SRC)
DOCS_ROOT     ?= $(SRC)
GAME_DOCS	  ?= $(DOCS)/game
GODOT_BIN     ?=
GODOT_ARG      = $(if $(GODOT_BIN),--godot-bin "$(GODOT_BIN)",)

.PHONY: all all-fix format fix-format lint parse scene smoke docs help

all: 
	$(PY) -m tools.gdtoolkit_run --check --line-length $(LINE_LEN) --pip-quiet $(PIP_QUIET) --color=$(COLOR) --project-root $(PROJECT_ROOT) $(PATHS)

all-fix: 
	$(PY) -m tools.gdtoolkit_run --line-length $(LINE_LEN) --pip-quiet $(PIP_QUIET) --color=$(COLOR) $(PATHS)

help:
	@echo "Targets:"
	@echo "  all          Run all checks (format-check, lint, parse, scene, smoke)"
	@echo "  format       Run gdformat in --check mode"
	@echo "  fix-format   Apply formatting changes"
	@echo "  lint         Run gdlint"
	@echo "  parse        Run gdparse (syntax only)"
	@echo "  scene        Run scene linter"
	@echo "  smoke        Run Godot smoke compile (set GODOT_BIN if needed)"
	@echo ""
	@echo "Vars (override with VAR=value):"
	@echo "  PATHS=$(PATHS)  LINE_LEN=$(LINE_LEN)  COLOR=$(COLOR)  PIP_QUIET=$(PIP_QUIET)  PROJECT_ROOT=$(PROJECT_ROOT)  GODOT_BIN=$(GODOT_BIN)"

format:
	$(PY) -m tools.gdtoolkit_run --format-only --check --line-length $(LINE_LEN) --pip-quiet $(PIP_QUIET) --color=$(COLOR) $(PATHS)

fix-format:
	$(PY) -m tools.gdtoolkit_run --format-only --line-length $(LINE_LEN) --pip-quiet $(PIP_QUIET) --color=$(COLOR) $(PATHS)

lint:
	$(PY) -m tools.gdtoolkit_run --lint-only --pip-quiet $(PIP_QUIET) --color=$(COLOR) $(PATHS)

parse:
	$(PY) -m tools.gdtoolkit_run --parse-only --pip-quiet $(PIP_QUIET) --color=$(COLOR) $(PATHS)

scene:
	$(PY) -m tools.gdtoolkit_run --only-scene-linter --pip-quiet $(PIP_QUIET) --color=$(COLOR) $(PATHS)

smoke:
	$(PY) -m tools.gdtoolkit_run --smoke-only --project-root $(PROJECT_ROOT) $(GODOT_ARG) --color=$(COLOR)

docs:
	$(PY) -m tools.generate_docs $(PATHS) --out $(GAME_DOCS) --make-index --extra --keep-structure --split-functions
