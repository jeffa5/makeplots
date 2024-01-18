# Make plots

This repo explores different options for a data processing pipeline from multiple source data files to multiple plots.

## Setup

We have a directory `results` which contains experiment configuration directories `results/config1`.
Within each configuration directory we expect the results to be in potentially multiple files, assumed to match the glob `results*.csv` here, e.g. `results1.csv` for multiple components that need to be collated.

To process these files we want intermediate steps that speed things up, so a joining of all results files into a single csv at `results/all.csv` should be done, and the `all.csv` should also include columns for the configuration of the experiment, obtained from `results/config1/configuration.json`.

From the `all.csv` file we can proceed with plotting, the first step of which is calculating the data to plot from directly.
For a plot that will be called `plot1` we want a `plot1.csv` for the data, and then another step that takes the data and builds the plot to `plot1.png` for example.

## Aims

1. From a clean state (only source data files) all plots can be built
2. Parallelism in execution: after building the central data file steps should be very parallelisable
3. Only the steps needed to recompute a target should be executed again
4. The process should be sensitive to changes in logic, e.g. change of plot styling, not just data

## Solutions

### Make

The directory `make` shows an example of a basic setup.

To get all of the plots run `make all-plots`.
The plots will then be available in the `plots` directory.

### Nix

Make is ok, but it can be easy to miss dependencies, leading to things not rebuilding properly.
Nix fixes this by only giving the program access to what it asks for, not the entire world.

To get all of the plots run `nix build .#all-plots`.
The plots will then be available in the `result` directory.

## Notes

We want to track the files that a program takes as input, and those it produces.
We also want to track the file being executed for changes.
But what about system dependencies, or shared files?
For instance, I might want a shared `barplot.py` file that provides a common function so that all of my barplots look similar.
I would need to have this as a dependency for all of my plot scripts as I don't easily know what they import.
At least in `make` this is difficult, I'd need to have a naming convention like `bar_latency.plot.py` to be able to adjust the import dependencies and prevent a change to my scatterplot helper file rebuilding all of my bar plots.
Maybe this isn't actually too bad and I could make it work.
