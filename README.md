# Fall Detection Challenge

# About

This repository contains the solution for a **Machine Learning Challenge** focused on **fall detection** using wearable sensor data.  
The goal is to build and evaluate models capable of distinguishing between daily activities, near-falls, and actual falls from multivariate time-series signals.  

The project includes:
- Data loading and preprocessing pipelines  
- Baseline models (e.g., XGBoost)  
- Advanced time-series approaches (e.g., MiniRocket)  
- Evaluation, visualization, and comparison of results  

Notebooks and scripts are organized to make the workflow reproducible and easy to follow.

The final report is on the `./reports` folder.


# Project Structure

```bash
FallDetectionChallenge/
├── data/                    # Data directory
│   ├── artifacts/          # Processed data for ML models
│   ├── consolidated/       # Cleaned and consolidated datasets
│   └── raw/               # Original sensor data from subjects
├── models/                 # Trained machine learning models
├── notebooks/             # Jupyter notebooks for analysis
├── reports/               # Generated reports
├── Makefile              # Build automation
├── requirements.txt      # Python dependencies
└── run_all.sh            # Complete pipeline script
```

## Key Components

- **data/**: Contains raw sensor data, consolidated datasets, and model-ready artifacts
- **models/**: Stores trained XGBoost and MiniRocket models with their outputs
- **notebooks/**: Step-by-step analysis and model development workflow
- **reports/**: Generated analysis reports and visualizations

# Notebooks

Notebooks in `./notebooks` folders are named in the order they are meant to run. 

The download dataset might fail due to rate limiters and google drive access to the database. In this case, download the dataset manually from:

[Google Drive Dataset](https://drive.google.com/drive/folders/1Rr5eI8btUAKqDjmDc2vxRyu0C0yRX1Xl)

And put it into `./data/raw`

# How to Run

## Prerequisites
- **Python**: default is **3.11** (recommended for ML stability). You can override with `make PY=python3.12`, etc.
- **Make** & a POSIX shell (macOS/Linux).  
  On Windows, use **WSL** or run the equivalent commands manually (see below).
- **Homebrew (macOS only)** if you need `libomp` for XGBoost.

> **macOS note (OpenMP / XGBoost):**  
> If XGBoost fails to import, run:
> ```bash
> brew install libomp
> ```

## Two-liner (recommended on MacOS)
```bash
brew install libomp
make install kernel start
```

This will:

1. Create a virtualenv at .venv

2. Install dependencies from requirements.txt

3. Register a Jupyter kernel named Python (fall-detection)

4. Launch Jupyter (Notebook → nbclassic → Lab fallback)

# How to Run (Details and Windows)

## Common tasks (Make targets)

```bash
make env           # create .venv using python3.11 (override with PY=...)
make install       # install from requirements.txt (prints macOS libomp hint)
make kernel        # register 'Python (fall-detection)' ipykernel
make start         # open Jupyter with that kernel preselected
make freeze        # pin current deps to requirements.txt
make doctor        # print versions + import-check (NumPy/Pandas/XGBoost)
make clean         # remove pyc, .ipynb_checkpoints, and .venv
make mac_hint      # show macOS libomp note
make clean-kernel  # remove the registered Jupyter kernel
make clean-all     # clean + clean-kernel (full reset)
```

## Quickstart (step-by-step)

### 1) create venv
```bash
make env
```

### 2) install deps
```bash
make install
```
### 3) register Jupyter kernel
```bash
make kernel
```
### 4) launch notebooks
```bash
make start
```
## Verify your environment
```bash
make doctor
```
Expected output includes Python/Pip versions and successful imports for NumPy, Pandas, and XGBoost.
If XGBoost import fails on macOS, run:

```bash
brew install libomp
```

…and then re-run:

```bash
make clean-all
make install
make doctor
```

# Windows (no WSL) – manual equivalents
## Create venv
```bash
python -m venv .venv
```
## Activate
### PowerShell:
```bash
. .\.venv\Scripts\Activate.ps1
```
## Install deps
```bash
pip install --upgrade pip
pip install -r requirements.txt
```
## Register Jupyter kernel
```bash
python -m ipykernel install --user --name=fall-detection --display-name="Python (fall-detection)"
```
## Start Jupyter
```bash
jupyter notebook   # or: jupyter lab
```
