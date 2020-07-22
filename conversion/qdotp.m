function v_new = qdotp(v,ceqns,position,current,new)
%QDOTP Converts a numeric vector or set of vectors v between velocity and
%momentum coordinates using the conversion equations ceqns. All three sets
%of relevant variables must be provided. Use qdotpsym for symbolic vectors. 
%It is assumed that v has the form [position; current] and that v_new will
%have the form [position; new].

vn = size(v,1);

if mod(vn,2)==1
    ME = MException('CMDS:invalidVectorSize', ...
        'v must contain an even number of rows.');
    throw(ME);
end

%We separate the position and the velocity/momentum parts of v.
num_position = v(1:vn/2,:);
num_current = v((vn/2+1):end,:);

%We obtain a representation of the new vector in the old coordinates
solution = qdotpsym(new,ceqns,new);

v_new = zeros(size(v));

%Because v might be a set of vectors, we use a for loop to consider each
%one
for i=1:size(v,2)

    num_new = subs(solution,formula([position; current]),...
                        [num_position(:,i); num_current(:,i)]);
                    
    v_new(:,i) = [num_position(:,i); double(num_new)];
end

end

