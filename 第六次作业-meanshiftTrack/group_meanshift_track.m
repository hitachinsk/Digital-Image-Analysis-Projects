clc;
clear;
close all;
test_seq = 'Woman';  % 选择视频的名字 'Lemming' 'Woman'

%% %%%%%%%%%%%%%%%% 读取第一帧及目标框，初始化跟踪目标 %%%%%%%%%%%%%%%%%%%%%%%
videofile = dir([test_seq, '\img\*.jpg']);
frame_number = length(videofile);
first_img = [test_seq, '\img\', videofile(1).name]; % 第一帧图片
ground_truth = [test_seq, '\groundtruth_rect.txt']; 
all_rects = importdata(ground_truth);  % 所有帧的目标框:[x,y,w,h]
rect = all_rects(1,:);  % 第一个帧的目标框
I = imread(first_img); % 读取了第一个图片

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算目标图像的权值矩阵 %%%%%%%%%%%%%%%%%%%%%%%
rect_top = [rect(1), rect(2), rect(3), floor(rect(4) / 2)];
rect_bottom = [rect(1), rect(2)+floor(rect(4) / 2), rect(3), ceil(rect(4) / 2)];

temp_top = imcrop(I, rect_top);
temp_bottom = imcrop(I, rect_bottom);

[a, b, c] = size(temp_top);  % [h, w, c]
[ab, bb, cb] = size(temp_bottom);
y_top(1) = a / 2;
y_top(2) = b / 2;
y_bottom(1) = ab / 2;
y_bottom(2) = bb / 2;

hist1_top = zeros(1, 4096);
hist1_bottom = zeros(1, 4096);

hist1_top = candidateHist(hist1_top, temp_top);
hist1_bottom = candidateHist(hist1_bottom, temp_bottom);

%% %%%%%%%%%%%%%%%%%%%%%%% 读取序列图像,进行后续跟踪  %%%%%%%%%%%%%%%%%%%%%%%
trackSuccess = 0;
for frame = 2 : frame_number
    img_path = [test_seq, '\img\', videofile(frame).name];
    cur_img = imread(img_path);
    iter_num = 0;
    delta = [2,2]; % 随意初始化一个目标位置的移动步长
  
    %%%%%%% mean shift 迭代 
    while((delta(1)^2 + delta(2)^2 > 0.5) && iter_num < 20)   %迭代条件,默认20次迭代
        iter_num = iter_num + 1;
        current_temp_top = imcrop(cur_img, rect_top);
        current_temp_bottom = imcrop(cur_img, rect_bottom);
        
        %计算侯选区域直方图
        hist2_top = zeros(1,4096);
        hist2_bottom = zeros(1, 4096);
        
        % 待完成：计算候选区域直方图
        [hist2_top, q_temp_top] = candidateHist(hist2_top, current_temp_top);
        [hist2_bottom, q_temp_bottom] = candidateHist(hist2_bottom, current_temp_bottom);
        
        % 待完成：计算相似度、权重等
        sim_top = similarity(hist1_top, hist2_top);
        weightMap_top = weight(hist1_top, hist2_top);

        sim_bottom = similarity(hist1_bottom, hist2_bottom);
        weightMap_bottom = weight(hist1_bottom, hist2_bottom);

        % 待完成：计算迭代步长并更新目标的位置
        loc_top = newLoc(current_temp_top, weightMap_top, q_temp_top, y_top);
        loc_bottom = newLoc(current_temp_bottom, weightMap_bottom, q_temp_bottom, y_bottom);
        if sim_top < sim_bottom
            delta = loc_bottom;
        end
        if sim_bottom < sim_top
            delta = loc_top;
        end
        if isnan(loc_top)
            delta = loc_bottom;
        end
        if isnan(loc_bottom)
            delta = loc_top;
        end
        rect_top(1) = rect_top(1) + floor(delta(2));
        rect_top(2) = rect_top(2) + floor(delta(1));
        rect_bottom(1) = rect_bottom(1) + floor(delta(2));
        rect_bottom(2) = rect_bottom(2) + floor(delta(1));
        rect(1) = rect_top(1);
        rect(2) = rect_top(2);
    end
    
    if iou(rect, all_rects(frame, :)) > 0.7
        trackSuccess = trackSuccess + 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%% 显示跟踪结果 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(1);
    imshow(uint8(cur_img),'border','tight');
    rectangle('Position',rect,'LineWidth',5,'EdgeColor','r'); 
    hold on;
    text(5, 18, strcat('#',num2str(frame)), 'Color','y', 'FontWeight','bold', 'FontSize',30);
    set(gca,'position',[0 0 1 1]); 
    pause(0.00001); 
    if mod(frame, 15) == 2
        I = getframe(gcf);
        imwrite(I.cdata, strcat('temp/', num2str(frame), '.png'));
    end
    hold off;
   
end
mIoU = trackSuccess / (frame_number - 1);
