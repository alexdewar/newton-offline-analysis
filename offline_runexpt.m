function offline_runexpt(preprocess,trainvid,testvid,weights,imscale,thsep,snapspace,framesep)
% clear

if ~nargin
    preprocess = 'none';
    trainvid = 'vid1';
    testvid = 'vid2';
    weights = 'norm3';
    imscale = 25;
    thsep = 1;
    snapspace = 50;
    framesep = 10;
end

doprogbar = true;

cd(mfiledir)

datadir = 'offline_results';
if ~exist(datadir,'dir')
    mkdir(datadir)
end
[outfn,wstr] = getofflinefn(datadir,preprocess,trainvid,testvid,weights,imscale,snapspace,thsep);
% fprintf('preprocess: %s\ntrainvid: %s\ntestvid: %s\nweights: %s\nres: %d\nthsep: %g\nframesep: %d\n', ...
%         preprocess,trainvid,testvid,wstr,imscale,thsep,framesep);
disp(outfn)
if nargin && exist(outfn,'file')
    fprintf('data file already exists:\n%s\n',outfn)
    return
end

try
    
    if ischar(weights) && weights(1)=='['
        weights = eval(weights);
    end
    
    angles = 0:thsep:360-eps(360);
    
    vdattrain = load(trainvid);
    if isinf(snapspace)
        snappos = 0;
    else
        snappos = 0:snapspace:vdattrain.vdist(end)-snapspace+eps;
    end
    [~,snapis] = min(abs(bsxfun(@minus,snappos,vdattrain.vdist)));
    
    imscale = [imscale imscale];
    [pxsel,trimv] = ral_getimparams(imscale);
    npix = sum(pxsel(:));
    rsnaps = zeros(npix,1,length(angles),length(snapis),'int8');
    if doprogbar
        startprogbar(1,length(snapis),[trainvid ' - getting snaps']);
    end
    for i = 1:length(snapis)
        rsnaps(:,1,:,i) = ral_getrotsnaps(offline_loadframe(snapis(i),vdattrain,preprocess),angles,pxsel,trimv,imscale);
        if doprogbar && progbar
            return
        end
    end
    
    vdattest = load(testvid);
    is = 1:framesep:vdattest.nframes;
    [allweights,imdiffs] = deal(NaN(size(rsnaps,4),length(is)));
    heads = NaN(length(is),1);
    if doprogbar
        startprogbar(10,length(is),[testvid ' - getting headings']);
    end
    for i = 1:length(is)
        im = offline_loadframe(is(i),vdattest,preprocess);
        [heads(i),allweights(:,i),im] = offline_getheading(im,rsnaps,weights,angles,pxsel,trimv,imscale);
        imdiffs(:,i) = shiftdim(sum(sum(bsxfun(@minus,im,rsnaps(:,:,1,:)),1),2),3);
        if doprogbar && progbar
            return
        end
    end
    imdiffs = imdiffs/(npix*128);

    %(preprocess,trainvid,testvid,weights,imscale,thsep,snapspace,framesep)
    params = struct('preprocess',preprocess,'trainvid',trainvid,'testvid',testvid, ...
        'weights',weights,'imscale',imscale(1),'thsep',thsep, ...
        'snapspace',snapspace,'framesep',framesep,'angles',angles,'npix',npix,'snapis',snapis);
    savemeta(outfn,'params','heads','is','allweights','imdiffs');
    
catch ex
    jobid = getenv('JOB_ID');
    if ~isempty(jobid)
        errdir = 'ERROR';
        if ~exist(errdir,'dir')
            mkdir(errdir);
        end
        errfn = sprintf('%s/ERROR_%s_%s.mat',errdir,jobid,getenv('SGE_TASK_ID'));
        save(errfn);
    end
    
    rethrow(ex);
end
