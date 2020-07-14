function prop_struct = csconvert(context,value,transformType)
%CGCONVERT Creates a property struct for value in the standard coordinate
%system.

prop_struct = Property(value,transformType);

%If the property is invariant, do not apply any transformations to value!
if transformType == 0
    return;
end

%We do not yet have functions for converting non-numeric types (like
%function handles) other than symbolic expressions
if isa(value,'numeric')

    %We don't convert scalars. Most scalars you should need will be
    %invariant under coordinate transformations, although now I have an
    %horrifying mental image of someone trying to implement a dynamical 
    %system whose qualitative behavior changes with the angle at which the
    %system is viewed.
    if isscalar(value)
       return;
    end

    %Everything else gets converted via the vector/matrix converter rules
    if transformType == 1
        value = new2standard(value,context.ac.basis.value,...
                                      context.ac.origin.value);

        %If the dynamics weren't set up, you'll get an error message.
        if context.ac.useMomentum.value
            %We run the conversion equations through a paramScan first
            ceqns = paramScan(context.d.qdot2p.value,context);
            value = qdotp(value,ceqns,context.d.q.value,...
                          context.d.p.value,context.d.qdot.value);
        end
    elseif transformType == 2
        value = new2standardmat(value,context.ac.basis.value);
    end
    
%This code converts all symbolic expressions, regardless of dimension,
%unless standard coordinates are in use. We explicitly make an exception
%for standard coordinates so that issues will not result when the dynamics
%are being derived.
elseif isa(value,'sym')
    
    if all(context.ac.basis.value == eye(context.d.n.value),'all') && ...
            all(context.ac.origin.value == zeros(context.d.n.value,1))&&...
            context.ac.useMomentum.value == 0
        return;
    end
    
    poscoords = context.d.q.value;
    
    if context.ac.useMomentum.value
        nonposcoords = context.d.p.value;
    else
        nonposcoords = context.d.qdot.value;
    end
    
    coords = [poscoords; nonposcoords];
    value = new2standardsym(value,context.ac.basis.value,...
                            context.ac.origin.value,coords,coords);
                        
    if context.ac.useMomentum.value
        value = qdotpsym(value,context.d.qdot2p.value,context.d.p.value);
    end
end

prop_struct = Property(value,transformType);
    
end

