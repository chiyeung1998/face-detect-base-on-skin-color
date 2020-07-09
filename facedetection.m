function facedetection()
clear;
clc;
close all;
%% ������Ƭ

figure(1)
[fileName,filePath] = uigetfile('*','�����ͼƬ');
str  = strcat(filePath,fileName);
input_img =  imread(str);
subplot(1,3,1); imshow(input_img);
title('�����ͼƬ')
%% ��ͼƬת��Ϊ�Ҷ�ͼ�����yCbCr�ռ�����ʾ

image_gray1 = rgb2gray(input_img); 
edge1 =  edge(image_gray1,'canny');
I1 = medfilt2(edge1,[9 9]);
image_ycbcr = rgb2ycbcr(input_img);
subplot(1,3,2); imshow(image_gray1); title('�Ҷ�ͼ');
subplot(1,3,3); imshow(image_ycbcr); title('RGB to YCbCr');
%% ���ͼ��߶ȺͿ��
height = size(input_img,1);
width = size(input_img,2);
%% �ֶ��ж��Ƿ��ɫ
% ��1���������ȵ���80���ص�ֱ���о�Ϊ�Ƿ�ɫ���ص㣻
% ��2������������80-230֮������ص���÷�ɫ����Բ���෽����
% ��3���������ȴ���230�����ص�����о��ǣ�����ɫ�ľ���ʱ����Բ�ĳ�����ͬʱ����Ϊԭ����1.1����

for i = 1:height  
    for j = 1:width  
        Y  = image_ycbcr(i,j,1);  
        Cb = image_ycbcr(i,j,2);  
        Cr = image_ycbcr(i,j,3);  
            if(skin1(Y,Cb,Cr) == 1)  
                I1(i,j) = 255;  
            else  
                I1(i,j) = 0;  
            end  
    end  
end 
figure(2);subplot(1,2,1);imshow(I1);title('�����㷨��Ķ�ֵͼ');
imwrite(I1,'Anil.jpg')
%% �Զ�ֵͼ�������̬ѧ����
erode_image = bwmorph(I1,'erode');
%open_image = bwmorph(erode_image,'open');
%close_image = bwmorph(open_image,'close');
%spur_image = bwmorph(open_image,'spur');
clean_image = bwmorph(erode_image,'clean');
subplot(1,2,2);imshow(clean_image);title('��̬ѧ������ͼ��');
%% �����ͨ���򲢱���
[D,num1] = bwlabel(clean_image,8);
stats = regionprops(D,'BoundingBox');
n =1;
result = zeros(n,4);
figure(3);imshow(input_img);
p=0;

for i= 1:num1
    box = stats(i).BoundingBox;   %ȡ����ͨ������β���
    x = box(1);                   %���ε�x����
    y = box(2);                   %���ε�y����
    w = box(3);                   %���ο��
    h = box(4);                   %���θ߶�
    ratio = h/w;                  %�߶ȺͿ�ȵı���
    ux=uint8(x);
    uy=uint8(y);
    
    if ux>1
        ux=ux-1;
    end
    if uy>1
        uy=uy-1;
    end
%  �ж�����Ӧ��������������
%  1.�߶ȺͿ�ȱ��붼����20���Ҿ����������400 (���ֶ�������ֵ) 
%  2.�߶ȺͿ�ȱ���Ӧ���ڷ�Χ��0.6~1.8����
    if w < 20|| h < 20 || w*h < 400
        continue
    elseif ratio> 0.3 
        % ��¼��������
        result(n,:)=[ux uy w h];
        n=n+1;
    end
end

hold on
if  size(result,1) == 1 && result(1,1) > 0
    rectangle('Position',[result(1,1),result(1,2),result(1,3),result(1,4)],'Curvature',[1,1],'LineStyle','--','EdgeColor','r','LineWidth',2);
  
else
    % ������������ľ����������1���ٸ���������Ϣ����ɸѡ
    
    for m  = 1:size(result,1)  
        m1 = result(m,1);  
        m2 = result(m,2);  
        m3 = result(m,3);  
        m4 = result(m,4);  
        % ������յ���������  
        if m1 + m3 < width && m2 + m4 < height   
            rectangle('Position',[m1,m2,m3,m4],'Curvature',[1,1],'LineStyle','--','EdgeColor','y','LineWidth',2);
        end  
    end     


   % pause(1);   
end
