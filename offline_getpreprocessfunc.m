function f=offline_getpreprocessfunc(preprocess)
switch preprocess
    case 'none'
        f=@deal;
    case 'histeq'
        f=@histeq;
    otherwise
        error('invalid preprocess type');
end