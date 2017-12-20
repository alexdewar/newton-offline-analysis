function im=ral_trimim(im,padv)
if padv(1)<0
    im = im(1:end+padv(1),:,:);
else
    im = im(1+padv(1):end,:,:);
end

if padv(2)<0
    im = im(:,1:end+padv(2),:);
else
    im = im(:,1+padv(2):end,:);
end