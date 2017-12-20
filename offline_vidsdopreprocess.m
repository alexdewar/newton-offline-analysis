function offline_vidsdopreprocess(vname,preprocess)
if nargin < 2
    preprocess = 'histeq';
end
if nargin < 1
    vname = 'vid1';
end

fprintf('vid: %s\npreprocess: %s\n\n',vname,preprocess)

ppfunc = offline_getpreprocessfunc(preprocess);

cd(mfiledir)
vdir = sprintf('%s_%s',vname,preprocess);
if ~exist(vdir,'dir')
    mkdir(vdir);
end

vdat=load(vname);

d = dir(fullfile(vdir,'*_frame*.mat'));
allfns = {d.name};
fex = false(1,vdat.nframes);
for i = 1:vdat.nframes
    fex(i) = any(strcmp(allfns,getfrfn(vname,vdat.startfr-1+i)));
end

toload = find(~fex);
startprogbar(20,length(toload))
for i = toload
    im = ppfunc(offline_loadframe(i,vdat));
    save(fullfile(vdir,getfrfn(vname,vdat.startfr-1+i)),'im');
    if progbar
        return
    end
end

function fn=getfrfn(vname,ind)
fn = sprintf('%s_frame%06d.mat',vname,ind);
