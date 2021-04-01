import torch
import pickle
from torch import nn 

train = pickle.load(open("./train.pkl", "rb"))
test = pickle.load(open("./dev_seen.pkl", "rb"))

X_train, y_train = torch.from_numpy(train["X"]), torch.from_numpy(train["y"])
X_test, y_test = torch.from_numpy(test["X"]), torch.from_numpy(test["y"])

print(X_train.shape)


