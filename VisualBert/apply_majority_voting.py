import os
import numpy as np
import pandas as pd

os.chdir("/scratch/akshay.goindani/hateful_memes-hate_detectron/hyperparameter_sweep/majority_voting_models")
# Store all the prediction folders
folders = [i for i in os.listdir("save/preds") if i.startswith("hateful_memes")]
preds = pd.DataFrame()

try:
    for folder in folders:
        pred = [i for i in os.listdir(f"save/preds/{folder}/reports/") if i.endswith(".csv")]
        pred = pd.read_csv(f"save/preds/{folder}/reports/{pred[0]}")
        preds = pd.concat([preds, pred], axis=1)
except:
    pass

# assert len(preds.columns) == 27*3

# Create 
submission = pred
np_df = np.asarray(preds)

for idx, row in enumerate(np_df[:,:]):
    probas = row[1::3]
    labels = row[2::3]

    if sum(labels) > 13:
        submission.loc[idx, 'label']=1
        submission.loc[idx, 'proba']=probas.max()    
    else:
        submission.loc[idx, 'label']=0
        submission.loc[idx, 'proba']=probas.min()

sub = np.asarray(submission)

f = open("./sub.csv", "w")
f.write("id,proba,label\n")
for i in sub:
    f.write(str(int(i[0]))+","+ str(i[1]) + "," + str(int(i[2]))+"\n")
    # print(str(int(i[0]))+","+ str(i[1]) + "," + str(int(i[2])))

f.close()
