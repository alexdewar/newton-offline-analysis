function [head,goodness,ridf]=ral_getheading(im,rsnaps,angles,pxsel,trimv,imscale)
% RAL_GETHEADING(im,rsnaps,angles,pxsel,trimv,imscale) Gets a heading for
% image im based on rotated snapshot matrix rsnaps over angles. Other image
% params are for centring (important) and resizing.
if size(im,3)==3
    im = rgb2gray(im);
end

if nargin>=5 && ~isempty(trimv)
    im = ral_trimim(im,trimv);
end
if nargin>=6 && ~isempty(imscale) && ~all(size(imscale)==size(im))
    im = imresize(im,imscale);
end
if nargin>=4 && ~isempty(pxsel)
    im = im(pxsel);
end

im = int8(im/uint8(2));

ridf = shiftdim(sum(sum(abs(bsxfun(@minus,im,rsnaps)),2),1),2);
[goodness,head] = min(ridf);
if nargin>=3 && ~isempty(angles)
    head = angles(head);
end

% figure(2);clf
% plot(angles(:),ridf(:))
% keyboard

if nargout>=2
    goodness = sqrt(goodness/numel(im));
    goodness = goodness/128;
end