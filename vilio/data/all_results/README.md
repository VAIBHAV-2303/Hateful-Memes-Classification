# Folder Info

This folder contains the results for all the models on train, dev_seen, test_seen and test_unseen datasets. 
The results for each model trained on different feature sets are separately included.
Ensembled results of these predictions using simple averaging and simplex optimization - both are included.
Finally, the final ensembled results of all five models using combinations of simple averaging and simplex optimization are included.

## Structure

### Folders O, U, V, ES, EL
They correspond to outputs of each individual model -
- **O**SCAR
- **U**NITER
- **V**isualBERT
- **E**RNIE-ViL-**S**mall
- **E**RNIE-ViL_**L**arge

Consider folder O for an idea of file structure in folders of this type.  
```
O  
|__O36 ---- Predictions over train, dev_seen, test_seen, test_unseen for model trained using VGATTR3636 feature set.
    |__O36_train.csv  
    |__O36_dev_seen.csv  
    |__O36_test_seen.csv  
    |__O36_test_unseen.csv  
|__O50  ---- Similar files as O36 for predictions over model trained using VGATTR5050 feature set.  
|__OV50  ---- Similar files as O36 for predictions over model trained using VG5050 feature set.  
|__O365050_sa  ---- Simple-averaged probabilities for each output obtained from O36, O50 & OV50 in train, dev_seen, test_seen and test_unseen datasets.  
       |__O365050_sa_train_SA.csv  
       |__O365050_sa_dev_seen_SA.csv  
       |__O365050_sa_test_seen_SA.csv  
       |__O365050_sa_test_unseen_SA.csv  
|__O365050_loop  ---- Predictions for train, dev_seen, test_seen and test_unseen datasets obtained using Simplex Optimization for each output obtained from O35, O50 and OV50.  
       |__FIN_train_O365050_loop_2.csv  
       |__FIN_dev_seen_O365050_loop_2.csv  
       |__FIN_test_seen_O365050_loop_2.csv  
       |__FIN_test_unseen_O365050_loop_2.csv  
```       

A similar structure as above follows for folders U, V, ES and EL folders.
For ES and EL folders, however, the number of models trained over different features is 5 each. So, there are 5 folders 
corresponding to each of them, and 2 separate folders for ensembled outputs of these 5 models using simple averaging and simplex optimization 
(ending with \_sa and \_loop respectively).


### Folder ENS

This contains the final ensembled output over all the 5 model predictions for all 4 datasets.
Each sub-folder under this folder contains 4 files corresponding to predictions over each dataset.  

```
ENS  
 |__ENS_LOOP_LOOP  ---- Predictions using simplex optimization over outputs of models which are ensembled using simplex optimization.
 |__ENS_LOOP_SA  ---- Simple-averaged predictions of outputs of models which are ensembled using simplex optimization.
 |__ENS_SA_LOOP  ----  Predictions using simplex optimization over outputs of models which are simple-averaged for ensembling.
 |__ENS_SA_SA  ----  Simple-averaged predictions of outputs of models which are simple-averaged for ensembling.
 ```
 
 ## Obtaining train predictions ....
 
 - For all models, predictions were obtained on train dataset using bash command as that for obtaining predictions on test_seen / test_unseen.
 - In ensembling, the original code was slightly modified to include ensembling for train dataset using dev as a reference. 
The modified file `ens.py` in included here.
 - A discrepancy was observed w.r.t. # training samples in ES / EL v/s O / U / V. There were 22 samples more in the latter, 
and the order was also slightly different. So, taking simple-averaged output of VisualBERT as a reference, the lacking samples
were simply added to the train files of other ES / EL model predictions.
 - As a sanity check to ensure the probability values match line-by-line, all the predictions of all datasets are sorted 
by image ids in their respective csv files. The code for this as well as for adding extra samples in train predictions is included in 
`sanity_check_pred_samples.ipynb`.
