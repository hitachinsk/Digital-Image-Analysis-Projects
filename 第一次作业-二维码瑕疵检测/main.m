clear;
close all;
clc;

%% Binarize the input image
im = imread('test_images/barcode_7.png');

im_gray = rgb2gray(im);
level = graythresh(im_gray);
bw = imbinarize(im_gray, level);

figure; 
subplot(2, 1, 1); imshow(im_gray); title('original image');
subplot(2, 1, 2); imshow(bw); title('binary result');
%% mask all the trash regions
erode_kernel_size = 60;
kernel_origin = strel('line', erode_kernel_size, 0);
erode_image = imerode(bw, kernel_origin);
erode_image_inverse = ~erode_image;
L = bwlabel(erode_image_inverse);
max_connextion = max(max(L));
max_regions = zeros(1, 2);
max_region_points = zeros(1, 2);
for i=1:max_connextion
    region_points = numel(L(L==i));
    if region_points > max_region_points(1)
        max_region_points(2) = max_region_points(1);
        max_region_points(1) = region_points;
        max_regions(2) = max_regions(1);
        max_regions(1) = i;
    elseif region_points > max_region_points(2)
        max_region_points(2) = region_points;
        max_regions(2) = i;
    end
end
L(L~=max_regions(1) & L ~= max_regions(2)) = 0;
L_inverse = ~L;
bw_clean = bw + L_inverse;
bw_clean(bw_clean > 1) = 1;
figure;
subplot(2, 1, 1); imshow(L);
subplot(2, 1, 2); imshow(bw_clean);
%% column erosion to fill the artifact
kernel_fill = strel('line', 5, 90);
filled_image = imerode(bw_clean, kernel_fill);
for i=1:2
    filled_image = imerode(filled_image, kernel_fill);
end
figure;
subplot(2, 1, 1); imshow(bw_clean);
subplot(2, 1, 2); imshow(bw_clean - filled_image);
residual_image = bw_clean - filled_image;
residual_image(residual_image ~= 1) = 0;
%% remove the strap noise
strap_kernel = strel('line', 2, 0);
residual_clean = imerode(residual_image, strap_kernel);
figure;
subplot(2, 1, 1); imshow(bw_clean);
subplot(2, 1, 2); imshow(residual_clean);
%% remove erosion noise
[height, width] = size(L);
L(L >= 1) = 1;
qr_height = zeros(1, 4);
j = 1;
state = 1;
for i=1:height-1
    if sum(L(i,:)) == 0 && sum(L(i+1,:)) > 0
        qr_height(j) = i;
        j = j + 1;
    end
    if sum(L(i,:)) > 0 && sum(L(i+1,:)) == 0
        qr_height(j) = i;
        j = j + 1;
    end
    if j == 5
        break;
    end
end
for i=1:width-1
    if state == 1 && sum(L(:, i)) ~= 0
        left_width = i + erode_kernel_size;
        k = 1;
        while L(k, left_width) == 0
            k = k + 1;
        end
        left_height = k;
        state = 2;
    end
    if state == 2
        if sum(L(:, i)) ~= 0 && sum(L(:, i+1)) == 0
            right_width = i - erode_kernel_size;
            k = 1;
            while L(k, right_width) == 0
                k = k + 1;
            end
            right_height = k;
            break;
        end
    end
end
slope = (right_height - left_height) / (right_width - left_width);

kp = residual_clean;
leftest_width = left_width - erode_kernel_size;
leftest_height = floor(slope * (leftest_width - right_width) + right_height);
qr1_bottom_translation = qr_height(2) - leftest_height;
qr2_top_translation = qr_height(3) - qr_height(1);
qr2_bottom_translation = qr_height(4) - leftest_height;

for width_scanner=left_width - erode_kernel_size:right_width + erode_kernel_size
    current_height = floor(slope * (width_scanner - right_width) + right_height);
    qr1_bottom_height = current_height + qr1_bottom_translation;
    qr2_top_height = current_height + qr2_top_translation;
    qr2_bottom_height = current_height + qr2_bottom_translation;
    kp(current_height-14:current_height+14, width_scanner) = 0;
    kp(qr1_bottom_height-14:qr1_bottom_height+14, width_scanner) = 0;
    kp(qr2_top_height-14:qr2_top_height+10, width_scanner) = 0;
    kp(qr2_bottom_height-14:qr2_bottom_height+14, width_scanner) = 0;
end
figure;
subplot(2, 1, 1); imshow(residual_clean);
subplot(2, 1, 2); imshow(kp);
%% dilate results and find RoI
dilate_kernel = strel('square', 5);
kp2 = imdilate(kp, dilate_kernel);
RoIs = bwlabel(kp2);
RoI_nums = max(max(RoIs));
line_size = 3;
result = im;
for i=1:RoI_nums
    [row, column] = find(RoIs==i);
    result = draw_dict(result, min(row), max(row), min(column), max(column), line_size);
end
figure;
subplot(2, 1, 1); imshow(im);
subplot(2, 1, 2); imshow(result);