import numpy as np
import matplotlib.pyplot as plt

# Softmax and ReLU functions
def softmax(x):
    exp_x = np.exp(x - np.max(x, axis=1, keepdims=True))
    return exp_x / np.sum(exp_x, axis=1, keepdims=True)

def relu(x):
    return np.maximum(0, x)

# ANN1: 2-input -> 2-output (no hidden layer)
class ANN1:
    def __init__(self):
        self.W = np.random.randn(2, 2)
        self.b = np.zeros((1, 2))

    def predict(self, X):
        return softmax(X @ self.W + self.b)

# ANN2: 2-input -> 8-hidden (no activation) -> 2-output
class ANN2:
    def __init__(self):
        self.W1 = np.random.randn(2, 8)
        self.W2 = np.random.randn(8, 2)
        self.b2 = np.zeros((1, 2))

    def predict(self, X):
        h = X @ self.W1
        return softmax(h @ self.W2 + self.b2)

# ANN3: 2-input -> 8-hidden (ReLU) -> 2-output
class ANN3:
    def __init__(self):
        self.W1 = np.random.randn(2, 8)
        self.b1 = np.zeros((1, 8))
        self.W2 = np.random.randn(8, 2)
        self.b2 = np.zeros((1, 2))

    def predict(self, X):
        h = relu(X @ self.W1 + self.b1)
        return softmax(h @ self.W2 + self.b2)

# plot decision boundary
def plot_decision_boundary(model, title):
    x_min, x_max = -2, 2
    y_min, y_max = -2, 2
    xx, yy = np.meshgrid(np.linspace(x_min, x_max, 300),
                         np.linspace(y_min, y_max, 300))
    grid = np.c_[xx.ravel(), yy.ravel()]
    preds = model.predict(grid)
    Z = np.argmax(preds, axis=1).reshape(xx.shape)

    plt.figure(figsize=(6, 5))
    plt.contourf(xx, yy, Z, cmap='coolwarm', alpha=0.6)
    plt.title(title)
    plt.xlabel("x1")
    plt.ylabel("x2")
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    np.random.seed(0)

    models = [ANN1(), ANN2(), ANN3()]
    titles = [
        "ANN1: 2-input → 2-output (no hidden layer)",
        "ANN2: 2-input → 8-hidden (no activation)",
        "ANN3: 2-input → 8-hidden (ReLU)"
    ]

    for model, title in zip(models, titles):
        plot_decision_boundary(model, title)
