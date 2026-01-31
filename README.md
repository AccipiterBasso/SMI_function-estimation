# Description

This R script provides a function to estimate the **Scaled Mass Index (SMI)** following Peig & Green (2009) [DOI:  https://doi.org/10.1111/j.1600-0706.2009.17643.x].

## Function Overview

The function performs the following steps:

1. **Selects the morphometric variable** most strongly correlated with body mass **on a log–log scale**.
2. **Fits a Standardized Major Axis (SMA) model** to estimate the scaling exponent.
3. **Computes individual SMI values** for each observation.
4. **Generates graphical outputs** for visual exploration, including:
   - Scatterplots of mass vs. the selected morphometric variable.
   - Log–log plots with the SMA regression line and slope.
   - Individual SMI values projected on the original scale for visual inspection.

## Note

The core functionality of SMI estimation is complete. The code is under active development and may be refined or extended in future versions.