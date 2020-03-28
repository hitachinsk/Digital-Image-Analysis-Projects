function visualizeA(image, x, y, allAxis)
lineSize = 1;
allAxis = allAxis';
for item=1:size(allAxis, 1)
    image = draw_dict(image, allAxis(item, 1)-lineSize, allAxis(item, 1)+lineSize, allAxis(item, 2)-lineSize, allAxis(item, 2)+lineSize, lineSize, [0, 255, 0]);
end
image = draw_dict(image, x-lineSize, x+lineSize, y-lineSize, y+lineSize, lineSize, [255, 0, 0]);
imshow(image);
end

