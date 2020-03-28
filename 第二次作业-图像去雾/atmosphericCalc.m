function [A, x, y, allAxis] = atmosphericCalc(image, darkPrior, atmosTop)
height = size(image, 1);
width = size(image, 2);
pointsForSelection = ceil(height * width * atmosTop);
pointsHeap = zeros(1, pointsForSelection);
axisHeap = zeros(2, pointsForSelection);
points = 1;
for heightIdx=1:height
    for widthIdx=1:width
        if points < pointsForSelection + 1
            pointsHeap(points) = darkPrior(heightIdx, widthIdx);
            axisHeap(1, points) = heightIdx;
            axisHeap(2, points) = widthIdx;
        else
            if points == pointsForSelection + 1
                [pointsHeap, axisHeap] = buildHeap(pointsHeap, axisHeap);
            end
            if darkPrior(heightIdx, widthIdx) > pointsHeap(1)
                [pointsHeap, axisHeap] = updateHeap(darkPrior(heightIdx, widthIdx), heightIdx, widthIdx, pointsHeap, axisHeap);
            end
        end
        points = points + 1;
    end
end
allAxis = axisHeap;
maxAverageIntensity = 0;
for i=1:pointsForSelection
    averageIntensity = mean(image(axisHeap(1, i), axisHeap(2, i), :));
    if maxAverageIntensity < averageIntensity
        A = averageIntensity;
        maxAverageIntensity = averageIntensity;
        x = axisHeap(1, i);
        y = axisHeap(2, i);
    end
end
end

function [pointsHeap, axisHeap] = buildHeap(pointsHeap, axisHeap)
start = floor(size(pointsHeap, 2) / 2);
for endPoint=start:-1:1
    holder = endPoint;
    while holder < size(pointsHeap, 2)
        parent = holder * 2;
        if parent > size(pointsHeap, 2)
            break;
        end
        if parent+1 < size(pointsHeap, 2) && pointsHeap(1, parent+1) < pointsHeap(1, parent)
            parent = parent + 1;
        end
        if pointsHeap(1, holder) > pointsHeap(1, parent)
            [pointsHeap, axisHeap] = swap(pointsHeap, axisHeap, holder, parent);
        end
        holder = parent;
    end
end
end

function [pointsHeap, axisHeap] = updateHeap(newElem, heightIdx, widthIdx, pointsHeap, axisHeap)
pointsHeap(1) = newElem;
axisHeap(1, 1) = heightIdx;
axisHeap(2, 1) = widthIdx;
child = 1;
while child < size(pointsHeap, 2)
    father = 2 * child;
    if father > size(pointsHeap, 2)
        break;
    end
    if father+1 < size(pointsHeap, 2) && pointsHeap(1, father) > pointsHeap(1, father+1)
        father = father + 1;
    end
    if pointsHeap(1, child) > pointsHeap(1, father)
        [pointsHeap, axisHeap] = swap(pointsHeap, axisHeap, child, father);
    end
    child = father;
end
end

function [pointsHeap, axisHeap] = swap(pointsHeap, axisHeap, i, j)
temp = pointsHeap(1, i);
pointsHeap(1, i) = pointsHeap(1, j);
pointsHeap(1, j) = temp;
temp = axisHeap(:, i);
axisHeap(:, i) = axisHeap(:, j);
axisHeap(:, j) = temp;
end
