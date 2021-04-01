import torch
import pickle
import numpy as np
from torch import nn 
from torch.utils.data import Dataset, DataLoader

device = "cpu"
if torch.cuda.is_available():
	device = "cuda"

EPOCHS = 50
BATCH_SIZE = 256

train = pickle.load(open("./train_loop.pkl", "rb"))
test = pickle.load(open("./dev_seen_loop.pkl", "rb"))

X_train, y_train = torch.from_numpy(train["X"]), torch.from_numpy(train["y"])
X_test, y_test = torch.from_numpy(test["X"]), torch.from_numpy(test["y"])

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

class Model(nn.Module):
	def __init__(self, input_size, hidden_size, output_size, dropout):
		super(Model, self).__init__()
		self.fc1 = nn.Linear(input_size, hidden_size)
		self.bn1 = nn.BatchNorm1d(hidden_size)
		self.fc2 = nn.Linear(hidden_size, output_size)
		self.relu = nn.ReLU()
		self.softmax = nn.Softmax(dim=1)
		self.dropout = nn.Dropout(dropout)

	def forward(self, x):
		w = self.relu(self.bn1(self.fc1(x)))
		w = self.softmax(self.fc2(self.dropout(w)))
		out = w*x
		return out.sum(dim=1), w

def calc_correct(y, output):
	predicted_labels = (torch.sigmoid(output) >= 0.5).type(torch.float32)
	return (predicted_labels == y).sum().item()

train_data = CustomDataset(X_train, y_train)
test_data = CustomDataset(X_test, y_test)

train_iter = DataLoader(train_data, batch_size=BATCH_SIZE, shuffle=True)
test_iter = DataLoader(test_data, batch_size=BATCH_SIZE, shuffle=False)

mean = torch.load("./mean_loop.pt").to(device)
std = torch.load("./std_loop.pt").to(device)

def train():
	model.train()
	epoch_loss = 0
	acc = 0
	for _, batch in enumerate(train_iter):
		optimizer.zero_grad()
		X, y = batch["X"].to(device), batch["y"].to(device)
		X = (X - mean)/std
		output, _ = model(X)
		loss = criterion(output, y)
		loss.backward()
		optimizer.step()

		epoch_loss += loss.item()
		acc += calc_correct(y, output)

	acc = 100 * acc / len(train_data)
	return epoch_loss, acc

def test():
	model.eval()
	epoch_loss = 0
	acc = 0
	with torch.no_grad():
		for _, batch in enumerate(test_iter):
			X, y = batch["X"].to(device), batch["y"].to(device)
			X = (X - mean)/std
			output, _ = model(X)
			loss = criterion(output, y)
			epoch_loss += loss.item()
			acc += calc_correct(y, output)

	acc = 100 * acc / len(test_data)
	return epoch_loss, acc

model = Model(5, 20, 5, 0.2).to(device) 
criterion = nn.BCEWithLogitsLoss().to(device)
optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)

bestTestAcc = 0
print("Training Starts")

for i in range(EPOCHS):
	train_loss, train_acc = train()
	test_loss, test_acc = test()

	if test_acc > bestTestAcc:
		bestTestAcc = test_acc
		bestModel = model
		checkpoint = {
			"model" : model.state_dict(),
		}
		torch.save(checkpoint, "./model_loop.pt")

	print("Epoch:", i+1)
	print("Training Loss:", train_loss)
	print("Train Accuracy:", train_acc)	
	print("Test Loss:", test_loss)
	print("Test Accuracy:", test_acc)

	print("*"*40)

test_unseen = pickle.load(open("./test_seen.pkl", "rb"))
test_unseen = np.array(test_unseen, dtype=np.float32)
test_unseen = torch.from_numpy(test_unseen).to(device)

X_test = (test_unseen - mean)/std
out, alpha = bestModel(X_test)
out = torch.sigmoid(out)
labels = (out >= 0.5).type(torch.int32)

# for i in range(len(out)):
# 	print(out[i].item(), labels[i].item())

print(alpha)

