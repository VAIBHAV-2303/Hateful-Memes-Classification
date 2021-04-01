import glob
import numpy as np

files = glob.glob("./O/*.csv")
probs = []
labels = []
for file in files:
	with open(file) as f:
		data = f.readlines()

	ids = []
	temp = []
	temp1 = []	
	for line in data[1:]:
		id, proba, label = line.strip().split(",")
		id = int(id)
		ids.append(id)
		proba = float(proba)
		label = int(label)
		temp.append(proba)
		temp1.append(label)

	probs.append(temp)
	labels.append(temp1)		

probs = np.array(probs)
labels = np.array(labels)

probs = probs.mean(axis=0)
print(probs)
print(labels.shape)

