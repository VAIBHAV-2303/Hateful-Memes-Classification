import torch
import pickle
from torch import nn 
from torch.utils.data import Dataset, DataLoader

device = "cpu"

train = pickle.load(open("./train_loop.pkl", "rb"))
X_train, y_train = torch.from_numpy(train["X"]), torch.from_numpy(train["y"])

class CustomDataset(Dataset):

	def __init__(self, X, y):
		self.X = X.type(torch.float32)
		self.y = y.type(torch.float32)

	def __len__(self):
		return len(self.X)

	def __getitem__(self,  idx):
		sample = {
			"X" : self.X[idx], 
			"y" : self.y[idx] 
		}
		return sample

train_data = CustomDataset(X_train, y_train)
train_iter = DataLoader(train_data, batch_size=len(train_data), shuffle=True)

for _, batch in enumerate(train_iter):
	X, y = batch["X"].to(device), batch["y"].to(device)
	print(X.shape)
	mean = X.mean(dim=0)
	std = X.std(dim=0)
	print(mean.shape, std.shape)

torch.save(mean, "./mean_loop.pt")
torch.save(std, "./std_loop.pt")
