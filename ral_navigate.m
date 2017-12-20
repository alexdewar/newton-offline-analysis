% function ral_navigate
clear

ppc = PixProCompass(1,[50 50],'norm',false);
% ppc.rsnaps = randi(intmax('int8'),sum(ppc.npix),1,length(ppc.angles),2,'int8');
newsnapshot(ppc,randppcim(2))
[head,lastim,goodness,ridf]=getheading(ppc,randppcim);