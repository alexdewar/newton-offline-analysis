classdef PixProCompass < handle
%     PIXPROCOMPASS Creates PixProCompass object to use the PixPro as a
%     "visual compass". IMPORTANT: Don't forget to delete the object when
%     you're done, otherwise the connection to the camera will stay open
%     and you'll have to turn it off and on again.
%
%       ppc = PIXPROCOMPASS(ANGLESEP,IMSCALE) connects to the camera over WiFi,
%       and returns an object for using the camera to obtain a heading.
%       ANGLESEP is the gap between the angles used for rotation (e.g.
%       ANGLESEP of 1 gives the range 0:360 degrees). IMSCALE is the size
%       to which you want the images obtained from the camera to be resized
%       to ([] means no resizing).
%
%       ppc = PIXPROCOMPASS(ANGLESEP,IMSCALE,false,ORIGINALIMAGESIZE)
%       allows the class to be run offline without the camera. The extra
%       parameter indicates the size of images, before resizing, that will
%       be input.
%
%       Example:
%           % create object and connect to camera - images to be resized to 50x50px
%           ppc = PixProCompass(1,[50 50]);
%
%           % get new snapshot for the current location, optionally return the image
%           snap = newsnapshot(ppc);
%
%           % get current heading + goodness of match + current view
%           [head,qmatch,lastim] = getheading(ppc);
%
%           % use this image as a new snapshot, if you like
%           newsnapshot(ppc,lastim);
%
%           % close connection to camera, delete object
%           delete(ppc);
    
    properties
        angles
        cam
        imscale
        pxsel
        trimv
        rsnaps
        origimsz
        npix
        weights
    end
    methods
        function obj=PixProCompass(anglesep,imscale,weights,usecamera,origimsz,connectattempts)
            if nargin < 3
                obj.weights = 'wta';
            else
                obj.weights = weights;
            end
            if nargin < 6
                connectattempts = 5;
            end
            if nargin < 4
                usecamera = true;
            end
            if nargin < 5
                origimsz = [1024 1024];
            end
            if nargin < 2
                imscale = [];
            end
            obj.origimsz = origimsz;
            obj.imscale = imscale;
            
            th = 0:anglesep:360-eps(360);
            obj.angles = th;
            
            [obj.pxsel,obj.trimv] = ral_getimparams(imscale,origimsz);
            obj.npix = sum(obj.pxsel(:));
            
            if usecamera
                for i = 1:connectattempts
                    fprintf('Connecting to camera (attempt %d/%d)...\n',i,connectattempts)
                    try
                        obj.cam = ipcam('http://172.16.0.254:9176');
                        obj.cam.Timeout = 30;
                        disp('Connected.')
                        return
                    catch ex
                    end
                end
                rethrow(ex)
            end
        end
        
        function im=mysnapshot(obj)
            while true
                im = snapshot(obj.cam);
                if all([size(im,1),size(im,2)]==obj.origimsz)
                    break;
                else
                    warning('image size should be %dx%d',obj.origimsz(1),obj.origimsz(2))
                end
            end
            im = rgb2gray(im);
        end
        
        function snaps=newsnapshot(obj,snaps)
            if nargin < 2 && ~isempty(obj.cam)
                snaps = mysnapshot(obj);
            elseif ~isempty(obj.origimsz) && ~all([size(snaps,1),size(snaps,2)]==obj.origimsz)
                error('image size should be %dx%d',obj.origimsz(1),obj.origimsz(2))
            end
            obj.rsnaps = zeros(obj.npix,1,length(obj.angles),size(snaps,3),'int8');
            for i = 1:size(snaps,3)
                obj.rsnaps(:,:,:,i) = ral_getrotsnaps(snaps(:,:,i),obj.angles,obj.pxsel,obj.trimv,obj.imscale); %obj.pxsel,obj.padv,obj.imscale
            end
            if ~nargout
                clear snaps
            end
        end
        
        function [head,lastim,goodness,ridf]=getheading(obj,lastim)
            if nargin < 2 && ~isempty(obj.cam)
                lastim = mysnapshot(obj);
            end
            if ~isempty(obj.origimsz) && ~all([size(lastim,1),size(lastim,2)]==obj.origimsz)
                error('image size should be %dx%d',obj.origimsz(1),obj.origimsz(2))
            end
            [head,goodness,ridf] = sd_getheading(lastim,obj.rsnaps,obj.weights,obj.angles,obj.pxsel,obj.trimv,obj.imscale); %obj.pxsel,obj.padv,obj.imscale
        end
        
        function delete(obj)
            if ~isempty(obj.cam)
                delete(obj.cam);
            end
        end
    end
end