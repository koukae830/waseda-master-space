# Neural Networks **Assignment** 4

$ 44251017 \ Huang Jiahui$

#### Q1. Summarize the key idea of the BP algorithm briefly.

> Ans: The Backpropagation (BP) algorithm is a supervised learning method used to train neural networks. It computes the gradient of the loss function with respect to all the weights in the network using the chain rule of calculus. The training process includes two phases: forward pass (computing outputs) and backward pass (computing gradients and updating weights). BP helps minimize the error between predicted and target outputs through iterative gradient descent.

#### Q2. 

##### ① (1)Derive the backpropagation (BP) training algorithm and describe your derivation process.

> Ans:
>
> Given:
>
> - $x(t)$:input
> - $d(t)$: target output
> - $W_1∈ \mathbb{R}^{M \times 1}, b_1 \in \mathbb{R}^M$
> - $W_2 \in \mathbb{R}^{1 \times M}, b_2 \in \mathbb{R}$
> - Hidden output: $Z = f_1(W_1 x(t) + b_1)$
> - Network output: $y(t) = f_2(W_2 Z + b_2)$
> - Loss: $E = \frac{1}{2}(d(t) - y(t))^2$
>
> **Backward propagation:**
>
> Output error:
>
> $δ_2=(y(t)−d(t))⋅f_2′(W_2Z+b_2)$
>
> Hidden error:
>
> $δ1=f_1′(W_1x+b_1)⊙(W_2⊤δ_2)$
>
> Gradients:
>
> $ΔW_2=−μδ_2Z^⊤$,$Δb_2=−μδ_2$
>
> $ΔW_1=−μδ_1x(t)$,$Δb_1=−μδ_1$

##### ① (2)How many $δ$'s are there in this MLP?

> Ans: 
>
> There are:
>
> M $δ$ values in the hidden layer $(δ1)$
>
> 1 $δ$ value in the output layer $(δ2)$
>
> Thus:
>
> Total: (M + 1) $δ$

##### ② Refer to and fill out the following table.

| t    | $W_1/b_1  $                                              | $W_2/b_2$                          | $Z$           | $y(1) $   | $ δ1$        | $δ2$     | $ΔW_1/Δb_1$                                                 | $   ΔW_2/Δb_2$                           |
| :--- | -------------------------------------------------------- | ---------------------------------- | ------------- | :-------- | ------------ | -------- | ----------------------------------------------------------- | ---------------------------------------- |
| 0    | [[0.3 -0.3]] /[0.0 0.0]                                  | [[-0.1] [0.1]] / [0.0]             | [0.21 0]      | [-0.021]  | [-0.07 0.0]  | [0.701]  | [[-0.01 0.0]] / [-0.014 0.0]                                | [[0.029] [0.0]] / [0.14]                 |
| 1    | [[0.29 -0.3]] / [-0.014 0.0]                             | [[-0.071] [0.1]] / [0.14]          | [0.189 0.000] | [0.12686] | [0.04 -0.00] | [-0.553] | [0.005464015277130524 -0.0] / [0.007805736110186464 -0.0]   | [-0.020921005654136793 -0.0] / -0.11063] |
| 2    | [0.28472198472286947 -0.3] / [-0.021825736110186466 0.0] | [-0.04963699434586322 0.1] / 0.251 | [0.177 0.000] | [0.24202] | [0.02 -0.00] | [-0.438] | [0.0030436078268129027 -0.0] / [0.00434801118116129 -0.0]   | [-0.015546539968699284 -0.0] / -0.0876   |
| 3    | [0.28167837689605657 -0.3] / [-0.026173747291347756 0.0] | [-0.03409045437716393 0.1] / 0.338 | [0.171 0.000] | [0.33260] | [0.01 -0.00] | [-0.347] | [0.0016580456582325352 -0.0] / [0.0023686366546179075 -0.0] | [-0.011881317512705972 -0.0] / -0.06948  |

