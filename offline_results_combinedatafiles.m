function offline_results_combinedatafiles

outfn = 'offline_results.mat';
pnames = { 'preprocess', 'trainvid', 'testvid', 'weights', ...
    'imscale', 'thsep', 'snapspace', 'framesep', 'snapis' };
piscell = [true,true,true,true,false,false,false,false,true];
nparams = length(pnames);

cd(mfiledir)

for i = 1:length(pnames)
    if piscell(i)
        up.(pnames{i}) = {};
    else
        up.(pnames{i}) = [];
    end
end

d = dir('offline_results/*.mat');
pspace = NaN(length(d),nparams);
fnames = {d.name}';
[heads,imdiffs,is,allweights] = deal(cell(length(d),1));
for i = 1:length(fnames)
    dat = load(['offline_results/' fnames{i}],'heads','imdiffs','allweights','is','params');
    heads{i} = dat.heads;
    imdiffs{i} = dat.imdiffs;
    is{i} = dat.is;
    allweights{i} = dat.allweights;
    
    for j = 1:length(pnames)
        cp = dat.params.(pnames{j});
        ucp = up.(pnames{j});
        
        if piscell(j)
            cp = dat.params.(pnames{j});
            for k = 1:length(ucp)
                if length(ucp{k})==length(cp) && all(ucp{k}==cp)
                    pspace(i,j) = k;
                    break;
                end
            end
            if isnan(pspace(i,j))
                pspace(i,j) = length(ucp)+1;
                up.(pnames{j}){end+1} = cp;
            end
        else
            whup = ucp==cp;
            if any(whup)
                pspace(i,j) = find(whup);
            else
                up.(pnames{j}) = [ucp; cp];
                pspace(i,j) = length(up.(pnames{j}));
            end
        end
    end
end

fprintf('Saving to %s...\n',outfn)
save(outfn,'heads','imdiffs','is','pspace','fnames','up','pnames','piscell');