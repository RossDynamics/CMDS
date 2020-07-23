function value = cg(context,property,varargin)
%CG Fetches the value of property from context. property should be
%a string. For example, to access context.p.parameter, call 
%cg(context,'p.parameter').
%CG can access property data in two different ways:
% 1. When assumeStruct is true, CG will extract the property value
%from the struct after transforming it according to the information
%in the metadata and in the current context. Be sure in this case that
%property is a property struct with the required metadata.
% 2. When assumeStruct is false, CG will extract the
% raw value without transforming it. This technique allows one to access 
% metadata, raw values, and even raw property structs.

%There are two different ways to call CG. If CG is called with two
%arguments, assumeStruct will be assumed true. If CG is called with three
%arguments, the third argument will be assumeStruct.

%We intentionally do not check whether 
%isprop(context,property) because we want to raise an error 
%if the property does not exist.

%Also note that cg contains no code for handling locks because locks don't
%affect read operations. They just prevent write operations.

if nargin == 2
    assumeStruct = true;
elseif nargin >= 3
    assumeStruct = varargin{1};
end

atproperty = getfield_nested(context,property);

if assumeStruct
   %Case 1 above
   value = cgconvert(context,atproperty);
else
   %Case 2 above
    value = atproperty;
end

end

