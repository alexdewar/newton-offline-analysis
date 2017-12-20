function examplecode
% takes a snapshot when the function is started, then calculates a heading
% on the basis of current view with GUI

    anglesep = 1;
    imscale = [50 50];

    ppc = PixProCompass(anglesep,imscale);
%     preview(ppc.cam)
%     keyboard
    fprintf('Getting snap...')
    snap = newsnapshot(ppc);
    fprintf('done\n')

    warning('off','images:initSize:adjustingMag')
    figure(1);clf
    imagesc(snap)
    axis equal off
    set(gcf,'CloseRequestFcn',@myclose)
    while ishandle(1)
        tic
        try
            [head,qmatch,lastim] = getheading(ppc);
        catch ex
            delete(ppc)
            rethrow(ex)
            break;
        end
        clf
        imagesc(lastim)
        colormap gray
        axis equal off
        hold on
        vidstr = sprintf('%.2f deg\nqmatch: %f\nfps: %.2f',head,qmatch,1/toc);
        text(10,10,vidstr,'Color','r','HorizontalAlignment','left','VerticalAlignment','top');
    end

    function myclose(~,~)
        delete(ppc);
        closereq;
    end
end