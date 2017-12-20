function rsnaps=ral_getrotsnaps(im,angles,pxsel,trimv,imscale)
% rsnaps=RAL_GETROTSNAPS(IM,ANGLES,PXSEL,TRIMV,IMSCALE)
% Gets matrix of rotated snapshots (IM). Params other than IM can be empty
% or omitted. Returns a 3D matrix of size [imscale,length(angles)] or
% [sum(pxsel(:)),1,length(angles)] if using PXSEL
% ANGLES: angles to rotate over
% PXSEL: logical matrix of values specifying which pixels to use (see RAL_GETIMPARAMS)
% TRIMV: how much to trim from sides of image before rotation (see RAL_GETIMPARAMS)
% IMSCALE: size to resize images to (after rotation)

if size(im,3)==3
    im = rgb2gray(im);
end
if nargin>=4 && ~isempty(trimv)
    im = ral_trimim(im,trimv);
end

doimscale = nargin>=5 && ~isempty(imscale) && ~all(size(imscale)==size(im));
if ~doimscale
    imscale = size(im);
end

if nargin < 2 || isempty(angles)
    angles = 359:-1:0;
else
    angles = mod(-angles,360);
end
mod90 = mod(angles,90);
[umod90,uroti] = unique(mod90);
ursnaps = zeros([imscale,length(uroti)],'int8');
for i = 1:length(uroti)
    if angles(uroti(i))==0
        rim = im;
    else
        rim = imrotate(im,angles(uroti(i)),'crop');
    end
    if doimscale
        ursnaps(:,:,i) = int8(imresize(rim,imscale)/uint8(2));
    else
        ursnaps(:,:,i) = int8(rim/uint8(2));
    end
end

n90 = (angles-mod90)/90;

dopxsel = nargin>=3 && ~isempty(pxsel);
if dopxsel
    rsnaps = zeros(sum(pxsel(:)),1,'int8');
else
    rsnaps = zeros(imscale,'int8');
end
for i = 1:length(angles)
    whsame = mod90(i)==umod90;
    rim = rot90(ursnaps(:,:,whsame),n90(i)-n90(uroti(whsame)));
    if dopxsel
        rsnaps(:,1,i) = rim(pxsel);
    else
        rsnaps(:,:,i) = rim;
    end
end
