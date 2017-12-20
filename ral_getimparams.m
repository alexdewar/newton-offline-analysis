function [pxsel,trimv]=ral_getimparams(imscale,origimsz)
% RAL_GETIMPARAMS Get image config parameters

load(fullfile(mfiledir,'centrad.mat'))

if nargin < 2 || isempty(origimsz)
    origimsz = imsz;
end
if nargin < 1
    imscale = origimsz;
end

trimv = round(origimsz.*(2.*cent([2 1])-1));

% fn = '100_0007.MP4';
% dat = mmread(fullfile(pwd,fn),1);
% im = rgb2gray(dat.frames.cdata);
% % % im = rgb2gray(imread('webcamsnap.png'));
% pim = ral_trimim(im,trimv);
% [x,y] = pol2cart(linspace(0,2*pi,1000),rad*(max(origimsz)-1));
% figure(1);clf
% imagesc(pim)
% colormap gray
% axis equal
% hold on
% plot(x+size(pim,2)/2-0.5,y+size(pim,1)/2-0.5)
% keyboard

pimsz = origimsz-abs(trimv);
if ~nargin || isempty(imscale)
    imscale = pimsz;
end

[xi,yi] = meshgrid(linspace(1-pimsz(2)/2,pimsz(2)/2,imscale(2)),linspace(1-pimsz(1)/2,pimsz(1)/2,imscale(1)));
pxsel = hypot(xi,yi) <= rad*(max(origimsz)-1);
if ~any(pxsel) % i.e. resized image too small
    pxsel = []; % use all pixels
end

% save('pxmask.mat','pxsel','rad','cent','pimsz','imsz','padv');