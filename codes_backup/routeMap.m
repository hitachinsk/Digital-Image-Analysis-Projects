classdef routeMap
    % ROUTEMAP contains the necessary properties assiciated with a route
    % depot: the number of depot this route assigned
    % vehicle: the number of vehicle this route assigned
    % route: an array contains all of indices from customers that indicates
    % the sequence for a given vehicle from a depot to access, the head and
    % tail of this array are both 0, which implies the route start and
    % terminate of this route are both the depot assigned to this route.
    % routeRelative: the difference between it and route is the sequence of
    % this array is based on the relative relationship of indices of
    % customers, but not absolute relationship.
    
    properties
        depot
        vehicle
        route
        routeRelative
    end
    
    methods
        function obj = routeMap(depot, vehicle, route, routeRelative)
            % ROUTEMAP
            % depot: number of depot assigned to this route
            % vehicle: number of vehicle assigned to this route
            % route: the sequence of indices of customers to access based
            % on the absolute relashitionship between them
            % routeRelative: the sequence of indices of customers to access
            % based on the relative relaship between them
            obj.depot = depot;
            obj.vehicle = vehicle;
            obj.route = route;
            obj.routeRelative = routeRelative;
        end
        
    end
end

