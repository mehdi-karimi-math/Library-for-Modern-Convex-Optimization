# Hyperbolic Programming Library
This repository provides a library of hyperbolic programming problems, a class of convex optimization problems involving constraints defined by hyperbolicity cones.
The hyperbolic polynomials are efficiently representable as elementary symmertric polynomials. 

The library is organized into folders, each corresponding to a different construction method for hyperbolicity cones and combined with other classes of convex optimization 
problems. The folders are
   - **Entropy-ESP**: These are problems of minimizing the vector entropy of a vector subject to a hyperbolic constraint and some linear constraints.
   - **Projection-Hyper Cone**: These are problems of projecting a vector on a given hyperbolicity cone. The hyperbolic polynomials are:
     * elentray symmetric polynomials
     * Vamos-like hyperbolic polynomials
   - **Composite Hyperbolic**: The hyperbolic polynomails in these problems are created by compositing two hyperbolic polynomials.
   - **QRE-Hyper cone**: These problems are minimizing the quantum relative entropy of two matrix pencils subject to a hyperbolic constrait and some linear constraints.
