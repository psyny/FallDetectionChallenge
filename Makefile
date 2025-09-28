.PHONY: default env install kernel start clean freeze doctor help mac_hint
SHELL := /bin/sh

# Prefer Python 3.11 for ML stability; allow override (e.g., `make PY=python3.11`)
PY ?= python3.11
VENV := .venv
PIP := $(VENV)/bin/pip
PYBIN := $(VENV)/bin/python
JUPYTER := $(VENV)/bin/jupyter
REQ := requirements.txt

default: help

help:
	@echo "make env       -> create virtualenv (uses $(PY))"
	@echo "make install   -> install dependencies from $(REQ)"
	@echo "make kernel    -> register 'Python (fall-detection)' kernel"
	@echo "make start     -> open Jupyter (classic/nbclassic fallback to Lab)"
	@echo "make freeze    -> export pinned deps to $(REQ)"
	@echo "make doctor    -> quick environment check (imports xgboost, shows versions)"
	@echo "make clean     -> cleanup pyc and checkpoints"
	@echo "make mac_hint  -> show macOS note about OpenMP (libomp)"

env:
	$(PY) -m venv $(VENV)

install: env
	@# macOS OpenMP hint (non-fatal): prints if on Darwin
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		echo "macOS detected. If XGBoost fails to load, run: brew install libomp"; \
	fi
	$(PIP) install --upgrade pip
	$(PIP) install -r $(REQ)

kernel: install
	$(PYBIN) -m ipykernel install --user --name=fall-detection --display-name="Python (fall-detection)"

start:
	( $(JUPYTER) notebook --NotebookApp.kernel_name=fall-detection \
	|| $(JUPYTER) nbclassic --ServerApp.kernel_name=fall-detection \
	|| $(JUPYTER) lab )

freeze:
	$(PIP) freeze > $(REQ)
	@echo "Wrote pinned deps to $(REQ)"

doctor:
	@echo "Python: " && $(PYBIN) -V
	@echo "Pip: " && $(PIP) --version
	@echo "NumPy: " && $(PYBIN) -c "import numpy as _; print(_. __version__)"
	@echo "Pandas: " && $(PYBIN) -c "import pandas as _; print(_. __version__)"
	@echo "XGBoost: " && $(PYBIN) -c "import xgboost as _; print(_. __version__)"
	@echo "OK. If XGBoost failed to import on macOS, run: brew install libomp"

mac_hint:
	@echo "macOS + XGBoost needs OpenMP runtime. Install with: brew install libomp"

clean:
	find . -name "*.pyc" -delete
	rm -rf .ipynb_checkpoints
	rm -rf $(VENV)

# Remove the registered Jupyter kernel (safe to re-run `make kernel` after)
clean-kernel:
	- jupyter kernelspec remove -f fall-detection || true

# Convenience combo: nuke venv + kernel + pycache
clean-all: clean clean-kernel
