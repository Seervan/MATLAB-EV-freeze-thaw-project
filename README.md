# MATLAB-EV-freeze-thaw-project

Codes and scripts for the EV (Electric Vehicle) freeze-thaw stiffness project.  
This repository includes shape analysis code, Python-based detection scripts, and post-processing tools.

## Project Overview

This project investigates the structural stiffness behaviour of EV battery and chassis components under freeze-thaw cycling conditions.  
The workflows cover:

- **Shape analysis** – MATLAB scripts for geometric and structural shape characterisation
- **Detection** – Python scripts for automated detection of stiffness changes or anomalies
- **Post-processing** – MATLAB tools for analysing and visualising experimental results

## Repository Structure

```
MATLAB-EV-freeze-thaw-project/
├── matlab/
│   ├── shape_analysis/      # Shape characterisation scripts
│   ├── post_processing/     # Post-processing and visualisation tools
│   └── utils/               # Shared utility functions
├── python/
│   └── detection/           # Python-based detection scripts
├── data/
│   ├── raw/                 # Raw experimental data (not tracked by Git)
│   └── processed/           # Processed data outputs
├── results/                 # Figures, plots and result summaries
└── docs/                    # Documentation and notes
```

## Requirements

### MATLAB
- MATLAB R2021a or later
- Signal Processing Toolbox (recommended)
- Statistics and Machine Learning Toolbox (recommended)

### Python
- Python 3.8 or later
- NumPy, SciPy, Matplotlib (see `python/requirements.txt`)

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/Seervan/MATLAB-EV-freeze-thaw-project.git
   ```
2. Open MATLAB and add the `matlab/` folder (with subfolders) to the MATLAB path:
   ```matlab
   addpath(genpath('matlab'));
   ```
3. For Python scripts, install the required packages:
   ```bash
   pip install -r python/requirements.txt
   ```

## Usage

### Shape Analysis (MATLAB)
Run `matlab/shape_analysis/run_shape_analysis.m` to perform shape characterisation on a dataset.

### Detection (Python)
Run `python/detection/detect_stiffness_change.py` to detect stiffness anomalies in processed data.

### Post-processing (MATLAB)
Run `matlab/post_processing/run_post_processing.m` to generate plots and summary statistics.

## License

This project is currently unlicensed. All rights reserved by the author.

## Contact

For questions or collaboration enquiries, please open an issue in this repository.
