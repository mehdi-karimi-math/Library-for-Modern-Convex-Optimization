The problem is projecting an arbitrary vector on a given hyperbolicy cone, which we can formulate as

$$
\begin{array}{rrl}
\min  &   t   &   \\
\text{s.t.}  &   \lVert x-c \rVert  & \leq t     \\
      &   x   & \in \Lambda_+(p,e),    
\end{array}
$$

This problem was studied ifirst in the paper *Projection onto hyperbolicity cones and beyond: a dual Frank-Wolfe approach* by Takayuki Nagano, Bruno F. Lourenço and Akiko Takeda by using a Frank-Wolf algorithm. For DDS, the MATLAB function `hyper_proj_DDS` is 
created to project a given vector into a hyperbolicity cone given as a straight-line program. For example, to project a vector `c` 
on a hyperbolicity cone created by an elementray symmetric polynomial with parameter $(n,k)$ we can write:

```
poly = generate_ek_slp(n,k);
[x,y,info] = hyper_proj_DDS(c,poly,ones(n,1),n,k);
```
Each file in the directory has the format `c_n_k` where $(n,k)$ are the parameters of the elementary symmetric polynomial. Each file contains 10 random samples of the vecytors that are used to create Table 2 in the paper. To create the table, you can run the file
```
Proj_DDS_FW
```
in this folder which runs both the FW algorithm and DDS and put the table in the Latex format in a file `results_DDS_FW.txt`. Note that you have to first install DDS and FW. The FW code can be downloaded from 

https://github.com/bflourenco/dfw_projection

and for the installation, you just need to add the foder `solver` to your path in MATLAB. 
