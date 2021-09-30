function eqnsHandle = altHandle(c,altEqnNumStr)
%ALTHANDLE A function for retrieving handles for substitutionary equations
%of motion that are supposed to "kick in" after certain events are called.
%altEqnNumStr is a string representation of the number i that corresponds
%to the ith event in the event function and a corresponding set of
%alternate equations.

%We retrieve the equations if possible:

try
    altEqns = cg(c,['d.alt.eqns' altEqnNumStr]);
catch exception
    if strcmp(exception.identifier, 'MATLAB:nonExistentField')
        %If we can't find the equations, we return {}, which signifies that
        %the equations simply don't seem to exist.
        eqnsHandle = {};
        return;
    else
        rethrow(exception)
    end    
end

%Attempting to overwrite altEqns with {} is equivalent to them
%not existing.
if isempty(altEqns)
    return;
end

%If a function handle was stored, we just return it without altering it 
if isa(altEqns,'function_handle')
    eqnsHandle = altEqns;

%If something symbolic was stored, we assume we have to process it
elseif isa(altEqns,'sym')
    eqnsHandle = getEquationsHandle(eqns,c);
end

end

