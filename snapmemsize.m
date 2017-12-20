function [sz,npix,pxsel,trimv]=snapmemsize(res,nsnap,nth)
if nargin < 3
    nth = 360;
end
if nargin < 2
    nsnap = 1;
end

[pxsel,trimv] = ral_getimparams(res);
npix = sum(pxsel(:));

sz = npix*nth*nsnap;