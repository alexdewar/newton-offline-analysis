function im=offline_loadframe(fr,vdat,preprocess)
if nargin < 3
    preprocess = 'none';
end

if fr < 1 || fr > vdat.nframes
    error('invalid frame')
end
load(sprintf('%s_%s/%s_frame%06d.mat',vdat.vname,preprocess,vdat.vname,vdat.startfr-1+fr),'im');