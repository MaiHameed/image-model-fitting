%% Q2A

fprintf('Part A starting...\n');

% Setup VLFeat for temp use
run('vlfeat-0.9.21/toolbox/vl_setup');

% Load images, get separate colour channels 
LI = imread("parliament-left.jpg");
RI = imread("parliament-right.jpg");

% converted to single and grayscale
leftImg = single(rgb2gray(LI));
rightImg = single(rgb2gray(RI));

% The number of matches to extract from SIFT result
pruneVal = 5000;
[leftF, rightF, prunedMatches] = sift(leftImg, rightImg, pruneVal);

%% Compute affine transformation

% From sample list, compute affine transformation
disp('Computing affine transformation estimate using RANSAC');
disp('This might take some time...');
tic;
affine = RansacAffineEst(prunedMatches,leftF,rightF,100000,pruneVal,0.75);
disp('Done!');
toc;
save('affine','affine');

%% Image stitching

close all hidden;

% Transformation
T = [affine(1:2)' 0; affine(3:4)' 0; affine(5:6)' 1];
tform = affine2d(T);

% TODO: Remove this line when submitting
RI = imread("parliament-right.jpg");
RI = imwarp(RI,tform);

[leftF, rightF, prunedMatches] = sift(leftImg, single(rgb2gray(RI)), pruneVal);

%% Image composition

% xL = leftF(1,prunedMatches(1,1));
% yL = leftF(2,prunedMatches(1,1));
% xR = rightF(1,prunedMatches(2,1));
% yR = rightF(2,prunedMatches(2,1));

xL = [];
yL = [];
xR = [];
yR = [];
for i = 1:pruneVal
    xL = [xL leftF(1,prunedMatches(1,i))];
    yL = [yL leftF(2,prunedMatches(1,i))];
    xR = [xR rightF(1,prunedMatches(2,i))];
    yR = [yR rightF(2,prunedMatches(2,i))];
end

diffX = abs(xL-xR);
diffY = abs(yL-yR);

xShift = round(median(diffX));
yShift = round(median(diffY));

SI = zeros(yShift+size(RI,1),xShift+size(RI,2),3);

% A
SRSI = 1; 
ERSI = size(LI,1);
SCSI = 1;
ECSI = xShift;

SRLI = 1;
ERLI = size(LI,1);
SCLI = 1;
ECLI = xShift;
SI(SRSI:ERSI,SCSI:ECSI,:) = LI(SRLI:ERLI,SCLI:ECLI,:);

% B
SRSI = 1; 
ERSI = yShift;
SCSI = xShift+1;
ECSI = size(LI,2);

SRLI = 1;
ERLI = yShift;
SCLI = xShift+1;
ECLI = size(LI,2);
SI(SRSI:ERSI,SCSI:ECSI,:) = LI(SRLI:ERLI,SCLI:ECLI,:);

% C (Right image rows ends before left)
for i = yShift+1:yShift+size(RI,1)
    for j = xShift+1:size(LI,2)
        leftPixel = LI(i,j,:);
        rightPixel = RI(i-yShift,j-xShift,:);
        if rightPixel ==  0
            SI(i,j,:) = leftPixel;
        else
            SI(i,j,:) = rightPixel;
        end
    end
end

% C (Left image rows ends before right)
% for i = yShift+1:size(LI,1)
%     for j = xShift+1:size(LI,2)
%         leftPixel = LI(i,j,:);
%         rightPixel = RI(i-yShift,j-xShift,:);
%         if rightPixel ==  0
%             SI(i,j,:) = leftPixel;
%         else
%             SI(i,j,:) = rightPixel;
%         end
%     end
% end

% D (Left bigger than right)
SRSI = size(RI,1)+yShift+1;
ERSI = size(LI,1);
SCSI = xShift+1;
ECSI = size(LI,2);

SRLI = size(RI,1)+yShift+1;
ERLI = size(LI,1);
SCLI = xShift+1;
ECLI = size(LI,2);
SI(SRSI:ERSI,SCSI:ECSI,:) = LI(SRLI:ERLI,SCLI:ECLI,:);

% D (Right bigger than left)
% SRSI = size(LI,1)+1; 
% ERSI = size(RI,1)+yShift;
% SCSI = xShift+1;
% ECSI = size(LI,2);
% 
% SRRI = size(LI,1)-yShift+1;
% ERRI = size(RI,1);
% SCRI = 1;
% ECRI = size(LI,2)-xShift;
% SI(SRSI:ERSI,SCSI:ECSI,:) = RI(SRRI:ERRI,SCRI:ECRI,:);

% E
SRSI = yShift+1; 
ERSI = yShift+size(RI,1);
SCSI = size(LI,2);
ECSI = size(RI,2)+xShift-1;

SRRI = 1;
ERRI = size(RI,1);
SCRI = size(LI,2)-xShift+1;
ECRI = size(RI,2);
SI(SRSI:ERSI,SCSI:ECSI,:) = RI(SRRI:ERRI,SCRI:ECRI,:);

figure;
imshow(uint8(RI),[]);
title("Right image, transformed");
figure;
imshow(uint8(LI),[]);
title("Left image");
figure;
imshow(uint8(SI),[]);
title("Composite image");

%fprintf('Part A done! Press enter to continue...\n\n');
%pause;

%% Q2B
clear;

% Load images, converted to single and grayscale
leftImg = single(rgb2gray(imread("Ryerson-left.jpg")));
rightImg = single(rgb2gray(imread("Ryerson-right.jpg")));

% The number of matches to extract from SIFT result
pruneVal = 5000;
[leftF, rightF, prunedMatches] = sift(leftImg, rightImg, pruneVal);

%% Compute homography transformation

% From sample list, compute homography transformation
disp('Computing homography transformation estimate using RANSAC');
disp('This might take some time...');
tic;
homography = RansacHomoEst(prunedMatches,leftF,rightF,5000,pruneVal,0.75);
disp('Done!');
toc;

% Reshape column vector into 3x3 matrix
H = reshape(homography,[3,3])';
tform = projective2d(H);
imshow(uint8(imwarp(rightImg,tform)));

