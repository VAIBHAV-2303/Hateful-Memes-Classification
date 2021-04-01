import pickle
import numpy as np

X = []
a = []
labels = []
with open("./U/U365072_loop/dev_seen.csv") as f:
	for line in f:
		a.append(float(line.strip().split("\t")[0].strip()))
		labels.append(int(line.strip().split("\t")[1].strip()))

X.append(a)
a = []

with open("./V/VLMDB_loop/dev_seen.csv") as f:
	for line in f:
		a.append(float(line.strip().split("\t")[0].strip()))

X.append(a)
a = []

with open("./O/O365050_loop/dev_seen.csv") as f:
	for line in f:
		a.append(float(line.strip().split("\t")[0].strip()))

X.append(a)
a = []

with open("./ES/ES365072_loop/dev_seen.csv") as f:
	for line in f:
		a.append(float(line.strip().split("\t")[0].strip()))

X.append(a)
a = []

with open("./EL/EL365072_loop/dev_seen.csv") as f:
	for line in f:
		a.append(float(line.strip().split("\t")[0].strip()))

X.append(a)
a = []

X = np.array(X)
labels = np.array(labels)

data = {
	"X": X.T,
	"y": labels
}

pickle.dump(data, open("./dev_seen.pkl", "wb"))
