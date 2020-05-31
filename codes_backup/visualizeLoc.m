function visualizeLoc(depots, customers, auxiliary, auxRoute)
% author: kaidong zhang
% date: 5/30/2020
% Visualize locations of depots, customers, the assignment relation between
% depots and customers and all of the routes which indecates the access
% sequence from every depot to every customer.
if nargin == 2
    hold on;
    for i=1:size(depots, 2)
        scatter(depots(i).xAxis, depots(i).yAxis, 'dr');
    end
    for i=1:size(customers, 2)
        scatter(customers(i).xAxis, customers(i).yAxis, 'b');
    end
    grid;
    hold off;
elseif nargin == 3
    depotsAxis = zeros(2, size(depots, 2));
    for i=1:size(depots, 2)
        depotsAxis(1, i) = depots(i).xAxis;
        depotsAxis(2, i) = depots(i).yAxis;
    end
    linkMatrix = zeros(size(depots, 2), size(depots, 2));
    depotLabel = cell(1, size(depots, 2));
    for i=1:size(depotLabel, 2)
        depotLabel(1, i) = {strcat('{d', num2str(i), '}')};
    end
    depotMap = digraph(linkMatrix);
    p = plot(depotMap, 'XData', depotsAxis(1, :), 'YData', depotsAxis(2, :), 'NodeLabel', depotLabel);
    p.Marker = 's';
    p.MarkerSize = 14;
    hold on;
    maxGroups = max(auxiliary);
    names = cell(1, 1+maxGroups);
    names(1, 1) = {'depot'};
    for i=1:maxGroups
        names(1, 1+i) = {strcat('customer group', num2str(i))};
        indices = find(auxiliary==i);
        customerAxis = zeros(2, size(indices, 2));
        for j=1:size(indices, 2)
            customerAxis(1, j) = customers(indices(1, j)).xAxis;
            customerAxis(2, j) = customers(indices(1, j)).yAxis;
        end
        linkMatrix = zeros(size(indices, 2), size(indices, 2));
        customerLabel = cell(1, size(indices, 2));
        for s=1:size(customerLabel, 2)
            customerLabel(1, s) = {strcat('{', num2str(indices(s)), '}')};
        end
        customerMap = digraph(linkMatrix);
        p = plot(customerMap, 'XData',  customerAxis(1, :), 'YData', customerAxis(2, :), 'NodeLabel', customerLabel);
        p.MarkerSize = 10;
    end
    hold off;
    legend(names);
elseif nargin == 4
    names = cell(1, size(auxRoute, 2));
    hold on;
    for k=1:size(auxRoute, 2)
        routemap = auxRoute(1, k);
        depot = routemap.depot;
        vehicle = routemap.vehicle;
        route = routemap.route;
        nLabel = cell(1, size(route, 2)-1);
        routeRelative = routemap.routeRelative;
        routeRelative = routeRelative + 1;
        linkMatrix = zeros(1+size(route, 2)-2, 1+size(route, 2)-2);
        axisMatrix = zeros(2, size(route, 2)-1); % depots first, customers later
        counter = 1;
        axisMatrix(:, counter) = [depots(1, depot).xAxis; depots(1, depot).yAxis];
        nLabel(1, counter) = {strcat('{d', num2str(depot), '}')};
        counter = counter + 1;
        for i=2:size(route, 2)-1
            axisMatrix(:, counter) = [customers(route(i)).xAxis; customers(route(i)).yAxis];
            nLabel(1, counter) = {strcat('{', num2str(route(i)), '}')};
            counter = counter + 1;
        end
        for i=1:size(route, 2)-1
            startPoint = routeRelative(i);
            endPoint = routeRelative(i+1);
            linkMatrix(startPoint, endPoint) = 1;
        end
        G = digraph(linkMatrix);
        p = plot(G, 'XData',  axisMatrix(1, :), 'YData', axisMatrix(2, :), 'NodeLabel', nLabel);
        p.MarkerSize = 10;
        p.LineStyle = '--';
        names(1, k) = {strcat('d', num2str(depot), ', v', num2str(vehicle))};
    end
    hold off;
    legend(names);
else
    error('Not supported parameter num');
end
end

