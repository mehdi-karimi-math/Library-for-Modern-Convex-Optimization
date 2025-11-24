As discussed in the paper, the characteristic polynomials of certain matroids are hyperbolic. One notable example is the class of Vamos-like matroids, whose characteristic polynomial is given as follows:

$$
p^m_{VL}(x):=  e_4^{2m}(x_1,\ldots,x_{2m}) - \left(\sum_{i=2}^m x_1x_2x_{2k-1}x_{2k} \right) - \left(\sum_{i=2}^{m-1} x_{2k-1}x_{2k}x_{2k+1}x_{2k+2}\right),
$$

where $e_4^{2m}$ is an elementary symmetric polynomial with $2m$ variables and degree $4$. These polynomials can also be efficienly represented as straight-line
programs. A DDS internal function 
```
poly = generate_vamos_like_slp(m)
```
generates the staright-line program for the polynomial. The files in this folder have the format `c_2m` and each contains 10 random vectors of size $2m$ that were used to 
create Table 3 of the paper for the problem of projecting a vector on the hyperbolicty cone created by a Vamos-like polynomial. To run each of these examples using DDS, for 
a given vector $c$, we can use the code
```
[x,y,info]=hyper_proj_DDS(c,poly,ones(2m,1),2m,4)
```
