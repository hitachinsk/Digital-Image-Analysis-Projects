classdef customer
    %CUSTOMER is a class compiles id, axis infomation, duration and demand
    %in it, it describes the basic properties of a customer.
    
    properties
        id
        xAxis
        yAxis
        serviceDuration
        demand
    end
    
    methods
        function obj = customer(id, xAxis, yAxis, serviceDuration, demand)
            %CUSTOMER 构造此类的实例
            %   此处显示详细说明
            obj.id = id;
            obj.xAxis = xAxis;
            obj.yAxis = yAxis;
            obj.serviceDuration = serviceDuration;
            obj.demand = demand;
        end
        
    end
end

