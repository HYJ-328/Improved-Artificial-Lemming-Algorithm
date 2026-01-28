# Improved Artificial Lemming Algorithm for Three-Dimensional UAV Path Planning

**Abstract:** With the widespread application of unmanned aerial vehicles (UAVs) in military reconnaissance, agricultural monitoring, and disaster rescue, safe and efficient flight path planning in complex three-dimensional environments has become a critical challenge. UAV path planning is essentially a multi-constraint optimization problem that involves terrain obstacles, no-fly zones, flight altitude, and energy consumption. To overcome the limitations of the artificial lemming algorithm (ALA), including slow convergence and susceptibility to local optima in high-dimensional complex optimization problems, this paper proposes an improved artificial lemming algorithm (IALA). Experimental comparisons based on the CEC2017 benchmark functions demonstrate that IALA outperforms other algorithms in terms of convergence speed, optimization accuracy, stability, and Wilcoxon rank-sum test results, and exhibits superior performance on unimodal, multimodal, hybrid, and composition functions. Furthermore, the proposed IALA is applied to a three-dimensional UAV path planning problem, where it efficiently generates safe and feasible flight paths in complex environments. Compared with the original ALA, the optimal value is reduced by 1.14%, confirming the effectiveness and practical applicability of the proposed improvement strategy in real-world engineering scenarios.

**Index Terms:** Artificial Lemming Algorithm, Unmanned Aerial Vehicle, Three-Dimensional Path Planning

## Project Structure

```
.
├── *.m                       # Core optimizer implementations (IALA, ALA, WOA, etc.)
├── main1.m                   # Single-function CEC2017 benchmark run + convergence plot
├── main2.m                   # Batch CEC2017 benchmark run + statistics & Excel export
├── Get_Functions_cec2017.m   # CEC2017 benchmark function handle & bounds
├── func_plot2017.m           # CEC2017 surface visualization helper
├── cec17_func.cpp            # CEC2017 function implementation (for MEX)
├── cec17_func.mexw64         # Prebuilt MEX binary (Windows)
├── input_data/               # CEC2017 shift/rotation/shuffle data files
└── application/              # 3D UAV path planning demo + supporting optimizers
```

## Key Components

### Optimizers (root directory)
- **IALA.m**: Improved Artificial Lemming Algorithm with Hammersley initialization, competitive learning, and defense mechanisms.
- **ALA.m / WOA.m / HBA.m / PSA.m / BKA.m / RRTO.m / WAA.m**: Baseline optimization algorithms used for comparisons (see their respective `.m` files).

### CEC2017 Benchmarking
- **Get_Functions_cec2017.m** exposes function bounds and handles, while **func_plot2017.m** plots CEC2017 functions for visualization. `main1.m` runs a single function and plots convergence, and `main2.m` runs a full sweep with statistics, rank-sum tests, and Friedman rankings (exported to Excel).

### 3D UAV Path-Planning Application
The `application/` folder contains a full path-planning demo with a threat map, start/end points, and multiple optimizers competing to find feasible trajectories. The entry point is `application/main.m`, which:
- Builds the environment and threat cylinders.
- Runs IALA/ALA/DOA/NRBO/GRO/ABC across multiple trials.
- Plots mean convergence curves and best path trajectories.
- Saves figures for map and planning results.

## Getting Started

### Requirements
- MATLAB (tested with scripts in this repository).
- If you want to compile the CEC2017 MEX interface, a supported C++ compiler for `mex`.

### Run a Single CEC2017 Function Benchmark
Open MATLAB in the repo root and run:

```matlab
main1
```

This executes IALA and baselines on one selected CEC2017 function and plots the convergence curve and function surface.

### Run Full CEC2017 Benchmark Suite
```matlab
main2
```

This runs 29 CEC2017 functions, performs statistical tests, optionally creates box plots, and exports results to Excel (`CEC2017-<D>_Metrics_Results.xlsx`, `CEC2017-<D>_Rank_Sum_Test_Results.xlsx`, and `CEC2017-<D>_Friedman_Test_Results.xlsx`).

### Run the 3D UAV Path-Planning Demo
```matlab
cd application
main
```

This generates a threat map, plots candidate paths from multiple algorithms, and saves figures such as `Planning_Results.png` and `Convergence_Curve.png`.

## Notes
- The `input_data/` directory contains the shift/rotation/shuffle files required by the CEC2017 benchmark suite.
- The included `cec17_func.mexw64` is a prebuilt Windows binary; rebuild it for other platforms using MATLAB `mex`.
