function val = circ_meand(alpha,w,dim)
if nargin < 2
    w = ones(size(alpha));
end
if nargin < 3
    dim = 1;
end
val = (180/pi)*circ_mean((pi/180)*alpha,w,dim);