function [F,c] = integanimate(tspan,y0,c,filename,lineSpec)
%INTEGANIMATE Like integplot, but animates the trajectory. y0 can be an
%array of initial conditions, not just one. Optionally takes a filename (in
%which case the video will be saved), a cell array of lineSpecs.
%May soon support sets of name-value pairs videoArgs that provide properties
%for the videoWriter. Returns the created frames.
%Does not currently support alternate equations of motion, but that feature
%may be added eventually.

arguments
    tspan
    y0
    c
    filename = ''
    lineSpec = {}
    %videoArgs.?VideoWriter
end

%We force a default line spec because otherwise the plot just changes
%color each frame like a crazy person

if isempty(lineSpec)
    [lineSpec{1:size(y0,2)}] = deal('k');
end
    
wasCaching = isCaching(c);

c = startCaching(c);

%We integrate each initial condition and put them all in yall. Make sure
%that every initial condition can be integrated to the end of tspan; events
%that end integration prematurely are not yet supported.
yall = zeros(size(y0,1),numel(tspan),size(y0,2));
for i = 1:size(y0,2)
    [sol,c] = integ(tspan,y0(:,i),c);
    y = deval(sol,tspan);
    yall(:,:,i) = y(:,:);
end

if ~wasCaching
    c = stopCaching(c);
end

%We are told the old hold state to control the hold
wasHeld = ishold;

F(numel(tspan)) = struct('cdata',[],'colormap',[]);

hold on 
for i = 1:numel(tspan)
    for j = 1:size(y0,2)
        cometmkr{j} = cplot(yall(:,i,j),c,'ko');
        cplot(yall(:,1:i,j),c,lineSpec{j});
    end
    drawnow
    F(i) = getframe(gcf);
    for j = 1:size(y0,2)
        delete(cometmkr{j});
    end
end



if ~isempty(filename)
    v = VideoWriter(filename);
    %propertyCell = namedargs2cell(videoArgs);
    %set(v,videoArgs);
    open(v)
    writeVideo(v,F);
    close(v);
end

if ~wasHeld
    hold off
end    

end

