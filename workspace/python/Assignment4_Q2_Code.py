import numpy as np
import pandas as pd

# === Initialization ===
x = 0.7
d = 0.68
mu = 0.2
steps = 4

W1 = np.array([0.3, -0.3])    # Input to hidden weights
b1 = np.array([0.0, 0.0])     # Hidden layer biases
W2 = np.array([-0.1, 0.1])    # Hidden to output weights
b2 = 0.0                      # Output bias

def relu(z):
    return np.maximum(0, z)

def relu_derivative(z):
    return (z > 0).astype(float)

results = []

for t in range(steps):
    # Forward pass
    z1 = W1 * x + b1
    Z = relu(z1)
    z2 = np.dot(W2, Z) + b2
    y = z2

    # Error and gradients
    delta2 = y - d
    delta1 = relu_derivative(z1) * W2 * delta2

    deltaW2 = mu * delta2 * Z
    deltab2 = mu * delta2
    deltaW1 = mu * delta1 * x
    deltab1 = mu * delta1

    # Store this step
    results.append({
        "t": t,
        "W1/b1": f"{W1.tolist()} / {b1.tolist()}",
        "W2/b2": f"{W2.tolist()} / {round(b2, 5)}",
        "Z": Z.tolist(),
        "y(1)": f"[{round(float(y), 5)}]",
        "δ1": f"[{round(delta1[0], 2)} {round(delta1[1], 2)}]",
        "δ2": f"[{round(float(delta2), 3)}]",
        "ΔW1 / Δb1": f"{deltaW1.tolist()} / {deltab1.tolist()}",
        "ΔW2 / Δb2": f"{deltaW2.tolist()} / {round(float(deltab2), 5)}"
    })

    # Update parameters
    W1 -= deltaW1
    b1 -= deltab1
    W2 -= deltaW2
    b2 -= deltab2

# Format as table
df_training = pd.DataFrame(results)
