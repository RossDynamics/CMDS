function p = cplot(y,c,varargin)
%cplot A visualizer for a set of (vertical) vectors y. CPLOT has a couple
%of different dimension modes; change these modes by setting c.d.o.v.dmode:
%If c.d.o.v.dmode = 'position' (the default case), cplot will 
%prioritize showing position space. Specifically: 
%-If c.d.n = 2, cplot
%will show the trajectory with initial condition y0 and t 
%values tspan in the full phase space. 
%-If c.d.n = 4, cplot will show
%the 2D position space projection of the same trajectory. 
%-If c.d.n >= 6,
%cplot will show a 3D plot of the first three dimensions of position
%space.
%If c.d.o.v.dmode = 'velocity', cplot will 
%prioritize showing velocity space. Specifically: 
%-If c.d.n = 2, cplot
%will show the trajectory with initial condition y0 and t 
%values tspan in the full phase space (the same behavior as in the
%'position' mode). 
%-If c.d.n = 4, cplot will show
%the 2D velocity space projection of the same trajectory. 
%-If c.d.n >= 6,
%cplot will show a 3D plot of the first three dimensions of velocity
%space.
%If c.d.o.v.dmode = 'i' for some integer i, cplot will 
%prioritize showing the ith position and ith velocity/momentum
%coordinates. Specifically: 
%-If c.d.n = 2, cplot
%will show the trajectory with initial condition y0 and t 
%values tspan in the full phase space (the same behavior as in the
%'position' mode). 
%-If c.d.n >= 4, cplot will show
%the 2D q_i - qdot_i/p_i space projection of the same trajectory. 
%cplot accepts an optional lineSpec argument; if it is provided, cplot will
%pass it to the plotter function in use.

if nargin >= 3
    lineSpec = varargin{1};
else
    lineSpec = '';
end

n = cg(c,'d.n');
dmode = lower(cg(c,'s.o.v.dmode'));

if strcmp(dmode,'position')
    if n <= 4
        p = plot(y(1,:),y(2,:),lineSpec);
    elseif n >= 6
        p = plot3(y(1,:),y(2,:),y(3,:),lineSpec);
    end
elseif strcmp(dmode,'velocity')
    if n == 2
        p = plot(y(1,:),y(2,:),lineSpec);
    elseif n == 4
        p = plot(y(3,:),y(4,:),lineSpec);
    elseif n >= 6
        p = plot3(y(n/2+1,:),y(n/2+2,:),y(n/2+3,:),lineSpec);
    end 
elseif ~isnan(str2double(dmode))
    inum = str2double(dmode);
    if n == 2
        p = plot(y(1,:),y(2,:),lineSpec);
    elseif n >= 4
        p = plot(y(inum,:),y(n/2+inum,:),lineSpec);
    end
else
    ME = MException('CMDS:invaliddmode', ...
        'The dimension mode dmode provided is not valid.');
    throw(ME);
end

end

