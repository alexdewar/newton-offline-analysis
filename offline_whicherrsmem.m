errdir = fullfile(mfiledir,'ERROR');
d = dir(fullfile(errdir,'ERROR*.mat'));

[jobid,memsz] = deal(NaN(length(d),1));
ismem = false(length(d),1);
for i = 1:length(d)
    cfn = d(i).name;
    jobid(i) = str2double(cfn(find(cfn=='_',1,'last')+1:end-4));
    
    dcfn = fullfile(errdir,cfn);
    load(dcfn,'ex','thsep','imscale','snapis')
    memsz(i) = snapmemsize(imscale,length(snapis),360/thsep);
    ismem(i) = strcmp(ex.identifier,'MATLAB:nomem');
end

figure(1);clf
plot(jobid,ismem,'bx')

figure(2);clf
plot(memsz(ismem)/(1024^2));