function [S1,maxTol,c,S0,S0fdint,S0bdint] = iterateSearchMap(fdt,bdt,S0,...
                                                             c,varargin)
%ITERATESEARCHMAP Refines S0, the simplex in which a periodic orbit is 
%presumed to exist. Specifically, ITERATESEARCHMAP maps S0 forward from 
%t = 0 to t = fdt, obtaining S1fd. It then maps S0 backwards from t = 0 to
%t = bdt, obtain S1bd. It intersects the points in S1fd with S0 and those
%in S1bd with S0; by taking the intersection of the resulting two
%simplices, S1 is obtained. Any optional arguments are passed to volumeMap.
%Has multiple optional output arguments, including maxTol (the maximum
%simplex tolerance of any simplex in any volumeMap operation) and the
%context c.

wasCaching = isCaching(c);

c = startCaching(c);

isTalkative = cg(c,'s.o.c.isTalkative');

if isTalkative
   disp('--------------------------------')
   disp('Beginning forward volumeMap...') 
end
[S1fd,~,fdMaxTol,c] = volumeMap(fdt,S0,c,varargin{:});

if isTalkative
    disp('--------------------------------')
   disp('Beginning backward volumeMap...') 
end
[S1bd,~,bdMaxTol,c] = volumeMap(bdt,S0,c,varargin{:});

maxTol = max(fdMaxTol,bdMaxTol);

if isTalkative
    disp('--------------------------------')
   disp('Intersecting points with S0...') 
end

S0fdint = findHitSimplices(S0,simplices2points(S1fd));
S0bdint = findHitSimplices(S0,simplices2points(S1bd));

if isTalkative
    disp('--------------------------------')
    disp('Finding new simplex set...') 
end

%This algorithm is just about the worst possible way of finding the
%intersection between the simplices. Honestly, I need to adopt a vertical
%version of the findtria standard at some point... I suspect it would allow
%for a much quicker approach.
S1 = [];
for i = 1:size(S0fdint,3)
    for j = i:size(S0bdint,3)
        
        %We sort to ensure the comparison succeeds
        fdi = sortrows(S0fdint(:,:,i).').';
        bdj = sortrows(S0bdint(:,:,j).').';
        
        if isequal(fdi,bdj)
            S1 = cat(3,S1,fdi);
        end
    end
end

%We turn off caching if it was originally off
if ~wasCaching
    c = stopCaching(c);
end

end

