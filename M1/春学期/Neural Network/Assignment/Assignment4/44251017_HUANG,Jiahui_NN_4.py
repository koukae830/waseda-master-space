import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

# 1. Load and prepare the dataset
data = pd.read_csv("two_spiral.data.txt", delim_whitespace=True, header=None)
data.columns = ["x1", "x2", "label"]
X = data[["x1", "x2"]].values
y = (data["label"].values.reshape(-1, 1) > 0.5).astype(float)  # Convert label to 0/1

# 2. Normalize the input features
scaler = StandardScaler()
X = scaler.fit_transform(X)

# 3. Activation functions and derivatives
def tanh(x): return np.tanh(x)
def tanh_deriv(x): return 1 - np.tanh(x) ** 2
def sigmoid(x): return 1 / (1 + np.exp(-x))
def sigmoid_deriv(x): return sigmoid(x) * (1 - sigmoid(x))

# 4. Weight initialization
def init_weights(input_dim, hidden1, hidden2, output_dim):
    return {
        "W1": np.random.randn(input_dim, hidden1) * 0.1,
        "b1": np.zeros((1, hidden1)),
        "W2": np.random.randn(hidden1, hidden2) * 0.1,
        "b2": np.zeros((1, hidden2)),
        "W3": np.random.randn(hidden2, output_dim) * 0.1,
        "b3": np.zeros((1, output_dim)),
    }

# 5. Training with Backpropagation
def train_nn(X, y, epochs=2000, lr=0.1, hidden1=16, hidden2=16):
    np.random.seed(42)
    weights = init_weights(X.shape[1], hidden1, hidden2, 1)
    loss_history = []

    for epoch in range(epochs):
        # Forward pass
        z1 = X @ weights["W1"] + weights["b1"]
        a1 = tanh(z1)
        z2 = a1 @ weights["W2"] + weights["b2"]
        a2 = tanh(z2)
        z3 = a2 @ weights["W3"] + weights["b3"]
        y_hat = sigmoid(z3)

        # Compute mean squared error loss
        loss = np.mean((y_hat - y) ** 2)
        loss_history.append(loss)

        # Backpropagation
        delta3 = 2 * (y_hat - y) * sigmoid_deriv(z3)
        dW3 = a2.T @ delta3
        db3 = np.sum(delta3, axis=0, keepdims=True)

        delta2 = delta3 @ weights["W3"].T * tanh_deriv(z2)
        dW2 = a1.T @ delta2
        db2 = np.sum(delta2, axis=0, keepdims=True)

        delta1 = delta2 @ weights["W2"].T * tanh_deriv(z1)
        dW1 = X.T @ delta1
        db1 = np.sum(delta1, axis=0, keepdims=True)

        # Update weights with gradient descent
        weights["W3"] -= lr * dW3
        weights["b3"] -= lr * db3
        weights["W2"] -= lr * dW2
        weights["b2"] -= lr * db2
        weights["W1"] -= lr * dW1
        weights["b1"] -= lr * db1

    return weights, loss_history

# 6. Train the MLP
weights, loss_history = train_nn(X, y)

# 7. Plot training loss curve
plt.plot(loss_history)
plt.xlabel("Epoch")
plt.ylabel("MSE Loss")
plt.title("Training Loss Curve")
plt.grid(True)
plt.show()

# 8. Define forward function for predictions
def forward_pass(X, weights):
    z1 = X @ weights["W1"] + weights["b1"]
    a1 = tanh(z1)
    z2 = a1 @ weights["W2"] + weights["b2"]
    a2 = tanh(z2)
    z3 = a2 @ weights["W3"] + weights["b3"]
    return sigmoid(z3)

# 9. Visualize decision boundary
xx, yy = np.meshgrid(np.linspace(X[:, 0].min()-0.5, X[:, 0].max()+0.5, 300),
                     np.linspace(X[:, 1].min()-0.5, X[:, 1].max()+0.5, 300))
grid = np.c_[xx.ravel(), yy.ravel()]
Z_pred = forward_pass(grid, weights).reshape(xx.shape)

# 10. Plot decision boundary with training data
plt.contourf(xx, yy, Z_pred, levels=[0, 0.5, 1], cmap="coolwarm", alpha=0.6)
plt.scatter(X[:, 0], X[:, 1], c=y.ravel(), cmap="coolwarm", s=10, edgecolor='k')
plt.title("Decision Boundary for Two-Spiral Classification")
plt.xlabel("x1 (normalized)")
plt.ylabel("x2 (normalized)")
plt.axis("equal")
plt.grid(True)
plt.show()
