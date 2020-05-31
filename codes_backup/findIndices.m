function indices = findIndices(allocation, depotNum, vehicleNum)
% author: kaidong zhang
% date: 5/30/2020
% Find the indices of customers assigned to a given depot and a given
% vehicle
indices = [];
for i=1:size(allocation, 1)
    if allocation(i, 1) == depotNum && allocation(i, 2) == vehicleNum
        indices = [indices, i];
    end
end
end

