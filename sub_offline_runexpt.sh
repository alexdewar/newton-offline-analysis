#!/bin/bash

nsub=0
framesep=10
datadir=~/offline_analysis/offline_results
subfile=~/offline_results.txt

framesep=10

if [ -f $subfile ];then
	rm $subfile
fi

#(preprocess,trainvid,testvid,weights,imscale,thsep,snapspace,framesep)

for preprocess in none histeq
do

for trainvid in vid1 vid2
do

for testvid in vid1 vid2
do

for weights in wta '[1,0.75,0.25]' norm norm3
do

for imscale in 5 10 25 50 100
do

for thsep in 1 2
do

for snapspace in Inf 50 25 10 5 2 1
do

#echo $preprocess $trainvid $weights $imscale $thsep
#'%s/results_pre=%s_train=%s_test=%s_weights=%s_res=%d_thsep=%g.mat', datadir,preprocess,trainvid,testvid,wstr,res,thsep);
fn=$datadir/results_pre=${preprocess}_train=${trainvid}_test=${testvid}_weights=${weights}_res=${imscale}_thsep=${thsep}_snapspace=${snapspace}.mat
echo $fn
if [ ! -f $fn ]; then
	echo $preprocess $trainvid $testvid $weights $imscale $thsep $snapspace $framesep >> $subfile
	(( nsub++ ))
else
	echo SKIPPING
fi

done
done
done
done
done
done
done

module add sge
qsub -t 1-$nsub ~/offline_analysis/offline_runexpt.sh
echo $nsub jobs submitted.

