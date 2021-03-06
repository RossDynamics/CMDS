function context = cs(context,property,value,varargin)
%CS Writes value to context.property. property should be
%a string. For example, to write 1 to context.p.parameter, call 
%cs(context,'p.parameter',1).
%CS can write property data in two different ways:
% 1. When assumeStruct is true, CS will write the property value
%to a property struct (even if one must be created) after transforming it
%according to the information in the metadata and in the current context. 
%Be sure in this case that property is a property struct with the required
%metadata.
% 2. When assumeStruct is false, CS will write the
% raw value without transforming it. This technique allows one to access 
% metadata (for example).
%There are three different ways to call CS: 
%1. If CS is called with three arguments, current or default values will be
%used for transformType and assumeStruct will be assumed true.
%2. If CS is called with four arguments, the last argument will be 
%transformType and assumeStruct will still be assumed true.
%3. If CS is called with five arguments, the last argument will be
%assumeStruct. Be aware, though, that if assumeStruct is false
%transformType will not be utilized (so you should pass in a dummy
%argument).

if locked(context, property)
    ME = MException('CMDS:locked', ...
        ['The property that you are trying to access is subject to one' ...
        ' or more active locks. Clear relevant locks and try again. '  ...
        'If this property is locked because caching is active, disable'...
        ' caching instead; doing so will clear appropriate locks while'...
        ' ensuring that function handles are recalculated properly. ' ...
        'Inversely, if you are attempting to a set a property in the '...
        'cache, activate caching first.']);
    throw(ME);
end



%If there are exactly three arguments, we must find a value for
%transformType. We first attempt to find a version of the property that
%already exists; if we can find it, we retrieve the existing value of
%transformType. Otherwise, we use the default value, 1.
if nargin == 3
    %We ascertain whether a version of the property already exists so
    %that we can retrieve a default value of transformType.
    try
        existing = getfield_nested(context,property);
        transformType = existing.transformType;
    catch exception
        %If the field doesn't exist in the context, the property doesn't yet 
        %exist either yet. That's ok... it just means we might have to do some
        %things differently.
        if strcmp(exception.identifier, 'MATLAB:nonExistentField')
            %1 is the default value.
            transformType = 1;
        else
            rethrow(exception)
        end    
    end
    assumeStruct = true;

elseif nargin == 4
    transformType = varargin{1};
    assumeStruct = true;
elseif nargin >= 5
    transformType = varargin{1};
    assumeStruct = varargin{2};
end

if assumeStruct
   %Case 1 above
   prop_struct = csconvert(context,value,transformType);
   context = setfield_nested(context,property,prop_struct);
else
   %Case 2 above
   context = setfield_nested(context,property,value);
end

end
