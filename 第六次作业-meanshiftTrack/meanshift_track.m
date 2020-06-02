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
temp = imcrop(I, rect);
[a,b,c] = size(temp); 	
y(1) = a/2;
y(2) = b/2;
tic_x = rect(1) + rect(3)/2;
tic_y = rect(2) + rect(4)/2;  % y(1)��y(2)�����ĵ�������꣬��tic_x��tic_y�Ǿ�������
m_wei = zeros(a,b);   % Ȩֵ����
h = y(1)^2 + y(2)^2;  % ����

for i = 1:a
    for j = 1:b
        dist = (i-y(1))^2 + (j-y(2))^2;  % �����ĵ�ľ���
        m_wei(i,j) = 1 - dist/h; % epanechnikov profile �˹���
    end
end
C = 1/sum(sum(m_wei)); %��һ��ϵ��

%����Ŀ��Ȩֱֵ��ͼqu, ֱ��ͼȡ16 bins,��˳�ʼ�� 4096-dim histogram��16^3(rgb)
hist1 = zeros(1,4096);
for i = 1:a
    for j = 1:b
        % rgb ��ɫ�ռ�����Ϊ 16*16*16 bins
        q_r = fix(double(temp(i,j,1))/16);  % fixΪ����0ȡ������
        q_g = fix(double(temp(i,j,2))/16);
        q_b = fix(double(temp(i,j,3))/16);
        q_temp = q_r*256 + q_g*16 + q_b;                   % ����ÿ�����ص��ɫ����ɫ����ɫ������ռ����
        hist1(q_temp+1) = hist1(q_temp+1) + m_wei(i,j);    % ����ֱ��ͼͳ����ÿ�����ص�ռ��Ȩ��
    end
end
hist1 = hist1 * C;  % ���ϲ��������Ŀ��˺���ֱ��ͼ
rect(3) = ceil(rect(3));
rect(4) = ceil(rect(4));

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
        current_temp = imcrop(cur_img, rect);
        
        %�����ѡ����ֱ��ͼ
        hist2 = zeros(1,4096);
        
        % ����ɣ������ѡ����ֱ��ͼ
        [hist2, q_temp] = candidateHist(hist2, current_temp);
        
        % ����ɣ��������ƶȡ�Ȩ�ص�
        sim = similarity(hist1, hist2);
        weightMap = weight(hist1, hist2);
        
        % ����ɣ������������������Ŀ���λ��
        loc = newLoc(current_temp, weightMap, q_temp, y);
        loc
        delta = loc;
        rect(1) = rect(1) + floor(delta(2));
        rect(2) = rect(2) + floor(delta(1));
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
