function [sols,c] = integ(tspan,y0,c,varargin)
%INTEG Integrates a trajectory with initial condition y0 (expressed as a
%vertical vector) over the two-element tspan provided using (by default)
%the equations, parameters, and settings in the context c. Returns a cell
%array of solution structs sols used directly from the integrators (or just
%a single solution struct if there is only one). If an optional argument (a
%function handle specifying alternate equations of motion) is provided, the
%alternate equations of motion will be used instead of the ones calculated
%from d.eqns (this optional argument may be set to [] to use the default
%calculated equations). If an additional optional argument is provided, it
%will be used as the starting altEqnNums, which determines whether an
%alternate equations of motion or integrator region will be initially in
%effect. If an optional output argument is provided, integ will return a
%potentially edited context object (which is necessary for caching; putting
%the eqnsHandle into the cache *will not* work unless you can obtain the
%new context object).
%
%If equations of motion to be used upon triggering a terminal event have
%been provided through d.alt, integ will automatically switch out the
%equations of motion and resume integrating until the final time is reached
%or until a terminal event without corresponding equations is reached.
%
%Note: If the phase space has been extended, initial conditions must be
%provided in y0 for all of the extra variables.

%altEqnNums represents the set of equation substitution regions we're
%currently in. Triggering a substitution region a second time removes it
%from this list; the region at the end of the list is the one that is used.
%An empty list represents the default equations; 
%positive integers correspond to the alternate event function equations.
if nargin >= 5
    altEqnNums = varargin{2};
else
    altEqnNums = [];
end

if nargin >= 4
    defaultEqnsHandle = varargin{1};
    
    %If we receive something like [], we know to instead get the default
    %handle.
    if isempty(defaultEqnsHandle)
        [defaultEqnsHandle,c] = getFromCache(c,'ca.eqnsHandle',...
                                             @defaultHandle,c);
    end
else
    %integ is only directly responsible for caching the default equations
    %of motion function handles. Custom handles must be cached by the
    %functions that utilize them.
    [defaultEqnsHandle,c] = getFromCache(c,'ca.eqnsHandle',...
                                         @defaultHandle,c);  
end


options = cg(c,'s.i.odeopts');
defaultIntegrator = cg(c,'s.i.integrator');


if isempty(altEqnNums)
    eqnsHandle = defaultEqnsHandle;
    integrator = defaultIntegrator;
else
    altEqnNumStr = int2str(altEqnNums(end));
    
    %altHandle handles the logic for determining whether the alternate
    %equations even exist. If they don't, it just returns [].
    [eqnsHandle,c] = getFromCache(c,['ca.alt.eqns' altEqnNumStr],...
        @(c)altHandle(c,altEqnNumStr),c);
    
    %If an alternate integrator exists, we try to retrieve it as
    %well.
    try
        integrator = cg(c,['d.alt.integ' altEqnNumStr]);
    catch exception
        if strcmp(exception.identifier, 'MATLAB:nonExistentField')
            %If we can't find the integrator, we use the default.
            integrator = defaultIntegrator;
        else
            rethrow(exception)
        end
    end
end

starttime = tspan(1);
endtime = tspan(end);
sols = {};

%We may have to switch between different equations of motion 
while true
    sol = integrator(eqnsHandle,tspan,y0,options);
    sols{end+1} = sol;
    
    %If there's time remaining and there is a corresponding alternate
    %equation, we must switch to the alternate equation
    if (sol.x(end) - starttime) < (endtime - starttime)
        
        %We check to see whether we are already in the event function
        %"region" corresponding to the event that was triggered.
        %Notice that we assume that sol.x(end) could only be less than
        %endtime if integration was interrupted by an event. If there is
        %any other way that this can happen, let me know because it needs
        %to be handled by this code if so.
        if isempty(altEqnNums==sol.ie(end))
            %We add the region's number to the end of the list, making it
            %the current region
            altEqnNums = [altEqnNums sol.ie(end)];
        else
            %Otherwise, we remove the region's number. Notice that this may
            %or may not change the equations of motion; it depends on
            %whether the removed region was at the end of the region list.
            altEqnNums = altEqnNums(altEqnNums~=sol.ie(end));
        end
        
        %If there are no alternate equations regions currently in use, we
        %return to the defaults. Otherwise, we use the alternate equations
        %corresponding to the end of the region list.
        if isempty(altEqnNums)
            eqnsHandle = defaultEqnsHandle;
            integrator = defaultIntegrator;
        else
            altEqnNumStr = int2str(altEqnNums(end));

            %altHandle handles the logic for determining whether the alternate
            %equations even exist. If they don't, it just returns [].
            [eqnsHandle,c] = getFromCache(c,['ca.alt.eqns' altEqnNumStr],...
                             @(c)altHandle(c,altEqnNumStr),c);
                         
            %If an alternate integrator exists, we try to retrieve it as
            %well.
            try
                integrator = cg(c,['d.alt.integ' altEqnNumStr]);
            catch exception
                if strcmp(exception.identifier, 'MATLAB:nonExistentField')
                    %If we can't find the integrator, we use the default.
                    integrator = defaultIntegrator;
                else
                    rethrow(exception)
                end
            end
            

            if isempty(eqnsHandle) && isequal(integrator,defaultIntegrator)
                %If there were alternate equations of motion, altHandle has
                %put them into an integrable function handle form (if
                %necessary) and so we define tspan and y0 by picking up
                %from where we left off. If there was an alternate
                %integrator, we may not even need equations of motion (the
                %integrator might be a single-purpose function) and so we
                %may try to proceed without getting equations of motion. If
                %there are no alternate equations or integrators
                %corresponding to this number, then we assume that the
                %event was intended to stop integration entirely.
                break;
            end
                
        end
        %Assuming that integration hasn't ended, we prepare for the next
        %integration sequence by setting the new tspan and y0.
        tspan = [sol.x(end) endtime];
        y0 = sol.y(:,end);
       
    else
        %If we have reached the end of the integration period, we stop.
        break;
    end
end

if numel(sols) == 1
    sols = sols{1};
end
end