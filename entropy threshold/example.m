clear all;close all;clc
%%

im=imread('a7.jpg');
gray=rgb2gray(im);
fi_median = medfilt2(gray);
%figure,imshow(fi_median),title('median filtering');


% entropythreshold2D
[K_KL, K_KJ, K_KG] = entropythreshold2D (double(fi_median));
[bw_KL] =im2bw(fi_median, K_KL/255);
[bw_KJ] =im2bw(fi_median, K_KJ/255);
[bw_KG] =im2bw(fi_median, K_KG/255);
% Wolf
[bw_wolf] = wolf(fi_median);

%subplot(221)
imshow(bw_KL)
title('KL Threshold')
%subplot(222)
%imshow(bw_KJ)
%title('KJ Threshold')
%subplot(223)
%imshow(bw_KG)
%title('KG Threshold')
%subplot(224)
figure,imshow(bw_wolf)
title('Wolf Threshold')
%% Area
imshow(bw_KL);
dicomwrite(bw_KL, 'sc_file.dcm');
X = dicomread('sc_file.dcm');
%find the area in mm2
total = bwarea(X)

%area = bwarea(bw_KL);
%% Setting up a structuring element
se = strel('disk',1);
%Erode the image
BW_erode = imerode(bw_KL,se);
%Outline the componenets
BW_Outline = bw_KL - BW_erode;
imshowpair(bw_KL,BW_Outline,'montage');
%% % Overlaping the images for verifying
img = imread('a4.png');
% display it
imshow(img);
% superimpose a contour map (in this case of the image brightness)
hold on;
contour(BW_Outline, 20);
hold off;