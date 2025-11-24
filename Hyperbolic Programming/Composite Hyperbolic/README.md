We can construct hyperbolic polynomials by composing two functions. For a given hyperbolic polynomial $p$ in the direction $e$, we define _characteristic map_
as a function $\lambda$ that returns the eigenvalues of $x$ with respect to the polynomial $e$. We have the following theorem for composing two heyperbolic polynomials:

**Theorem (Bauschke et al., 2001 — Theorem 3.1):**
Suppose $q : \mathbb{R}^d \to \mathbb{R}$ is a homogeneous symmetric polynomial of degree $k$,
hyperbolic with respect to $e = (1,1,\ldots,1)^\top \in \mathbb{R}^d$, with characteristic map $\mu$.
Let $p : \mathbb{R}^m \to \mathbb{R}$ be hyperbolic of degree $d$ with respect to $\hat{e} \in \mathbb{R}^m$,
with characteristic map $\lambda$. Then $q \circ \lambda$ is hyperbolic of degree $n$ with respect to $\hat{e}$,
and its characteristic map is $\mu \circ \lambda$.

In general, there is no closed form solution for the characteristic map of a polynomial. For the special case that the hyperbolic
polynomial is the product of linear forms, we can find a closed form solution. We represent a linear form with $d$ terms and $m$ variables
by a $d$ by $m$ matrix where each row represents the coefficients of the variables in each term. For a given matric $M$ and a direction $d$, 
the following code creates the straight-line program for the composition of a polynomial given in `poly` and the characteristic map of the 
polynomial defined by $M$:
```
generate_comp_char(M, d, poly)
```

This folder contains examples of hyperbolic polynomials as the composition of two functions. The file names are in the format
`data_d_k_m` where $d$, $k$, and $m$ defined in the above theorem. $p$ is an elementary symmetric polynomial with parameters $(d,k)$
and $q$ is a linear form with $d$ terms and $m$ variables. The file contains a vector $x_p$ and the data in the format of DDS 
`(c,A,b,cons)` to project $x_p$ on the hyperbolicty cone defined by the composite function. We can solve the problem as

```
[x,y,info] = DDS(c,A,b,cons);
```
The file also contains the matrix $M$ for defining a linear form that is hyperbolic in the direction of vector of all ones. To 
generate the straight line program for the hyperbolic polynomial, we can use
```
poly_ESP = generate_ek_slp(d,k);
poly_comp = generate_comp_char(M, ones(m,1), poly);
```
