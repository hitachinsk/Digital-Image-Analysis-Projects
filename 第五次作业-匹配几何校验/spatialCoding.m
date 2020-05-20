function [GX, GY] = spatialCoding(r, features)
% Be consistency with the paper, r is the bit number to represent the image
% split blocks, feature is a matrix contains the x-axis and y-axis of SIFT
% features extracted from image, it's a 2xN dimensional matrix, row-axis
% contains value of x-y axis, column-axis contains different features.
% Reference: formula (4) and (5) in "Spatial Coding for Large Scale
% Partial-Duplicate Web Image Search" (wengang zhou)
GX = zeros(size(features, 2), size(features, 2), r);
GY = zeros(size(features, 2), size(features, 2), r);
for k=0:r-1
    theta = k * pi / (2 * r);
    rotationMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    rotatedFeatures = rotationMatrix * features;
    GX_k = generateMap(rotatedFeatures(1, :));
    GY_k = generateMap(rotatedFeatures(2, :));
    GX(:, :, k+1) = GX_k;
    GY(:, :, k+1) = GY_k;
end
end

function G_k = generateMap(rotatedFeature)
    expansionMatrix = repmat(rotatedFeature(1, :), size(rotatedFeature, 2), 1);
    G_k = expansionMatrix - diag(expansionMatrix);
    locPositive = find(G_k >= 0);
    locNegative =  setdiff(1:numel(G_k), locPositive);
    G_k(locPositive) = 1;
    G_k(locNegative) = 0;
end