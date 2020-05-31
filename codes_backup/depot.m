classdef depot
    %DEPOT is a class compiles the axis, duration and load information in
    %it
    
    properties
        xAxis
        yAxis
        maxDuration
        maxLoad
    end
    
    methods
        function obj = depot(xAxis, yAxis, maxDuration, maxLoad)
            %DEPOT 构造此类的实例
            % (xAxis, yAxis): the axis of this depot in a 2-D space
            % maxDuration: the max duration to access all of customers
            % allocated to it.
            % maxLoad: the maximum load of goods of every vehicles departs from it.
            % the sum of demands of the customers assigned to it should't
            % exceed this amount.
            obj.xAxis = xAxis;
            obj.yAxis = yAxis;
            obj.maxDuration = maxDuration;
            obj.maxLoad = maxLoad;
        end
        
    end
end

