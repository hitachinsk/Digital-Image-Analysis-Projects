function bestSequence = antCluster(allocatedCustomers, depot, evaporator, maxIter, antNums)
% author: kaidong zkang
% date: 5/30/2020
% Ant cluster algorithm to determine the best sequence to access for 1
% depot and many customers allocated to it.
customerNums = size(allocatedCustomers, 2);
arcNums = (customerNums+1) * customerNums;
pheromonMatrix = zeros(customerNums+1, customerNums+1) + 1/arcNums;
for i=1:size(pheromonMatrix, 1)
    pheromonMatrix(i, i) = 0;
end
for iter=1:maxIter
    iter
    minCost = -1;
    for ant=1:antNums
        accessSequence = pathSelector(pheromonMatrix);
        cost = costMetric(accessSequence, allocatedCustomers, depot);
        if minCost == -1
            minCost = cost;
            bestPath = accessSequence;
        else
            if cost < minCost
                minCost = cost;
                bestPath = accessSequence;
            end
        end
    end
    pheromonMatrix = updatePheromon(pheromonMatrix, evaporator, bestPath);
end
bestSequence = bestSequenceFinder(pheromonMatrix);
end

function selected = pathSelector(pheromonMatrix)
selected = zeros(1, size(pheromonMatrix, 1)-1);
startPoint = 1; % start from depot
for i=1:size(pheromonMatrix, 1)-1
    probs = pheromonMatrix(startPoint, 2:end);
    destination = destSelector(probs, selected);
    selected(1, i) = destination;
    startPoint = destination+1;
end
end

function destination = destSelector(probs, selected)
indices = setdiff(1:size(probs, 2), selected);
candidates = zeros(1, size(indices, 2));
p = rand();
cum = 0;
for i=1:size(indices, 2)
    cum = cum + probs(indices(i));
end
sumcum = 0;
for i=1:size(indices, 2)
    candidates(1, i) = probs(indices(i)) / cum;
    sumcum = sumcum + candidates(1, i);
    k = size(indices);
    if p < sumcum
        destination = indices(i);
        break;
    end
end
end

function cost = costMetric(accessSequence, allocatedCustomers, depot)
cost = 0;
startPoint = depot;
for i=1:size(accessSequence, 2)+1
    if i == size(accessSequence, 2)+1
        endPoint = depot;
    else
        endPoint = allocatedCustomers(accessSequence(1, i));
    end
    cost = cost + (endPoint.xAxis - startPoint.xAxis)^2 + (endPoint.yAxis - startPoint.yAxis)^2;
    startPoint = endPoint;
end
end

function pheromonMatrix = updatePheromon(pheromonMatrix, evaporator, bestPath)
pheromonMatrix = pheromonMatrix * (1 - evaporator);
travelled = 1; % start from depot
gain = evaporator / (size(bestPath, 2)+1);
for i=1:size(bestPath, 2)+1
    if i == size(bestPath, 2)+1
        pheromonMatrix(travelled, 1) = pheromonMatrix(travelled, 1) + gain;
        break;
    else
        pheromonMatrix(travelled, bestPath(i)+1) = pheromonMatrix(travelled, bestPath(i)+1) + gain;
    end
    travelled = bestPath(i)+1;
end
end

function bestSequence = bestSequenceFinder(pheromonMatrix)
bestSequence = zeros(1, size(pheromonMatrix, 1)+1);
travelled = [];
startPoint = 1; % start from depot
for i=2:size(bestSequence, 2)
    destination = findMax(pheromonMatrix(startPoint, :), travelled);
    startPoint = destination;
    travelled = [travelled, startPoint];
    bestSequence(1, i) = destination - 1;
end
end

function maxInd = findMax(array, mask)
indices = setdiff(1:size(array, 2), mask);
maxValue = 0;
maxInd = -1;
for i=1:size(indices, 2)
    if array(1, indices(i)) > maxValue
        maxValue = array(1, indices(i));
        maxInd = indices(i);
    end
end
if maxInd == -1
    error('No positive maxvalue found!');
end
end