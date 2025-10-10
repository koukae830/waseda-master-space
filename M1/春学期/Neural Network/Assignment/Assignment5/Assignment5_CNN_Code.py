import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms
from torch.utils.data import DataLoader, random_split

# Data preparation (normalize to [0,1])
transform = transforms.Compose([transforms.ToTensor()])
full_train_dataset = datasets.MNIST(root='./data', train=True, download=True, transform=transform)
test_dataset = datasets.MNIST(root='./data', train=False, download=True, transform=transform)
train_dataset, val_dataset = random_split(full_train_dataset, [50000, 10000])
train_loader = DataLoader(train_dataset, batch_size=64, shuffle=True)
val_loader = DataLoader(val_dataset, batch_size=64)
test_loader = DataLoader(test_dataset, batch_size=64)

# ======= 1. Baseline CNN Model =======
class BaselineCNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv_stack = nn.Sequential(
            nn.Conv2d(1, 32, 3),   # (32,26,26)
            nn.ReLU(),
            nn.MaxPool2d(2),       # (32,13,13)
            nn.Conv2d(32, 64, 3),  # (64,11,11)
            nn.ReLU(),
            nn.MaxPool2d(2)        # (64,5,5)
        )
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(64*5*5, 128),
            nn.ReLU(),
            nn.Linear(128, 10)
        )
    def forward(self, x):
        x = self.conv_stack(x)
        return self.classifier(x)

# ======= 2. Improved CNN (BatchNorm + Dropout) =======
class ImprovedCNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv_stack = nn.Sequential(
            nn.Conv2d(1, 32, 3),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, 3),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(2)
        )
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(64*5*5, 128),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(128, 10)
        )
    def forward(self, x):
        x = self.conv_stack(x)
        return self.classifier(x)

# Utility: accuracy evaluation
def evaluate_accuracy(model, loader, device):
    model.eval()
    correct, total = 0, 0
    with torch.no_grad():
        for images, labels in loader:
            images, labels = images.to(device), labels.to(device)
            outputs = model(images)
            _, predicted = torch.max(outputs, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
    return correct / total

# Training function for both models
def train_model(model, train_loader, val_loader, device, epochs=10, lr=0.001, tag=''):
    loss_fn = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=lr)
    train_accs, val_accs = [], []
    for epoch in range(epochs):
        model.train()
        for images, labels in train_loader:
            images, labels = images.to(device), labels.to(device)
            outputs = model(images)
            loss = loss_fn(outputs, labels)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
        train_acc = evaluate_accuracy(model, train_loader, device)
        val_acc = evaluate_accuracy(model, val_loader, device)
        train_accs.append(train_acc)
        val_accs.append(val_acc)
        print(f"{tag} Epoch {epoch+1}: Train Acc={train_acc:.4f}, Val Acc={val_acc:.4f}")
    return train_accs, val_accs

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# ----- Baseline CNN -----
print("=== Baseline CNN ===")
baseline_cnn = BaselineCNN().to(device)
baseline_train_accs, baseline_val_accs = train_model(
    baseline_cnn, train_loader, val_loader, device, epochs=10, tag='Baseline')

# ----- Improved CNN -----
print("\n=== Improved CNN (BatchNorm + Dropout) ===")
improved_cnn = ImprovedCNN().to(device)
improved_train_accs, improved_val_accs = train_model(
    improved_cnn, train_loader, val_loader, device, epochs=10, tag='Improved')

# Evaluate both models on the test set
baseline_test_acc = evaluate_accuracy(baseline_cnn, test_loader, device)
improved_test_acc = evaluate_accuracy(improved_cnn, test_loader, device)
print(f"\nBaseline CNN Test Accuracy: {baseline_test_acc:.4f}")
print(f"Improved CNN Test Accuracy: {improved_test_acc:.4f}")
