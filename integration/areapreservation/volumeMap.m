unction [S1,S0new,maxTol,c] = volumeMap(t1,S0,c,varargin)
%VOLUMEMAP Maps an n-volume S0 expressed as a set of n-simplices
%(expressed as a three dimensional array) from t = 0 to t = t1,
%obtaining a set of simplices S1. volumeInteg attempts to perform this 
%mapping in a volume-preserving manner; it compares the volumes of S0 and
%S1 and, if necessary, subdivides S0 until the difference between the
%volumes of S0's simplices and S1's simplices is within the tolerance
%provided at c.s.i.ap.volTol. It is the responsibility of the end user to
%verify that area preservation does hold in the current context (in both
%senses of the word context).
%
%Will provide some information on progress if c.s.o.c.isTalkative is true.
%
%Returns, depending on the number of output arguments, S1, the subdivided
%S0 S0new, the maximum simplex volume tolerance, and the potentially edited
%context object c (for caching).
%If an optional argument, a string pointCacheName, is provided,
%trajectories that are integrated will be stored in the cache
%pointCacheName.
%Any additional optional arguments will be passed to integ's optional
%arguments.
%
%Like STM, VOLUMEMAP cannot yet handle event functions.

if nargin == 3
    pointCacheName = '';
    integArgs = {};
elseif nargin == 4
    pointCacheName = varargin{1};
    integArgs = {};
elseif nargin >= 5
    pointCacheName = varargin{1};
    integArgs = varargin(2:end);
end

wasCaching = isCaching(c);

c = startCaching(c);

volTol = cg(c,'s.i.ap.volTol');
isTalkative = cg(c,'s.o.c.isTalkative');

S0new = [];
S1 = [];

%We integrate until volumes are adequately preserved
while true
    if isTalkative
        disp(['Beginning new iteration with ' int2str(size(S0,3))...
              ' simplices...'])
    end
    %To speed up integration, we only integrate each point once (since
    %simplices may share vertices). We will recreate the simplex structure
    %after integration.
    [S0pts,pts2S] = simplices2points(S0);
    
    if isTalkative
        disp(['Integrating ' int2str(size(S0pts,2))...
              ' unique points.'])
    end
    
    %if ~isempty(pointCacheName)
    %    
    %else
    %    
    %end
    
    S1pts = zeros(size(S0pts));
   
    %We have to initialize the cache separately; the parfor loop does not
    %allow us to edit c and then pass the result to subsequent iterations.
    [sol,c] = integ([0 t1],S0pts(:,1),c,integArgs{:});
    S1pts(:,1) = sol.y(:,end);
    
    %We integrate
    parfor i = 2:size(S1pts,2)
        [sol,~] = integ([0 t1],S0pts(:,i),c,integArgs{:});
        S1pts(:,i) = sol.y(:,end);
    end
    
    %We recreate the simplex array structure
    S1temp = points2simplices(S1pts,pts2S);
    
    %We find the difference between the two volumes
    volDiff = abs(simplexVolume(S1temp) - simplexVolume(S0));
    
    volBad = volDiff > volTol;
    
%     hold off
%     cplot(flatS0remain,c,'.')
%     hold on
%     cplot(flatS1,c,'.')
%     axis equal
%     drawnow
    
    %We add the simplices with acceptable tolerances to S0new and S1
    S0new = cat(3,S0new,S0(:,:,~volBad));
    S1 = cat(3,S1,S1temp(:,:,~volBad));
    
    maxTol = max(volDiff);
    
    fprintf(['The maximum difference between S0 and S1 volumes '...
             'is %4.4e.\n'],maxTol);
    
    %If all volumes are below the tolerance, we stop integrating
    if ~any(volBad)
        if isTalkative
            disp('All simplex tolerances met.')
        end 
        break;
    end
    
    %Otherwise, we keep only the simplices with unacceptable tolerances. 
    S0 = S0(:,:,volBad);
    
    if isTalkative
        disp(['There are ' int2str(size(S0,3)) ...
          ' simplices remaining with unacceptable tolerances.'])
    end
      
      
    %We subdivide the errant simplices by deleting 
    %the original simplexes and adding the subdivided simplexes to the end
    %of S0.
    k = 2;
    S0 = subdiv_simplices(S0,k);
    
    if isTalkative
        disp('----------------');
    end
end

%We turn off caching if it was originally off
if ~wasCaching
    c = stopCaching(c);
end

end

