function [S1,S0,c] = volumeMap(t1,S0,c,varargin)
%VOLUMEMAP Maps an n-volume S0 expressed as a set of n-simplices
%(expressed as a three dimensional array) from t = 0 to t = t1,
%obtaining a set of simplices S1. volumeInteg attempts to perform this 
%mapping in a volume-preserving manner; it compares the volumes of S0 and
%S1 and, if necessary, subdivides S0 until the difference between the
%volumes of S0's simplices and S1's simplices is within the tolerance
%provided at c.s.i.ap.volTol. It is the responsibility of the end user to
%verify that area preservation does hold in the current context (in both
%senses of the word).
%
%Will provide some information on progress if c.s.o.c.isTalkative is true.
%
%Returns, depending on the number of output arguments, S1, the subdivided
%S0, and the potentially edited context object c (for caching purposes).
%If an optional argument is provided, it will be passed to integ's optional
%arguments.
%
%Like STM, VOLUMEMAP cannot yet handle event functions.

wasCaching = isCaching(c);

c = startCaching(c);

volTol = cg(c,'s.i.ap.volTol');
isTalkative = cg(c,'s.o.c.isTalkative');

S0remain = S0;
S0 = [];
S1 = [];

%We integrate until volumes are adequately preserved
while true
    if isTalkative
        disp(['Beginning new iteration with ' int2str(size(S0remain,3))...
              ' simplices...'])
    end
    %To speed up integration, we only integrate each point once (since
    %simplices may share vertices).
    flatS0remain = reshape(S0remain,[size(S0remain,1) size(S0remain,2)*...
                           size(S0remain,3)]);

    %We will recreate the simplex array structure after integration.
    [uniqueS0remain,~,ic]=unique(flatS0remain.','rows');
    
    if isTalkative
        disp(['Integrating ' int2str(size(uniqueS0remain,1))...
              ' unique points.'])
    end
    
    uniqueS0remain = uniqueS0remain.';
    
    uniqueS1 = zeros(size(uniqueS0remain));
   
   
    %We have to initialize the cache separately.
    [sol,c] = integ([0 t1],uniqueS0remain(:,1),c,varargin{:});
    uniqueS1(:,1) = sol.y(:,end);
    
    %We integrate
    parfor i = 2:size(uniqueS1,2)
        [sol,~] = integ([0 t1],uniqueS0remain(:,i),c,varargin{:});
        uniqueS1(:,i) = sol.y(:,end);
    end
    
    %We recreate the simplex array structure
    flatS1 = uniqueS1(:,ic);
    S1temp = reshape(flatS1,size(S0remain));
    
    %We find the difference between the two volumes
    volDiff = abs(simplexVolume(S1temp) - simplexVolume(S0remain));
    
    volBad = volDiff > volTol;
    
%     hold off
%     cplot(flatS0remain,c,'.')
%     hold on
%     cplot(flatS1,c,'.')
%     axis equal
%     drawnow
    
    S0 = cat(3,S0,S0remain(:,:,~volBad));
    S1 = cat(3,S1,S1temp(:,:,~volBad));
    
    %If all volumes are below the tolerance, we stop integrating
    if ~any(volBad)
        break;
    end
    
    S0remain = S0remain(:,:,volBad);
    
    if isTalkative
        disp(['There are ' int2str(size(S0remain,3)) ...
          ' simplices remaining with unacceptable tolerances.'])
        fprintf('The maximum difference is %4.4e.\n',max(volDiff));
    end
      
      
    %Otherwise, we subdivide the errant simplices in S0remain by deleting 
    %the original simplexes and adding the subdivided simplexes to the end
    %of S0remain.
    k = 2;
    d = size(S0remain,1);
    
    S0remainnew = zeros([size(S0remain,1:3) k^d]);
    parfor i = 1:size(S0remain,3)
        
        S0remainnew(:,:,i,:) = subdiv_simplices(S0remain(:,:,i),k);
    end
    
    S0remain = reshape(S0remainnew,size(S0remain,1:3).*[1 1 k^d]);
    
    if isTalkative
        disp('----------------');
    end
end

%We turn off caching if it was originally off
if ~wasCaching
    c = stopCaching(c);
end

end

