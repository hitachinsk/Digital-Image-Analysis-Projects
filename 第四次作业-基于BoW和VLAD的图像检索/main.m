clc;
clear;
close all;
%% dataset information
prefix = "Image/ukbench";
images = 1000;
group = 4; % if floor(imageNum / group) are the same in 4 images, they are in the same group
suffix = ".jpg.dsift";
%% hyper parameters
vlad = 0; % vlad=0: BoW, vlad=1: VLAD
K = 2000; % size of codebook
multiply = 15; % features = K * multiply
descriptorSize = 128;
quantifyMethod = 2; % if 1 , it means "L1" normalization, 2 means "L2" normalization, other parameters are not supported
%% extract features (parameter)
features = K * multiply;
if vlad == 1
    features = 75000; % corresponding to 5000
end
featuresPerImage = ceil(features / images);
sampledFeatures = zeros(features, descriptorSize);
%% extract features(running)
idx = 0;
for i=0:images-1
    indexStr = indexGen(i);
    imagePath = strcat(prefix, indexStr, suffix);
    temp = readBinary(imagePath, featuresPerImage, 1);
    sampledFeatures(idx + 1:idx + size(temp, 1), :) = temp;
    idx = idx + size(temp, 1);
end
sampledFeatures = sampledFeatures(1:features * 0.8, :);
%% k-means
[idx, codeBook] = kmeans(sampledFeatures, K);
%% quantify visual representation
if vlad == 0
    featureHist = zeros(images, K);
else
    featureHist = zeros(images, 128 * K);
end
for i=0:images-1
    indexStr = indexGen(i);
    imagePath = strcat(prefix, indexStr, suffix);
    imagePath
    features = readBinary(imagePath, featuresPerImage, 0);
    if vlad == 0
        quantifyResult = quantify(features, codeBook, quantifyMethod);
        featureHist(i+1, :) = createHist(quantifyResult, K);
    else
        quantifyResult = vladQuantify(features, codeBook);
        featureHist(i+1, :) = quantifyResult;
    end
end
featureHist = normalizeHist(featureHist, quantifyMethod);
%% query and retrieval precision calculation
relativeExtent = zeros(images, images);
for query=1:images
    query
    for database=1:images
        relativeExtent(query, database) = distMetric(featureHist(query, :), featureHist(database, :), quantifyMethod);
    end
end
precision = calculatePrecision(relativeExtent);