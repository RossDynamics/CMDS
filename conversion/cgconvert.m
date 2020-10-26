function value = cgconvert(context,property)
%CGCONVERT Converts the value from a property struct property to the form
%required by the current coordinate system. Assumes that property is, in
%fact, a property struct (verify this assumption with cg; don't call this
%function directly) and that the property struct is well-formed.

value = property.value;

%If the property is invariant, do not apply any transformations to value!
if property.transformType == 0
    return;
end

%We do not yet have functions for converting non-numeric types (like
%regular function handles) other than symbolic expressions.
if isa(value,'numeric')

    %We don't convert numeric scalars.
    if isscalar(value)
       return;
    end

    %Everything else gets converted via the vector/matrix converter rules
    if property.transformType == 1
        %If the dynamics weren't set up, you'll get an error message.
        if context.ac.useMomentum.value
            %We run the conversion equations through a paramScan first
            ceqns = paramScan(context.d.qdot2p.value,context);
            value = qdotp(value,ceqns,context.d.q.value,...
                          context.d.qdot.value,context.d.p.value);
        end
        value = standard2new(value,context.ac.basis.value,context.ac.origin.value);

    elseif property.transformType == 2
        value = standard2newmat(value,context.ac.basis.value);
    end

%This code converts all symbolic expressions, regardless of dimension,
%unless the dynamics are unready for conversion.
elseif isa(value,'sym')
    
    try
        qdot2p = cg(context,'d.qdot2p');
    catch exception
        if strcmp(exception.identifier, 'MATLAB:nonExistentField')
            %If qdot2p was never set, do not attempt conversion! The
            %dynamics are probably not defined yet.
            return;
        else
            rethrow(exception)
        end    
    end
    
    poscoords = context.d.q.value;
    extcoords = context.d.ev.value;
    
    if context.ac.useMomentum.value
        value = qdotpsym(value,context.d.qdot2p.value,...
                         context.d.qdot.value);
        nonposcoords = context.d.p.value;
    else
        nonposcoords = context.d.qdot.value;
    end
    
    coords = [poscoords; nonposcoords; extcoords];
    value = standard2newsym(value,context.ac.basis.value,...
                  context.ac.origin.value,formula(coords),formula(coords));

    if all(hasSymType(value,'eq')) && isvector(value)
        value = diffeqnssimplify(value,coords,context.d.t.value);
    end
    
end

end

