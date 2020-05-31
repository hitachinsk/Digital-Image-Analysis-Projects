function allocation = immuneAllocator(depots, customers, vehicleNum, iterations, variationProb, topSelection, cloneNum)
% author: kaidong zhang
% date: 5/29/2020
% This function assigns all of customers to the according depots based on
% minimum of sum distance from depots to customers allocated to it with
% immune algorithm.
antiNums = 1000;
antiBody = ceil(rand(antiNums, size(customers, 2)) * size(depots, 2));
for iter=1:iterations
    iter
    affinity = affinityMetric(antiBody, customers, depots, vehicleNum);
    validAntyBodyIdx = immuneSelection(affinity, topSelection);
    validAntyBody = matrixCombinator(antiBody, validAntyBodyIdx);
    copiedAntyBody = copyAntyBody(validAntyBody, cloneNum);
    copiedAntyBody = variation(copiedAntyBody, variationProb);
    copiedAntyBody = unique(copiedAntyBody, "rows");
    copyAffinity = affinityMetric(copiedAntyBody, customers, depots, vehicleNum);
    copiedAntyBodyIdx = immuneSelection(copyAffinity, topSelection);
    copiedAntyBody = matrixCombinator(copiedAntyBody, copiedAntyBodyIdx);
    antiBody = [validAntyBody; copiedAntyBody];
end
affinity = affinityMetric(antiBody, customers, depots, vehicleNum);
[~, term] = max(affinity);
allocation = antiBody(term, :);
end

function affinity = affinityMetric(antiBody, customers, depots, vehicleNum)
% affinity=1/sum(distance_from_antibody_to_depot)
affinity = zeros(size(antiBody, 1), 1);
demandMatrix = demandMetric(antiBody, customers, size(depots, 2));
invalidAntyBody = demandVerification(demandMatrix, depots, vehicleNum);
for i=1:size(invalidAntyBody, 2)
    affinity(invalidAntyBody(1, i), 1) = -1;
end
for i=1:size(affinity, 1)
    if affinity(i, 1) ~= -1
        affinity(i, 1) = affinityCalc(antiBody(i, :), depots, customers);
    end
end
end

function affinityItem = affinityCalc(item, depots, customers)
affinityItem = 0;
for i=1:size(item, 2)
    affinityItem = affinityItem + 1 / sqrt((depots(1, item(1, i)).xAxis - customers(1, i).xAxis)^2 + (depots(1, item(1, i)).yAxis - customers(1, i).yAxis)^2);
end
end

function demandMatrix = demandMetric(antiBody, customers, depotNum)
demandMatrix = zeros(size(antiBody, 1), depotNum);
for i=1:size(antiBody, 1)
    for j=1:size(antiBody, 2)
        demandMatrix(i, antiBody(i, j)) = demandMatrix(i, antiBody(i, j)) + customers(1, j).demand;
    end
end
end

function invalidAntyBody = demandVerification(demandMatrix, depots, vehicleNum)
invalidAntyBody = [];
for i=1:size(demandMatrix, 1)
    for j=1:size(demandMatrix, 2)
        if demandMatrix(i, j) > depots(1, j).maxLoad * vehicleNum
            invalidAntyBody = [invalidAntyBody, i];
            break;
        end
    end
end
end

function validIdx = immuneSelection(affinity, topSelection)
[~, validIdx] = sort(affinity, "descend");
splitIdx = ceil(topSelection * size(affinity, 1));
validIdx = validIdx(1:splitIdx, 1);
end

function newMat = matrixCombinator(mat, idx)
newMat = zeros(size(idx, 1), size(mat, 2));
counter = 1;
for i=1:size(idx, 1)
    newMat(counter, :) = mat(idx(i, 1), :);
    counter = counter + 1;
end
end

function copied = copyAntyBody(validAntyBody, cloneNum)
copied = repmat(validAntyBody, cloneNum, 1);
end

function copiedAntyBody = variation(copiedAntyBody, variationProb)
for i=1:size(copiedAntyBody, 1)-1
    for j=i:size(copiedAntyBody, 1)
        p = rand();
        if p <= variationProb
            [copiedAntyBody(i, :), copiedAntyBody(j, :)] = transfer(copiedAntyBody(i, :), copiedAntyBody(j, :));
        end
    end
end
end

function [term1, term2] = transfer(term1, term2)
if size(term1, 2) ~= size(term2, 2)
    error('Not match size between term1 and term2');
end
p = rand();
if p <= 0.5
    intersecPoint = randi([1, size(term1, 2)]);
    temp = term1(1, intersecPoint);
    term1(1, intersecPoint) = term2(1, intersecPoint);
    term2(1, intersecPoint) = temp;
else
    startSecPoint = randi([1, size(term1, 2)-1]);
    endSecPoint = randi([startSecPoint+1, size(term1, 2)]);
    temp = term1(1, startSecPoint:endSecPoint);
    term1(1, startSecPoint:endSecPoint) = term2(1, startSecPoint:endSecPoint);
    term2(1, startSecPoint:endSecPoint) = temp;
end 
end