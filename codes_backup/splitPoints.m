function vehicleAllocation = splitPoints(indices, customers, vehicleNum, maxLoad)
% author: kaidong zhang
% date: 5/30/2020
% Split all of points assigned to a depot to multiple shares, each of them
% is assigned to a vehicle.
indiceDemandRelation = zeros(size(indices, 2), 2);
indiceDemandRelation(:, 1) = indices';
for i=1:size(indices, 2)
    indiceDemandRelation(i, 2) = customers(1, indices(1, i)).demand;
end
sortedDemands = bubbleSort(indiceDemandRelation);
sortedVehicleAllocation = zeros(size(sortedDemands, 1), 1);
vehicleAllocation = zeros(size(sortedDemands, 1), 1);
volume = zeros(1, vehicleNum);
vehicle = 1;
direction = 1;
for i=1:size(sortedDemands, 1)
    if volume(1, vehicle) + sortedDemands(i, 2) <= maxLoad
        sortedVehicleAllocation(i, 1) = vehicle;
        vehicle = vehicle + direction;
    else
        [value, minInd] = min(volume);
        if value + sortedDemands(i, 2) > maxLoad
            error('Cannot finish splitting operation');
        end
        sortedVehicleAllocation(i, 1) = minInd;
        vehicle = vehicle + direction;
    end
    if vehicle == vehicleNum || vehicle == 1
        direction = direction * (-1);
    end
end
for i=1:size(indices, 2)
    flag = 0;
    for j=1:size(sortedDemands, 1)
        if sortedDemands(j, 1) == indices(1, i)
            ind = j;
            flag = 1;
            break;
        end
    end
    if flag == 0
        error('No indice customer found');
    end
    vehicleAllocation(i, 1) = sortedVehicleAllocation(ind, 1);
end
end

function indiceDemandRelation = bubbleSort(indiceDemandRelation)
for i=1:size(indiceDemandRelation, 1)-1
    flag = 0;
    for j=size(indiceDemandRelation, 1):-1:(i+1)
        if indiceDemandRelation(j, 2) > indiceDemandRelation(j-1, 2)
            temp = indiceDemandRelation(j, :);
            indiceDemandRelation(j, :) = indiceDemandRelation(j-1, :);
            indiceDemandRelation(j-1, :) = temp;
            flag = 1;
        end
    end
    if flag == 0
        break;
    end
end
end

