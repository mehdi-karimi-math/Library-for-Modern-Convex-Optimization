In this section, we investigate an optimization problem of minimizing the entropy of a vector under both hyperbolic and linear constraints. The problem can be written as:

$$
\begin{aligned}
\min  &   \text{entr}(x)   &   \\
\text{s.t.}  &   Ax+b    & \in \Lambda_+(p,e)    \\
      &   x   & \geq \gamma \mathbf{e},
\end{aligned}
$$

where $p=e_k^n(x)$ is an elemtary symmetric polynomial with $n$ variables and degree $k$, and $e$ is the vector of all $1$. This folder contains instances where $A$ is a random $\{0,1\}$ matrix, $b$ is the vector of all 1, and $\gamma=0.5$. The format of the name of the file is `data_n_k` and is in MATLAB data format. The data is ready to use with DDS by the command
```
[x,y,info]=DDS(c,A,b,cons)
```
For extracting matrix $A$, one can use the command `A{1}(:,1:end-1)`.
