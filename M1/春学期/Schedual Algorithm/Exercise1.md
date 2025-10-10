### Assignment4 Huang Jiahui 44251017

#### Problem Definition of FSSP

**Minimize**  $C_{max}$  

> We aim to minimize the makespan, which is the total time required to complete all jobs.

**Constraint**

**Subject to ** 
$$
C_{max}≥ s_{j,m} + p_{j,m}\ \ (j=1,2,...,J)\\
s_{j,k+1}≥s_{j,k}+p_{j,k}\ \ (j=1,2,...,J; k=1,2,...,m-1)\\
s_{j,k}≥s_{l,k}+p_{l,k}-M(1-x^{(k)}_{j,l})\\
s_{l,k}≥s_{j,k}+p_{j,k}-Mx^{(k)}_{j,l}\ \ (j\neq{l};j,l=1,2,...,J;k=1,2,...,m)
$$
**Step 1: Makespan Constraint**

$C_{max}≥ s_{j,m} + p_{j,m}\ \ (j=1,2,...,J)$

> The makespan must be greater than or equal to the finish time of the last operation of every job

**Step 2: Job Precedence Constraint (Intra-job ordering)**

$s_{j,k+1}≥s_{j,k}+p_{j,k}$

> A job's next operation on machine $M_{k+1}$ can only start after it finishes on machine $M_k$

**Step 3: Machine Conflict Constraints (Inter-job sequencing)**

$s_{j,k}≥s_{l,k}+p_{l,k}-M(1-x^{(k)}_{j,l})$
$s_{l,k}≥s_{j,k}+p_{j,k}-Mx^{(k)}_{j,l}\ \ (j\neq{l};j,l=1,2,...,J;k=1,2,...,m)$

> Jobs cannot overlap on the same machine. Either job $j$ goes before job $l$, or vice versa.
>
> Binary variable $x_{j,l}^{(k)}$ determines order. Big-M logic ensures at least one ordering is enforced.



**Fixed values**

**$J$** : number of jobs

**$m$** : number of machines

**$p_{j,k}$** : process time of job $j$ on machine $M_k$

**Decision Variables**

$C_{max}$ : makespan

$s_{j,k}$ : start time of job $j$ on machine $M_k$

$x^{(k)}_{j,l} \in \{0,1\}$ : 1 if job $j$ is before job $l$ on machine $M_k$



