function cost = costCalc(routes, customers, depots)
% author: kaidong zhang
% date: 5/30/2020
% Calculate sum of distance for a set of given routes
cost = 0;
for i=1:size(routes, 2)
    route = routes(1, i).route;
    depot = routes(1, i).depot;
    for j=1:size(route, 2)-1
        if route(1, j) == 0
            startPoint = depots(1, depot);
        else
            startPoint = customers(1, route(1, j));
        end
        if route(1, j+1) == 0
            endPoint = depots(1, depot);
        else
            endPoint = customers(1, route(1, j+1));
        end
        cost = cost + sqrt((startPoint.xAxis - endPoint.xAxis)^2 + (startPoint.yAxis - endPoint.yAxis)^2);
    end
end 
end

