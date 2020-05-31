clc;
clear;
close all;
%% file information
dir = 'dataset';
file = [dir, '/p05'];
%% read file
[depots, customers, vehicleNum] = readFile(file);
%% visualize distribution of customers and depots
visualizeLoc(depots, customers);
%% immune algorithm to allocate customers to depots
iterations = 100;
variationProb = 0.05;
topSelection = 0.3;
cloneNum = 5;
allocation = immuneAllocator(depots, customers, vehicleNum, iterations, variationProb, topSelection, cloneNum);
%% visualize allocation results
visualizeLoc(depots, customers, allocation);
%% split points inside a depot
allLoc = zeros(size(customers, 2), 2);  % 第一列是分配到哪个depot，第二列是分配到哪辆车
allLoc(:, 1) = allocation';
for i=1:size(depots, 2)
    indices = find(allocation==i);  % indices包含了所有分配到这个depot的customers
    vehicleAllocation = splitPoints(indices, customers, vehicleNum, depots(1, i).maxLoad);
    for j=1:size(indices, 2)
        allLoc(indices(j), 2) = vehicleAllocation(j);
    end
end
%% ant-cluster algorithm
routes = [];
evaporator = 0.01;
maxIter = 800;
antNums = 5;
for i=1:size(depots, 2)
    depot = depots(1, i);
    for j=1:vehicleNum
        allocatedCustomerIndices = findIndices(allLoc, i, j);
        allocatedCustomers = customers(allocatedCustomerIndices);
        route = antCluster(allocatedCustomers, depot, evaporator, maxIter, antNums);
        routeRelative = route;
        for k=2:size(route, 2)-1
            if route(1, k) == 0
                temp = route(1, k);
                route(1, k) = route(1, k+1);
                route(1, k+1) = temp;
            end
            route(1, k) = allocatedCustomerIndices(1, route(1, k));
        end
        routePack = routeMap(i, j, route, routeRelative);
        routes = [routes, routePack];
    end
end
%% visualize route
visualizeLoc(depots, customers, allocation, routes);
%% cost metric
cost = costCalc(routes, customers, depots);
cost