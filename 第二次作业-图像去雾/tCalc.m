function t = tCalc(image, block_size, w, x, y)
biggestIntensity = image(x, y, :);
padImage = padarray(image, [(block_size-1)/2, (block_size-1)/2], 'replicate', 'both');
height = size(image, 1);
width = size(image, 2);
t = zeros(height, width);
for heightIdx=1:height
    for widthIdx=1:width
        window = padImage(heightIdx:heightIdx+block_size-1, widthIdx:widthIdx+block_size-1, :);
        for channel=1:3
            window(:, :, channel) = window(:, :, channel) ./ biggestIntensity(channel);
        end
        channelMin = min(min(window));
        t(heightIdx, widthIdx) = 1 - w * min(channelMin);
    end
end