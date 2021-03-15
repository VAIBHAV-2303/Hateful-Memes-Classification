import os
from subprocess import call

os.chdir("/scratch/akshay.goindani/hateful_memes-hate_detectron/hyperparameter_sweep/majority_voting_models")
models = [i for i in os.listdir(".") if i.endswith(".ckpt")]

print(f"[INFO] Getting predictions for {len(models)} models! This might take long..")
for model in models:
    feats_dir = os.path.join("/scratch/akshay.goindani/", "features")
    # Execute the bash script which gets predictions for 'test_unseen' data
    rc = call(f"../../utils/generate_submission.sh {model} {feats_dir}", shell=True)
