
%%
%f=imread('a2.jpg');
%a = imresize(f,[512 512]);

%figure ,imshow(f),title('orginal');
%size(a)
%% Reading the images 
f=imread('a7.jpg');
a=f;
figure ,imshow(f),title('orginal');
size(f)
a_hsv = rgb2hsv (a);
a_v = a_hsv(:,:,3);
a_v = histeq(a_v);
a = hsv2rgb(a_hsv);
subplot(1,2,1), imshow(f), title('Orginal');
subplot(1,2,2), imshow(a), title('HE Image');


%%
%truecolor = multibandread('untitled.jpg',[512, 512, 3],'uint16=>uint16', ...
    %128,'bil','ieee-le',{'Band','Direct',[3 2 1]});
%imshow(truecolor);
%% Filtering the images:
%fspecial is inbuilt command for filtering
%avg filter
f_average = fspecial('average',3);
%gaussian filter
f_gaussian = fspecial('gaussian',3,0.5);%0.5 is value of sigma
%
fi_average = imfilter(f,f_average);
fi_gaussian = imfilter(f,f_gaussian);
%for median filtering wehave an inbuilt command
%fi_median = medfilt2(f);
%%displaying the filtered images
figure,imshow(fi_average),title('average filtered');
figure,imshow(fi_gaussian),title('gaussian filtered');
%% conversion into gray
f_gray=rgb2gray(f);
size(f_gray)
%imshow(f_gray);
fi_median = medfilt2(f_gray);
figure,imshow(fi_median),title('median filtering');
%% Histogram Equalization
f_histeq = histeq(f_gray);

% Plots
subplot(2,2,1), imshow(f_gray),title('orginalgray');
subplot(2,2,2), imshow(f_histeq),title('HE Image');
subplot(2,2,3), imhist(f_gray),title('histogram of f_gray');
subplot(2,2,4), imhist(f_histeq),title('histogram of HE Image');

%% threshold level
[counts,x] = imhist(fi_median,16);% 16 bin histogram
stem(x,counts)
T = otsuthresh(counts);
Z=T;
%thres_level=graythresh(fi_median);
%Ithresh = im2bw(fi_median,level);
%imshowpair(f_gaussian,Ithresh,'montage')
BW = imbinarize(fi_median,T);
[u,v]=find(BW>0);
WB = ~BW;
numberOfTruePixels = sum(BW(:));
figure,imshowpair(fi_median,BW,'montage');axis on;
title('median');
figure,imshowpair(fi_gaussian,BW,'montage')
%% Setting up a structuring element
se = strel('disk',1);
%Erode the image
BW_erode = imerode(BW,se);
%Outline the componenets
BW_Outline = BW - BW_erode;
imshowpair(BW,BW_Outline,'montage');
imshow(BW_Outline);
%% morpho
se = strel('disk',2);
%Erode the image
BW_erode = imerode(BW,se);
%dilation 
BW_dialate = imdilate (BW,se);
%subplot
subplot(1,3,1),imshow(BW),title('binary');
subplot(1,3,2),imshow(BW_erode),title('erode');
subplot(1,3,3),imshow(BW_dialate),title('dilate');

%% % Overlaping the images for verifying
img = imread('a7.jpg');
% display it
imshow(img);
% superimpose a contour map (in this case of the image brightness)
hold on;
contour(BW_Outline, 20);
M=contour(BW_Outline, 20);
hold off;
%% ACtive contour segmentation
%mask = zeros(size(f_gray));

%mask(10:end-0,10 : end -10)=1;
%Active Contour Model

%B= activecontour (f_gray, mask, 10000);
%O=~B;
%subplot(1,2,1), imshow(f_gray),title('grayscale');
%subplot(1,2,1), imshow(O),title('B')
%% Area

imshow(M);
%imshow(WB);
dicomwrite(WB, 'sc_file.dcm');
X = dicomread('sc_file.dcm');
%find the area in mm2
total = bwarea(X)
%% TO compute the pixels

grayImage = imread('PIX7.JPG');
imshow(grayImage, []);
axis on;
title('Masked Image');
%set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Ask user to draw freehand mask.
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));
hFH = imfreehand(); % Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
xy = hFH.getPosition;

% Now make it smaller so we can show more images.
subplot(2, 3, 1);
imshow(grayImage, []);
axis on;
drawnow;
title('MASKED Image', 'FontSize', 16);

% Display the freehand mask.
subplot(2, 3, 2);
imshow(binaryImage);
numberOfTruePixels2 = sum(binaryImage(:));
axis on;
title('Binary mask of the region', 'FontSize', 16);





