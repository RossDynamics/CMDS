function v_new = qdotp(v,ceqns,position,current,new)
%QDOTP Converts a numeric vector v between velocity and momentum
%coordinates using the conversion equations ceqns. All three sets of
%relevant variables must be provided. Use qdotpsym for symbolic vectors. 
%It is assumed that v has the form [position; current] and that v_new will
%have the form [position; new].

if mod(numel(v),2)==1
    ME = MException('CMDS:invalidVectorSize', ...
        'v must contain an even number of elements.');
    throw(ME);
end

num_position = v(1:numel(v)/2);

num_current = v((numel(v)/2+1):end);

%We obtain a representation of the new vector in the old coordinates
solution = qdotpsym(new,ceqns,new);

num_new = subs(solution,formula([position; current]),...
                        [num_position; num_current]);

v_new = double([num_position; num_new]);

end

