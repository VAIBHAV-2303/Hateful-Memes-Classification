#!/bin/bash

#SBATCH	--job-name=mmf
#SBATCH -A irel
#SBATCH -p long
#SBATCH -c 40
#SBATCH -t 04-00:00:00
#SBATCH --gres=gpu:4
#SBATCH --output mmf.log
#SBATCH --ntasks 1

# The script assumes the following at the time of run:
# mmf is installed in user home director in a conda enviromnent.
# Unzipping of the data is already performed by using mmf_convert_hm, which creates the data folder.
# data folder (used by mmf for storing data/features/models/results) is present in zip format in share1 as data.zip.
# The conda environment having mmf installed is activated before submitting the job.

export MMF_CACHE_DIR=/scratch/$USER
export MMF_DATA_DIR=$MMF_CACHE_DIR/data
export MMF_SAVE_DIR=$MMF_CACHE_DIR/save
export SHARE1=$USER@ada:/share1/$USER

echo '--------------------------------------------------------------------'
echo 'Initializing environment by creating cache dir.'
mkdir -p $MMF_CACHE_DIR

echo 'Checking and removing for residual files & folders in cache dir....'
test -f $MMF_CACHE_DIR/data.zip && rm $MMF_CACHE_DIR/data.zip
test -d $MMF_DATA_DIR && rm -r $MMF_DATA_DIR
test -f $MMF_CACHE_DIR/save.zip && rm $MMF_CACHE_DIR/save.zip
test -d $MMF_SAVE_DIR && rm -r $MMF_SAVE_DIR
echo 'Done checking and removing for residual files and folders.'

echo 'Copying data.zip from share 1 to cache ....'
scp $SHARE1/data.zip $MMF_CACHE_DIR
echo 'Copy complete.'
echo 'Copying save.zip from share1 to cache ....'
scp $SHARE1/save.zip $MMF_CACHE_DIR
echo 'Copy complete.'

echo 'Unzipping data.zip into cache ....'
unzip -q $MMF_CACHE_DIR/data.zip -d $MMF_CACHE_DIR/
echo 'Unzip complete.'
echo 'Unzipping save.zip ino cache ....'
unzip -q $MMF_CACHE_DIR/save.zip -d $MMF_CACHE_DIR/
echo 'Unzip complete.'

# The actual mmf code to run goes here.
# Requires the conda environment to be initialized to mmf environment before submitting the batch job.

echo '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
echo 'Running the mmf code using unzipped data folder ....'

#scp $SHARE1/XjiOc5ycDBRRNwbhRlgH.zip $MMF_CACHE_DIR
#mmf_convert_hm --zip_file=$MMF_CACHE_DIR/XjiOc5ycDBRRNwbhRlgH.zip --password=EWryfbZyNviilcDF

