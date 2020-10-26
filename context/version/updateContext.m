function c = updateContext(c)
%UPDATECONTEXT UPDATECONTEXT attempts to bring outdated context objects in
%line with the current version of CMDS by applying the minimum changes
%necessary to ensure the context object functions properly. This version of
%updateContext is current as of 0.3.0.

%As of 0.3.0, context objects must possess the property c.d.ev.
c.d.ev = Property(sym([]),0);

end

