res = [100 50 20 10 5];
thsep = [0.5 1 2];
nsnap = [1 10 20 50 100 176 1000];

for i = 1:length(res)
    fprintf('Resolution: %dx%d\n',res(i),res(i))
    for j = 1:length(nsnap)
        fprintf('- %d snaps:\n',nsnap(j))
        for k = 1:length(thsep)
            fprintf('-- %gdeg sep: %s\n',thsep(k),fsizestr(snapmemsize(res(i)*[1 1],nsnap(j),360/thsep(k))))
        end
    end
    disp('.')
end
% for i = 1:length(res)
%     for j = 1:length(nsnap)
%     end
% end