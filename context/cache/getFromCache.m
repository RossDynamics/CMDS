function [value,c] = getFromCache(c,property,calculateProperty,varargin)
%GETFROMCACHE If caching is enabled, GETFROMCACHE attempts to retrieve the
%value at property from c's cache. If the property doesn't exist in the
%cache yet or if caching is disabled, GETFROMCACHE will instead recalculate
%it and store it in c using the function handle calculateProperty.
%Any extra arguments will be passed to calculateProperty.

if isCaching(c)
    try
        value = cg(c,property);
        return;
    catch exception
        if strcmp(exception.identifier,'MATLAB:nonExistentField')
            %If the property doesn't exist yet, we just fall through to the
            %logic below.
        else
            rethrow(exception)
        end    
    end
end

%If calculateProperty takes extra output arguments, we assume that the
%second is c.
if abs(nargout(calculateProperty)) == 1
    value = calculateProperty(varargin{:});    
elseif abs(nargout(calculateProperty)) > 1
    [value,c] = calculateProperty(varargin{:});
end

if isCaching(c)
    c = cs(c,property,value);
end

end

