#!/bin/sh
#$ -j y
#$ -o logs

module add matlab
matlab -nodisplay -singleCompThread -r "cd ~/offline_analysis;offline_vidsdopreprocess('$1');exit"

