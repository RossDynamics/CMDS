function expr = paramScan(expr,c,varargin)
%PARAMSCAN Attempts to find and substitute in parameters in c.p (where c is
%the active context) that match variable names in expr, where expr is a
%symbolic expression. Ignores dynamically significant variables set via 
%variableNames (specifically, c.d.q, c.d.qdot, c.d.p, and c.d.t). For 
%example, if expr = m*q^2, where q is set via variableNames but m is not,
%PARAMSCAN will attempt to substitute the value at c.p.m in for m. If 
%c.p.m = 2, PARAMSCAN will return 2*q^2. PARAMSCAN raises an error if any
%parameters cannot be found in c.p. If an additional argument containing a
%a list of variables extra_ignore is supplied to PARAMSCAN, 
%PARAMSCAN will also ignore the variables in extra_ignore.

q = cg(c,'d.q');
qdot = cg(c,'d.qdot');
p = cg(c,'d.p');
t = cg(c,'d.t');

qf = formula(q);
qdotf = formula(qdot);
pf = formula(p);

ignore = [qf; qdotf; pf; t];

if nargin > 2
    extra_ignore = cell2sym(varargin(1));
    extra_ignore = reshape(extra_ignore,[numel(extra_ignore),1]);
    ignore = [ignore; extra_ignore];
end

search = setdiff(symvar(expr).',ignore);

%We loop through each variable to search, replacing their appearances in
%expr one by one.
for i = 1:numel(search)
    varName = char(search(i));
    try
        %We attempt to read the matching parameter
        varValue = cg(c, ['p.' varName]);
    catch exception
        if strcmp(exception.identifier, 'MATLAB:nonExistentField')
            ME = MException('CMDS:nonExistentParameter', ...
                  ['The parameter p.' varName ' does not exist in the '...
                   'current context.']);
            throw(ME);
        else
            rethrow(exception)
        end    
    end
    
    %We use the 'd' conversion mode so that sym won't overzealously 'snap'
    %the value of the parameter to something mathematically nice like pi
    expr = subs(expr,search(i),sym(varValue,'d'));
    
end



end

