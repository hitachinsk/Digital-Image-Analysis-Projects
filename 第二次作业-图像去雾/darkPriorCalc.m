function darkPrior = darkPriorCalc(image, block_size)
padImage = padarray(image, [(block_size-1)/2, (block_size-1)/2], 'replicate', 'both');
height = size(image, 1);
width = size(image, 2);
darkPrior = zeros(height, width);
for heightIdx=1:height
    for widthIdx=1:width
        window = padImage(heightIdx:heightIdx+block_size-1, widthIdx:widthIdx+block_size-1, :);
        channelMin = min(min(window));
        darkPrior(heightIdx, widthIdx) = min(channelMin);
    end
end