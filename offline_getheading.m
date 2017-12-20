function [head,allweights,im]=offline_getheading(im,rsnaps,weights,angles,pxsel,trimv,imscale)
if size(im,3)==3
    im = rgb2gray(im);
end

if nargin>=6 && ~isempty(trimv)
    im = ral_trimim(im,trimv);
end
if nargin>=7 && ~isempty(imscale) && ~all(size(imscale)==size(im))
    im = imresize(im,imscale);
end
if nargin>=5 && ~isempty(pxsel)
    im = im(pxsel);
end
if nargin < 4
    angles = 0:359;
end
if nargin < 3
    weights = 'wta';
elseif ischar(weights)
    if length(weights)>4 && strcmp(weights(1:4),'norm')
        ntoweight = min(size(rsnaps,4),str2double(weights(5:end)));
        weights = 'norm';
    else
        ntoweight = size(rsnaps,4);
    end
else
    ntoweight = min(size(rsnaps,4),length(weights));
end

im = int8(im/uint8(2));

ridf = shiftdim(sum(sum(abs(bsxfun(@minus,im,rsnaps)),2),1),2);
[minridf,ridfI] = min(ridf);
allweights = zeros(size(rsnaps,4),1);
if ischar(weights)
    switch weights
        case 'wta'
            [~,whsn] = min(minridf,[],2);
            head = angles(ridfI(whsn));
            allweights(whsn) = 1;
        case 'norm'
            [goodness,gI] = sort(sqrt(minridf/numel(im))/128);
            w = goodness(1)./goodness(1:ntoweight);
            whsn = gI(1:ntoweight);
            head = mod((180/pi)*circ_mean((pi/180)*angles(ridfI(whsn)),w,2),360);
            allweights(whsn) = w;
        otherwise
            error('invalid weights')
    end
else
    [~,gI] = sort(sqrt(minridf/numel(im))/128);
    whsn = gI(1:ntoweight);
    angI = ridfI(whsn);
    w = weights(1:ntoweight);
    head = mod(circ_meand(angles(angI),w,2),360);
    allweights(whsn) = w;
end
% goodness = 1-goodness;

% figure(2);clf
% plot(angles(:),ridf(:))
% keyboard