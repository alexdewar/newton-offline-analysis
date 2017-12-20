function sz=getfreememory
[status,result] = system('cat /proc/meminfo | grep MemFree');
if status~=0
    error('error getting free memory: status %d; result: %s\n',status,result)
end
szstr = regexp(result,' (?<val>[0-9]+) (?<mag>.?B)','names');
switch szstr.mag
    case 'B'
        mult = 1;
    case 'kB'
        mult = 1024;
    case 'MB'
        mult = 1024^2;
    otherwise
        error('"%s" is unknown unit',szstr.mag)
end
sz = mult*str2double(szstr.val);