clear;
close all;
clc;
%% read image
image = imread('test images/haze5.jpg');
imshow(image);
%% hyper parameters
block_size = 15;  % block size of local patch
w = 0.95;  % left 1-w haze for perception (formula 12)
t0 = 0.1;  % preventing the result image prone to 0 (formula 16)
lamda = 1e-4;  % formula 15, constraint parameter between t and t~
atmosTop = 0.001;  % pick the top brightest pixels in the dark channel to produce atomospheric light A
%% calculation of dark prior
darkPrior = darkPriorCalc(image, block_size);
darkPriorGray = mat2gray(darkPrior);
figure;
imshow(darkPriorGray);
title('dark prior gray map');
%% calculation of atmospheric light
[A, x, y, allAxis] = atmosphericCalc(image, darkPrior, atmosTop);
visualizeA(image, x, y, allAxis);
%% calculation of t~
image = im2double(image);
tUnrefined = tCalc(image, block_size, w, x, y);
tUnrefinedGrey = mat2gray(tUnrefined);
figure;
subplot(2, 1, 2); imshow(tUnrefinedGrey);
subplot(2, 1, 1); imshow(image);
%% calculation of t
tRefined = softMat(image, tUnrefined, block_size, lamda);  % 思路是将transmission图使用原图的灰度图像做guided filter
figure;
subplot(2, 1, 1); imshow(tUnrefinedGrey);
subplot(2, 1, 2); imshow(tRefined);
%% get results
result = getResult(image, x, y, tRefined, t0);
figure;
subplot(2, 1, 1); imshow(image);
subplot(2, 1, 2); imshow(result);