function offline_vids2mat(vnames)

if nargin < 1
    vnames = { 'vid1', 'vid2' };
elseif ~iscell(vnames)
    vnames = {vnames};
end

imsz = [1440 1440];
vmemsz = 1e9;
progbaron = true;

frtoload = floor(vmemsz/(prod(imsz)*3));
for i = 1:length(vnames)
    vdir = sprintf('%s/%s_none',mfiledir,vnames{i});
    if ~exist(vdir,'dir')
        mkdir(vdir)
    end
    
    load(vnames{i})
    if ~exist(vidfn,'file')
        [~,fn,ext] = fileparts(vidfn);
        vidfn = fullfile(mfiledir,[fn ext]);
    end
    
    fex = false(nframes,1);
    d = dir(fullfile(vdir,'*_frame*.mat'));
    allfns = {d.name};
    for j = 1:nframes
        fex(j) = any(strcmp(allfns,getfrfn(vnames{i},startfr-1+j)));
    end
    
    toload = find(~fex);
    if ~isempty(toload)
        startis = 1:frtoload:length(toload);
        if length(startis)==1 || startis(end)~=length(toload)
            startis(end+1) = length(toload)+1; %#ok<AGROW>
        end
        if progbaron
            startprogbar(1,length(startis)-1)
        end
        for j = 1:length(startis)-1
            cind = toload(startis(j):startis(j+1)-1);
            cfr = cind+startfr-1;
            disp([cfr(1) cfr(end)])
            dat = mmread(vidfn,cfr);
            fr = dat(end).frames;
            for k = 1:length(cind)
                im = rgb2gray(fr(k).cdata);
                save(fullfile(vdir,getfrfn(vnames{i},cfr(k))),'im');
                if progbaron
                    progbar;
                end
            end
        end
    end
end

function fn=getfrfn(vname,ind)
fn = sprintf('%s_frame%06d.mat',vname,ind);
