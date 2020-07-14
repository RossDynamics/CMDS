function p = Property(value,transformType)
%PROPERTY Creates and returns a property struct with the provided value and
%default metadata.

p = struct;

p.value = value;

%p.transformType determines how p.value transforms under coordinate
%transformations. p.transformType has a nuanced relationship with
%the true object type:

%If p.transformType = 0, the transform type is 'invariant'.
%converters will not perform any conversion to p.value regardless of
%the actual object type.

%If p.transformType = 1 or 2, the transform type is 'vector' or 'matrix',
%respectively. Converters will use a vector or matrix converter but 
%ONLY if p.value is a numeric array and is not scalar. 
%These values will be ignored for all other object types.

%If this explanation doesn't make enough sense, I'd recommend taking a look
%at the implementations in cgconvert and csconvert.

p.transformType = transformType;

end

