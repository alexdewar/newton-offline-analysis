function makeviddat(vname,startt,name,vidfn)
dat = mmread(vidfn,1);
framerate = dat.rate;
startfr = 1+round(framerate*startt);

load(['../' name '_gpsdata.mat'])
[gpsdat.x,gpsdat.y,utmzone] = wgs2utm(gpsdat.latitude,gpsdat.longitude);
gpsdat.utmzone = unique(utmzone);

nframes = 1+floor(gpsdat.time(end)*framerate);
[vx,vy] = deal(NaN(nframes,1));
vtime = framerate\(0:nframes-1)';
for i = 1:nframes
    ilo = find(vtime(i)>=gpsdat.time,1,'last');
%     vth(i) = gps_bearing(gpsdat.latitude(ilo+1),gpsdat.longitude(ilo+1), ...
%                          gpsdat.latitude(ilo),gpsdat.longitude(ilo));
                       
    tlo = gpsdat.time(ilo);
    prop = (vtime(i)-tlo)./(gpsdat.time(ilo+1)-tlo);
    
    xlo = gpsdat.x(ilo);
    vx(i) = xlo+prop*(gpsdat.x(ilo+1)-xlo);
    
    ylo = gpsdat.y(ilo);
    vy(i) = ylo+prop*(gpsdat.y(ilo+1)-ylo);
end
vdist = [0;cumsum(hypot(diff(vy),diff(vx)))];
vth = mod(90-atan2d(diff(vy),diff(vx)),360);
vth(end+1) = vth(end);

frdir = fullfile(mfiledir,vname);
outfn = [vname '.mat'];
if exist(outfn,'file')
    error('already exists')
else
    save(outfn,'vname','framerate','startt','startfr','nframes','vidfn','vdist', ...
               'vx','vy','vth','vtime','gpsdat');
end