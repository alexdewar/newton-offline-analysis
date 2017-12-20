res = [100 50 20 10 5];
nsnap = [1 10 20 50 100 176];
thsep = 1;
ncomp = 1;
imsz = 1024;
memlim = 1*1024^3;

tcomp = NaN(length(res),length(nsnap),length(thsep),ncomp);
for i = 1:length(res)
    for j = 1:length(nsnap)
        for k = 1:length(thsep)
            angles = 0:thsep:360-thsep;
            
            fprintf('test: %dpx; %d snaps; %gdeg sep\n',res(i),nsnap(j),thsep(k));
            [memsz,npix,pxsel,trimv] = snapmemsize(res(i)*[1 1],nsnap(j),length(angles));
            fprintf('memsz: %s\n',fsizestr(memsz))
            if memsz > memlim
                warning('skipping: too much memory (%s)',fsizestr(memsz))
            end
            rsnaps = randi(intmax('int8'),npix,1,length(angles),nsnap(j),'int8');
%             disp('got snaps!')
            cview = randi(intmax('uint8'),imsz,'uint8');
            for l = 1:ncomp
                tic
                ral_getheading(cview,rsnaps,angles,pxsel,trimv,res(i)*[1 1]);
                tcomp(i,j,k,l) = toc;
                fprintf('t = %gs\n',tcomp(i,j,k,l))
            end
            if ncomp > 1
                fprintf('mean_t = %g\n.\n',mean(tcomp(i,j,k,:)));
            end
        end
    end
end