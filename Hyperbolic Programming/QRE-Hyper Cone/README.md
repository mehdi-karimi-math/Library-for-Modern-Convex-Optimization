In these problems, we minimize the quantum relative entropy function with some hyperbolic constraints and linear constraints.
The problem is

$$
\begin{array}{ccll}
\textup{min} &  & qre\left(I+\sum_{i=1}^n x_i A_i, I+\sum_{i=1}^n y_i B_i\right) & \\
 & & x  \ \ \in \Lambda_+(p,e) , &  \\
 & & x \ \ \geq \gamma, &  \\
\end{array}
$$

where $qre(X,y)$ is the quantum relative entropy of two symmetric positive definite matrices and $\Lambda(p,e)$ is 
the hyperbolicity cone created by $p$ in the direction of $e$. In these examples, $p$ is a elementary symmetric polynomial with 
parameters $(n,k)$. The files are in the format `data_m_n_k` where $m$ is the size of the matrices in the matrix pencil. The 
files with the additional term `infea` are infeasible optimization problems. 
