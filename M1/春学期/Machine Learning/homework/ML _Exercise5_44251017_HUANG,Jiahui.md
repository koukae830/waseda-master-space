### Exercise 5 Derivation of Ridge Regression

$ 44251017 \ Huang\ Jiahui$

<img src="/Users/kaekou/Library/Application Support/typora-user-images/image-20250618104232452.png" alt="image-20250618104232452" style="zoom: 33%;" />

#### Q1

Ridge regression loss function:
$$
E(w) = \frac{1}{2} \| t - Xw \|^2 + \frac{\lambda}{2} \|w\|^2
$$
Gradient:
$$
\nabla_w E = X^T(Xw - t) + \lambda w
$$
Gradient descent update rule:
$$
w_{t+1} = w_t - \eta \left[X^T(Xw_t - t) + \lambda w_t\right]
$$


#### Q2



For a single training example $(x_i, t_i)$, the loss function is:
$$
E_i(w) = \frac{1}{2}(t_i - w^T x_i)^2 + \frac{\lambda}{2} \|w\|^2
$$
Gradient:
$$
\nabla_w E_i = - (t_i - w^T x_i) x_i + \lambda w = (w^T x_i - t_i) x_i + \lambda w
$$
SGD update rule:
$$
w \leftarrow w - \eta \left[(w^T x_i - t_i)x_i + \lambda w\right]
$$