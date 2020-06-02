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
temp = imcrop(I, rect);
[a,b,c] = size(temp); 	
y(1) = a/2;
y(2) = b/2;
tic_x = rect(1) + rect(3)/2;
tic_y = rect(2) + rect(4)/2;  % y(1)和y(2)是中心的相对坐标，而tic_x和tic_y是绝对坐标
m_wei = zeros(a,b);   % 权值矩阵
h = y(1)^2 + y(2)^2;  % 带宽

for i = 1:a
    for j = 1:b
        dist = (i-y(1))^2 + (j-y(2))^2;  % 与中心点的距离
        m_wei(i,j) = 1 - dist/h; % epanechnikov profile 核估计
    end
end
C = 1/sum(sum(m_wei)); %归一化系数

%计算目标权值直方图qu, 直方图取16 bins,因此初始化 4096-dim histogram，16^3(rgb)
hist1 = zeros(1,4096);
for i = 1:a
    for j = 1:b
        % rgb 颜色空间量化为 16*16*16 bins
        q_r = fix(double(temp(i,j,1))/16);  % fix为趋近0取整函数
        q_g = fix(double(temp(i,j,2))/16);
        q_b = fix(double(temp(i,j,3))/16);
        q_temp = q_r*256 + q_g*16 + q_b;                   % 设置每个像素点红色、绿色、蓝色分量所占比重
        hist1(q_temp+1) = hist1(q_temp+1) + m_wei(i,j);    % 计算直方图统计中每个像素点占的权重
    end
end
hist1 = hist1 * C;  % 以上步骤完成了目标核函数直方图
rect(3) = ceil(rect(3));
rect(4) = ceil(rect(4));

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
        current_temp = imcrop(cur_img, rect);
        
        %计算侯选区域直方图
        hist2 = zeros(1,4096);
        
        % 待完成：计算候选区域直方图
        [hist2, q_temp] = candidateHist(hist2, current_temp);
        
        % 待完成：计算相似度、权重等
        sim = similarity(hist1, hist2);
        weightMap = weight(hist1, hist2);
        
        % 待完成：计算迭代步长并更新目标的位置
        loc = newLoc(current_temp, weightMap, q_temp, y);
        loc
        delta = loc;
        rect(1) = rect(1) + floor(delta(2));
        rect(2) = rect(2) + floor(delta(1));
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
