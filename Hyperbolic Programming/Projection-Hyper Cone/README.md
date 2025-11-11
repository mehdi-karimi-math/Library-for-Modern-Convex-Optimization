The problem is projecting an arbitrary vector on a given hyperbolicy cone, which we can formulate as

$$
\begin{array}{rrl}
\min  &   t   &   \\
\text{s.t.}  &   \lVert x-c \rVert  & \leq t     \\
      &   x   & \in \Lambda_+(p,e),    
\end{array}
$$

This problem was studied in by Nagano-Lourenco-Takeda (2024) using a Frank-Wolf algorithm. The MATLAB function `hyper_proj_DDS` is 
created to project a given vector into a hyperbolicity cone given as a straight-line program. For example, to project a vector `c` 
on a hyperbolicity cone created by an elementray symmetric polynomial with parameter $(n,k)$ we can write:

```
poly = generate_ek_slp(n,k);
[x,y,info] = hyper_proj_DDS(c,poly,ones(n,1),n,k);
```
