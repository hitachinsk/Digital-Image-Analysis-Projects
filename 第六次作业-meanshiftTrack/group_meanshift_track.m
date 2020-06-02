clc;
clear;
close all;
test_seq = 'Woman';  % ѡ����Ƶ������ 'Lemming' 'Woman'

%% %%%%%%%%%%%%%%%% ��ȡ��һ֡��Ŀ��򣬳�ʼ������Ŀ�� %%%%%%%%%%%%%%%%%%%%%%%
videofile = dir([test_seq, '\img\*.jpg']);
frame_number = length(videofile);
first_img = [test_seq, '\img\', videofile(1).name]; % ��һ֡ͼƬ
ground_truth = [test_seq, '\groundtruth_rect.txt']; 
all_rects = importdata(ground_truth);  % ����֡��Ŀ���:[x,y,w,h]
rect = all_rects(1,:);  % ��һ��֡��Ŀ���
I = imread(first_img); % ��ȡ�˵�һ��ͼƬ

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% ����Ŀ��ͼ���Ȩֵ���� %%%%%%%%%%%%%%%%%%%%%%%
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

%% %%%%%%%%%%%%%%%%%%%%%%% ��ȡ����ͼ��,���к�������  %%%%%%%%%%%%%%%%%%%%%%%
trackSuccess = 0;
for frame = 2 : frame_number
    img_path = [test_seq, '\img\', videofile(frame).name];
    cur_img = imread(img_path);
    iter_num = 0;
    delta = [2,2]; % �����ʼ��һ��Ŀ��λ�õ��ƶ�����
  
    %%%%%%% mean shift ���� 
    while((delta(1)^2 + delta(2)^2 > 0.5) && iter_num < 20)   %��������,Ĭ��20�ε���
        iter_num = iter_num + 1;
        current_temp_top = imcrop(cur_img, rect_top);
        current_temp_bottom = imcrop(cur_img, rect_bottom);
        
        %�����ѡ����ֱ��ͼ
        hist2_top = zeros(1,4096);
        hist2_bottom = zeros(1, 4096);
        
        % ����ɣ������ѡ����ֱ��ͼ
        [hist2_top, q_temp_top] = candidateHist(hist2_top, current_temp_top);
        [hist2_bottom, q_temp_bottom] = candidateHist(hist2_bottom, current_temp_bottom);
        
        % ����ɣ��������ƶȡ�Ȩ�ص�
        sim_top = similarity(hist1_top, hist2_top);
        weightMap_top = weight(hist1_top, hist2_top);

        sim_bottom = similarity(hist1_bottom, hist2_bottom);
        weightMap_bottom = weight(hist1_bottom, hist2_bottom);

        % ����ɣ������������������Ŀ���λ��
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
    
    %%%%%%%%%%%%%%%%%%%%%%%% ��ʾ���ٽ�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
