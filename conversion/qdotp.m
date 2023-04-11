function v_new = qdotp(v,ceqns,position,current,new,varargin)
%QDOTP Converts a numeric vector or set of vectors v between velocity and
%momentum coordinates using the conversion equations ceqns. All three sets
%(or four sets, if phase space has been extended) of relevant variables 
%must be provided. Use qdotpsym for symbolic vectors. 
%It is assumed that v has the form [position; current; extended] and that 
%v_new will have the form [position; new; extended] (but if phase space
%space has not been extended, the extended variables will not be present).
%Extended variables are supplied via varargin.

if numel(varargin) >= 1
    extended = varargin{1};
else
    extended = sym([]);
end

vn = size(v,1);

n = size(formula(position),1) + size(formula(current),1);

if vn ~= n + numel(formula(extended))
    ME = MException('CMDS:invalidVectorSize', ...
        'v must have n + numel(extended) elements.');
    throw(ME);
end

%We separate the position, velocity/momentum, and extended parts of v.
num_position = v(1:n/2,:);
num_current = v((n/2+1):n,:);
num_extended = v(n+1:end,:);

%We obtain a representation of the new vector in the old coordinates
solution = qdotpsym(new,ceqns,new);

v_new = zeros(size(v),'like',v);

%Because v might be a set of vectors, we use a for loop to consider each
%one
for i=1:size(v,2)

    num_new = subs(solution,formula([position; current; extended]),...
                 [num_position(:,i); num_current(:,i); num_extended(:,i)]);
                    
    v_new(:,i) = [num_position(:,i); double(num_new); num_extended(:,i)];
end

end

