function c = updateContext(c)
%UPDATECONTEXT UPDATECONTEXT attempts to bring outdated context objects in
%line with the current version of CMDS by applying the minimum changes
%necessary to ensure the context object functions properly. This version of
%updateContext is current as of 0.4.0.

try
    %As of 0.3.0, context objects must possess the property c.d.ev.
    c.d.ev;
    disp('c.d.ev found.')
catch exception
    if strcmp(exception.identifier, 'MATLAB:nonExistentField')
        %If the field doesn't exist, great! We make it.
        c.d.ev = Property(sym([]),0);
        disp('Creating c.d.ev.')
    else
        rethrow(exception)
    end    
end

try
    %As of 0.4.0, context objects must possess the property
    %c.s.ac.overrideLegendre.
    c.s.ac.overrideLegendre;
    disp('c.s.ac.overrideLegendre found.')
catch exception
    if strcmp(exception.identifier, 'MATLAB:nonExistentField')
        c.s.ac.overrideLegendre = Property(false,0);
        disp('Creating c.d.overrideLegendre.')
    else
        rethrow(exception)
    end    
end


end

