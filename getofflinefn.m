function [outfn,wstr]=getofflinefn(datadir,preprocess,trainvid,testvid,weights,res,thsep,snapspace)
    if ischar(weights)
        wstr = weights;
    else
        wstr = sprintf('[%g',weights(1));
        for i = 2:length(weights)
            wstr = sprintf('%s,%g',wstr,weights(i));
        end
        wstr = [wstr ']'];
    end
    outfn = sprintf('%s/results_pre=%s_train=%s_test=%s_weights=%s_res=%d_thsep=%g_snapspace=%g.mat', ...
                    datadir,preprocess,trainvid,testvid,wstr,res,thsep,snapspace);
end