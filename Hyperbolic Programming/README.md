# Hyperbolic Programming Library
This repository provides a library of hyperbolic programming problems, a class of convex optimization problems involving constraints defined by hyperbolicity cones.
The hyperbolic polynomials are efficiently representable as elementary symmertric polynomials. To learn more about our recent advances in hyperbolic programming, including the new straight-line program (SLP) framework, the release of DDS 3.0, and the development of this benchmarking library, please refer to our manuscript:

[Efficient Interior-Point Methods for Hyperbolic Programming via Straight-Line Programs](https://arxiv.org/abs/2602.23260)

## Creating the tables and the figure in the paper
- **Install DDS 3.0**: Download and install the MATLAB-based software DDS 3.0: [https://github.com/mehdi-karimi-math/DDS](https://github.com/mehdi-karimi-math/DDS).
  The installation is by running the file `DDS_startup.m`. 
- **Download this repository**: Download (or clone) the entire folder `Hyperbolic Programming` from this GitHub repository and place it inside the main DDS folder.
- **Run the table-generation script**: Run the following file
   ```
     Create_Tables_Paper.m
  ```
  There is a varaible `short_version`, which is set to `true` by default. This generates shortened versions of the tables. To generate the full tables reported in the paper, set: `short_version = false;`. Note that some
  larger benchmark instances may require up to approximately 4000 seconds to complete. 
- **Output Files**: The generated tables will be saved as separate text files (in LaTeX format) inside the `Hyperbolic Programming` folder. Two generated figures will also be saved in the same folder. 
- **Reproducing Table 2 (DDS vs. Frank–Wolfe)**: To reproduce Table 2, download the Frank–Wolfe (FW) implementation from: [https://github.com/bflourenco/dfw_projection](https://github.com/bflourenco/dfw_projection).
 Place the folder `solver` inside the `Hyperbolic Programming` directly before running the `Create_Tables_Paper.m` file.
- Table 1 includes results from DDS 2.2. This older version is not included in the current repository. Those results were generated separately using DDS 2.2. 
  
  
## Benchmark Details

The library is organized into folders, each corresponding to a different construction method for hyperbolicity cones and combined with other classes of convex optimization 
problems. The folders are
   - **Entropy-ESP**: These are problems of minimizing the vector entropy of a vector subject to a hyperbolic constraint and some linear constraints.
   - **Projection-Hyper Cone**: These are problems of projecting a vector on a given hyperbolicity cone. The hyperbolic polynomials are:
     * Elementary symmetric polynomials
     * Vamos-like hyperbolic polynomials
   - **Composite Hyperbolic**: The hyperbolic polynomails in these problems are created by compositing two hyperbolic polynomials.
   - **QRE-Hyper cone**: These problems are minimizing the quantum relative entropy of two matrix pencils subject to a hyperbolic constrait and some linear constraints.
