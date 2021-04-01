import pickle
import numpy as np 
from sklearn.neural_network import MLPClassifier as MLP 
from sklearn.metrics import accuracy_score

train = pickle.load(open("./train.pkl", "rb"))
dev = pickle.load(open("./dev_seen.pkl", "rb"))

X_train, y_train = train["X"], train["y"]
mean = X_train.mean(axis=0)
std = X_train.std(axis=0)
X_dev, y_dev = dev["X"], dev["y"]

X_train = (X_train - mean)/std
X_dev = (X_dev - mean)/std

clf = MLP((10), random_state=1, max_iter=20).fit(X_train, y_train)

predicted_labels = np.argmax(clf.predict_proba(X_dev), axis=1)

print(predicted_labels.shape, y_dev.shape)

acc = accuracy_score(y_dev, predicted_labels)
print(100 * acc)
