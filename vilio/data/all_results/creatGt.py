import json

train = {}

with open("/home/akshay/Social_Computing/Hateful-Memes-Classification/vilio/data/dev_seen.jsonl") as f:
	for line in f:
		data = json.loads(line.strip())
		train[data["id"]] = data["label"]

print(len(train))
with open("/home/akshay/Social_Computing/Hateful-Memes-Classification/vilio/data/all_results/EL/EL365072_loop/FIN_dev_seen_EL365072_loop_2.csv") as f:
	data = f.readlines()

f = open("/home/akshay/Social_Computing/Hateful-Memes-Classification/vilio/data/all_results/EL/EL365072_loop/dev_seen.csv", "w")
labels = []
cnt = 0
for line in data[1:]:
	id1 = int(line.strip().split(",")[1])
	prob = line.strip().split(",")[2]
	# print(id1, prob)
	if id1 in train:
		f.write(prob+"\t"+str(train[id1]).strip()+"\n")

f.close()
