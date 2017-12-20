#!/bin/bash
#$ -j y
#$ -o logs
#$ -N offlinexpt
#$ -q inf.q,inf_amd.q,eng-inf_himem.q,serial.q
#$ -S /bin/bash

#(preprocess,trainvid,testvid,weights,imscale,thsep,snapspace,framesep)
#arena=`awk "NR==$SGE_TASK_ID" ~/rx_gensnaps.txt`
#name=( $(cut -d ' ' -f 3 "./info.txt") )
params=($(awk "NR==$SGE_TASK_ID" ~/offline_results.txt))

#echo $preprocess $trainvid $testvid $weights $imscale $thsep $snapspace $framesep
echo SGE_TASK_ID: $SGE_TASK_ID
echo JOB_ID: $JOB_ID
echo .
echo preprocess: ${params[0]}
echo trainvid: ${params[1]}
echo testvid: ${params[2]}
echo weights: ${params[3]}
echo imscale: ${params[4]}
echo thsep: ${params[5]}
echo snapspace: ${params[6]}
echo framesep: ${params[7]}

module add matlab
matlab -nodisplay -singleCompThread -r "cd ~/offline_analysis;offline_runexpt('${params[0]}','${params[1]}','${params[2]}','${params[3]}',${params[4]},${params[5]},${params[6]},${params[7]});exit"