#echo 'Evaluating pretrained models'
#echo '********************************************************************'
#echo 'VISUAL_BERT_COCO'
#
#mmf_run \
#config=projects/hateful_memes/configs/visual_bert/from_coco.yaml \
#model=visual_bert \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=visual_bert.finetuned.hateful_memes.from_coco \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'VILBERT_CC'
#
#mmf_run \
#config=projects/hateful_memes/configs/vilbert/from_cc.yaml \
#model=vilbert \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=vilbert.finetuned.hateful_memes.from_cc_original \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
##echo 'VISUAL_BERT_DIRECT'
#
#mmf_run \
#config=projects/hateful_memes/configs/visual_bert/direct.yaml \
#model=visual_bert \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=visual_bert.finetuned.hateful_memes.direct \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'VILBERT_DIRECT'
#
#mmf_run \
#config=projects/hateful_memes/configs/vilbert/defaults.yaml \
#model=vilbert \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=vilbert.finetuned.hateful_memes.direct \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
##echo 'MMBT_FEATURES'
#
#mmf_run \
#config=projects/hateful_memes/configs/mmbt/with_features.yaml \
#model=mmbt \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=mmbt.hateful_memes.features \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'MMBT_DEFAULTS'
#
#mmf_run \
#config=projects/hateful_memes/configs/mmbt/defaults.yaml \
#model=mmbt \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=mmbt.hateful_memes.images \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'CONCAT_BERT'
#
#mmf_run \
#config=projects/hateful_memes/configs/concat_bert/defaults.yaml \
#model=concat_bert \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=concat_bert.hateful_memes \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'LATE_FUSION'
#
#mmf_run \
#config=projects/hateful_memes/configs/late_fusion/defaults.yaml \
#model=late_fusion \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=late_fusion.hateful_memes \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'UNIMODAL_TEXT'
#
#mmf_run \
#config=projects/hateful_memes/configs/unimodal/bert.yaml \
#model=unimodal_text \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=unimodal_text.hateful_memes.bert \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'UNIMODAL_IMAGE_FEATURES'
#
#mmf_run \
#config=projects/hateful_memes/configs/unimodal/with_features.yaml \
#model=unimodal_image \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=unimodal_image.hateful_memes.features \
#checkpoint.resume_pretrained=False
#
#echo '********************************************************************'
#echo 'UNIMODAL_IMAGE_IMAGES'
#
#mmf_run \
#config=projects/hateful_memes/configs/unimodal/image.yaml \
#model=unimodal_image \
#dataset=hateful_memes \
#run_type=val \
#checkpoint.resume_zoo=unimodal_image.hateful_memes.images \
#checkpoint.resume_pretrained=False
#
#echo 'Predicting on pretrained models'
#echo '********************************************************************'
#echo 'VISUAL_BERT_COCO'
#
#mmf_predict \
#config=projects/hateful_memes/configs/visual_bert/from_coco.yaml \
#model=visual_bert \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=visual_bert.finetuned.hateful_memes.from_coco \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'VILBERT_CC'
#
#mmf_predict \
#config=projects/hateful_memes/configs/vilbert/from_cc.yaml \
#model=vilbert \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=vilbert.finetuned.hateful_memes.from_cc_original \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'VISUAL_BERT_DIRECT'
#
#mmf_predict \
#config=projects/hateful_memes/configs/visual_bert/direct.yaml \
#model=visual_bert \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=visual_bert.finetuned.hateful_memes.direct \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'VILBERT_DIRECT'
#
#mmf_predict \
#config=projects/hateful_memes/configs/vilbert/defaults.yaml \
#model=vilbert \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=vilbert.finetuned.hateful_memes.direct \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'MMBT_FEATURES'
#
#mmf_predict \
#config=projects/hateful_memes/configs/mmbt/with_features.yaml \
#model=mmbt \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=mmbt.hateful_memes.features \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'MMBT_DEFAULTS'
#
#mmf_predict \
#config=projects/hateful_memes/configs/mmbt/defaults.yaml \
#model=mmbt \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=mmbt.hateful_memes.images \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'CONCAT_BERT'
#
#mmf_predict \
#config=projects/hateful_memes/configs/concat_bert/defaults.yaml \
#model=concat_bert \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=concat_bert.hateful_memes \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'LATE_FUSION'
#
#mmf_predict \
#config=projects/hateful_memes/configs/late_fusion/defaults.yaml \
#model=late_fusion \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=late_fusion.hateful_memes \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'UNIMODAL_TEXT'
#
#mmf_predict \
#config=projects/hateful_memes/configs/unimodal/bert.yaml \
#model=unimodal_text \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=unimodal_text.hateful_memes.bert \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'UNIMODAL_IMAGE_FEATURES'
#
#mmf_predict \
#config=projects/hateful_memes/configs/unimodal/with_features.yaml \
#model=unimodal_image \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=unimodal_image.hateful_memes.features \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#echo '********************************************************************'
#echo 'UNIMODAL_IMAGE_IMAGES'
#
#mmf_predict \
#config=projects/hateful_memes/configs/unimodal/image.yaml \
#model=unimodal_image \
#dataset=hateful_memes \
#run_type=test \
#checkpoint.resume_zoo=unimodal_image.hateful_memes.images \
#checkpoint.resume_pretrained=False distributed.world_size=4
#
#
#echo '********************************************************************'
#echo 'Training VISUAL_BERT_COCO'
#
#mmf_run \
#config=projects/hateful_memes/configs/visual_bert/from_coco.yaml \
#model=visual_bert \
#dataset=hateful_memes \
#run_type=train_val \
#checkpoint.max_to_keep=3 \
#checkpoint.resume_best=True
#
#echo 'Training VISUAL_BERT_COCO complete'
#echo '********************************************************************'
#echo 'Training VILBERT_CC'
#
#mmf_run \
#config=projects/hateful_memes/configs/vilbert/from_cc.yaml \
#model=vilbert \
#dataset=hateful_memes \
#run_type=train_val \
#checkpoint.max_to_keep=3
#
#echo 'Training VILBERT_CC complete'
#echo '********************************************************************'
#echo 'Training VISUAL_BERT_DIRECT'
#
#mmf_run \
#config=projects/hateful_memes/configs/visual_bert/direct.yaml \
#model=visual_bert \
#dataset=hateful_memes \
#run_type=train_val \
#checkpoint.max_to_keep=3
#
#echo 'Training VISUAL_BERT_DIRECT complete'
#echo '********************************************************************'
#echo 'Training VILBERT_DIRECT'
#
#mf_run \
#config=projects/hateful_memes/configs/vilbert/defaults.yaml \
#model=vilbert \
#dataset=hateful_memes \
#run_type=train_val \
#checkpoint.max_to_keep=3
#
#echo 'Training VILBERT_DIRECT complete'
#echo '********************************************************************'
#echo 'Training MMBT_FEATURES'
#
#mmf_run \
#config=projects/hateful_memes/configs/mmbt/with_features.yaml \
#model=mmbt \
#dataset=hateful_memes \
#run_type=train_val \
#checkpoint.max_to_keep=3
#
#echo 'Training MMBT_FEATURES complete'
#echo '********************************************************************'
#echo 'Training MMBT_DEFAULTS'
#
#mmf_run \
#config=projects/hateful_memes/configs/mmbt/defaults.yaml \
#model=mmbt \
#dataset=hateful_memes \
#run_type=train_val \
#checkpoint.max_to_keep=3
#
##echo 'Training MMBT_DEFAULTS complete'
##echo '********************************************************************'
#
#echo '********************************************************************'
#echo 'Training CONCAT_BERT'
#
#mmf_run \
#config=projects/hateful_memes/configs/concat_bert/defaults.yaml \
#model=concat_bert \
#dataset=hateful_memes \
#run_type=train_val \
#distributed.world_size=4 \
#checkpoint.max_to_keep=2
#
#echo 'Training CONCAT_BERT complete'
#echo '********************************************************************'
#echo 'Training LATE_FUSION'
#
#mmf_run \
#config=projects/hateful_memes/configs/late_fusion/defaults.yaml \
#model=late_fusion \
#dataset=hateful_memes \
#run_type=train_val \
#distributed.world_size=4 \
#checkpoint.max_to_keep=2
#
#echo 'Training LATE_FUSION complete'
#echo '********************************************************************'
#echo 'Training UNIMODAL_TEXT'
#
#mmf_run \
#config=projects/hateful_memes/configs/unimodal/bert.yaml \
#model=unimodal_text \
#dataset=hateful_memes \
#run_type=train_val \
#distributed.world_size=4 \
#checkpoint.max_to_keep=2
#
#echo 'Training UNIMODAL_TEXT complete'
#echo '********************************************************************'
#echo 'Training UNIMODAL_IMAGE_FEATURES'
#
#mmf_run \
#config=projects/hateful_memes/configs/unimodal/with_features.yaml \
#model=unimodal_image \
#dataset=hateful_memes \
#run_type=train_val \
#distributed.world_size=4 \
#checkpoint.max_to_keep=2
#
#echo 'Training UNIMODAL_IMAGE_FEATURES complete'
#echo '********************************************************************'
#echo 'Training UNIMODAL_IMAGE_IMAGES'
#
#mmf_run \
#config=projects/hateful_memes/configs/unimodal/image.yaml \
#model=unimodal_image \
#dataset=hateful_memes \
#run_type=train_val \
#distributed.world_size=4 \
#checkpoint.max_to_keep=2
#
#echo 'Training UNIMODAL_IMAGE_IMAGES complete'
#echo '********************************************************************'
echo 'Run complete.'
echo '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'

