function iouValue = iou(rect1,rect2)
rect1Set = pointsGen(rect1);
rect2Set = pointsGen(rect2);
matchNums = matchSet(rect1Set, rect2Set);
iouValue = matchNums / (size(rect1Set, 1) + size(rect2Set, 1) - matchNums);
end

function pointSet = pointsGen(rect)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);
pointSet = zeros(w*h, 2);

for i=1:h
    for j=1:w
        pointSet((i-1)*w+j,:) = [x+j-1, y+i-1];
    end
end
end

function nums = matchSet(set1, set2)
nums = 0;
for i=1:size(set1, 1)
    for j=1:size(set2, 1)
        if set1(i, :) == set2(j, :)
            nums = nums + 1;
            break;
        end
    end
end
end

