import numpy as np

# Homework1 - (1) - Matrix A and B
A = np.array([[1, 0, 1],
              [1, 2, 3]])

B = np.array([[1, 2],
              [3, 6],
              [7, 8]])

AB = np.dot(A, B)
print("Matrix AB:\n", AB)

BA = np.dot(B, A)
print("Matrix BA:\n", BA)