echo 'Removing existing data.zip from cache ....'
rm $MMF_CACHE_DIR/data.zip
echo 'Removal complete.'
echo 'Removing existing save.zip from cache ....'
rm $MMF_CACHE_DIR/save.zip
echo 'Removal complete.'

echo 'Zipping processed data folder in cache ....'
cd $MMF_CACHE_DIR && zip -9rq data.zip data && cd -
echo 'Zip complete, data.zip ready in cache.'
echo 'Zipping updated save folder in cache ....'
cd $MMF_CACHE_DIR && zip -9rq save.zip save && cd -
echo 'Zip complete, save.zip ready in cache.'

echo 'Removing existing data.zip from share1'
ssh $USER@ada 'rm /share1/$USER/data.zip'
echo 'Removal complete.'
echo 'Removing existing save.zip from share1'
ssh $USER@ada 'rm /share1/$USER/save.zip'
echo 'Removal complete.'

echo 'Copying data.zip from cache to share1 ....'
scp $MMF_CACHE_DIR/data.zip $SHARE1/
echo 'Copy complete, data.zip ready in share1.'
echo 'Copying save.zip from cache to share1 ....'
scp $MMF_CACHE_DIR/save.zip $SHARE1/
echo 'Copy complete, save.zip ready in share1.'

echo 'Program complete.'
echo '--------------------------------------------------------------------'

