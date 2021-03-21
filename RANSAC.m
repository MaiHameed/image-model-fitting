%% Q2A

fprintf('Part A starting...\n');

% Setup VLFeat for temp use
run('vlfeat-0.9.21/toolbox/vl_setup');

% Load images
LI = imread("./img_inputs/parliament-left.jpg");
RI = imread("./img_inputs/parliament-right.jpg");

% converted to single and grayscale
leftImg = single(rgb2gray(LI));
rightImg = single(rgb2gray(RI));

% The number of matches to extract from SIFT result
pruneVal = 5000;

% The sift() function takes a bit of time to complete so I stored all of
% the workspace variables for quicker execution. If you want to see it run
% instead, simply comment out the load() command, and uncomment the sift()
% command
load('./data/Part2A');
%[leftF, rightF, prunedMatches] = sift(leftImg, rightImg, pruneVal);


%% Compute affine transformation

% From sample list, compute affine transformation
disp('Computing affine transformation estimate using RANSAC');
disp('This might take some time...');
tic;
affine = RansacAffineEst(prunedMatches,leftF,rightF,1000,1000,1);
disp('Done!');
toc;

% The parameters to calculate my affine (which was fed into the
% RansacAffineEst() function above) were reduced to speed up execution
% time. I loaded in a better estimate below which was calculated using more
% datapoints, and therefore took much longer to calculate. 
load('./data/affine');

%% Image stitching

close all hidden;

% Transformation
T = [[affine(1) affine(2) affine(5)]' [affine(3) affine(4) affine(6)]' [0 0 1]'];
tform = affine2d(T);

RI = imread("./img_inputs/parliament-right.jpg");
LI = imread("./img_inputs/parliament-left.jpg");
LI = imwarp(LI,tform);

figure;
imshow(uint8(LI));
title("Warped left image");

figure;
imshow(uint8(RI));
title("Original right image");

%% Image stitching

% The stitch() function takes some time to process, so I preprocessed it
% and simply reloaded the variable here for quicker execution for the demo
% only. If you want to run the stitch() function, simply uncomment the
% function and comment out the load() function.
%SI = stitch(LI, RI, pruneVal);
load('./data/Part2A-SI');

figure;
imshow(uint8(SI));
title("Combined image");

fprintf('Part A done! Press enter to continue...\n\n');
pause;

%% Q2B-1

fprintf('Part B-1 starting...\n\n');

clear;

% Load images, converted to single and grayscale
leftImg = single(rgb2gray(imread("./img_inputs/Ryerson-left.jpg")));
rightImg = single(rgb2gray(imread("./img_inputs/Ryerson-right.jpg")));

% The number of matches to extract from SIFT result
pruneVal = 5000;

% The sift() function takes a bit of time to complete so I stored all of
% the workspace variables for quicker execution. If you want to see it run
% instead, simply comment out the load() command, and uncomment the sift()
% command
load('./data/Part2B');
%[leftF, rightF, prunedMatches] = sift(leftImg, rightImg, pruneVal);

%% Compute homography transformation

% From sample list, compute homography transformation
disp('Computing homography transformation estimate using RANSAC');
disp('This might take some time...');
tic;
homography = RansacHomoEst(prunedMatches,leftF,rightF,500,500,1.5);
disp('Done!');
toc;

% The parameters to calculate my homography (which was fed into the
% RansacHomoEst() function above) were reduced to speed up execution
% time. I loaded in a better estimate below which was calculated using more
% datapoints, and therefore took much longer to calculate. 
load('./data/homography');

% Reshape column vector into 3x3 matrix
H = reshape(homography,[3,3]);
tform = projective2d(H);

RI = imread("./img_inputs/Ryerson-right.jpg");
LI = imread("./img_inputs/Ryerson-left.jpg");

%% Image stitching

% The stitch() function takes some time to process, so I preprocessed it
% and simply reloaded the variable here for quicker execution for the demo
% only. If you want to run the stitch() function, simply uncomment the
% function and comment out the load() function.
%SI = stitch(imwarp(LI,tform), RI, pruneVal);
load('./data/Part2B-SI');

figure;
imshow(uint8(imwarp(LI,tform)));
title("Warped left image");

figure;
imshow(uint8(RI));
title("Right image");

figure;
imshow(uint8(SI));
title("Combined image");

fprintf('Part B-1 done! Press enter to continue...\n\n');
pause;

%% Q2B-2

fprintf('Part B-2 starting...\n\n');

clear;

% Load images, converted to single and grayscale
leftImg = single(rgb2gray(imread("./img_inputs/campus-left.jpg")));
rightImg = single(rgb2gray(imread("./img_inputs/campus-right.jpg")));

% The number of matches to extract from SIFT result
pruneVal = 2500;

% The sift() function takes a bit of time to complete so I stored all of
% the workspace variables for quicker execution. If you want to see it run
% instead, simply comment out the load() command, and uncomment the sift()
% command
load('./data/Part2B-2');
%[leftF, rightF, prunedMatches] = sift(leftImg, rightImg, pruneVal);

%% Compute homography transformation

% From sample list, compute homography transformation
disp('Computing homography transformation estimate using RANSAC');
disp('This might take some time...');
tic;
homography = RansacHomoEst(prunedMatches,leftF,rightF,500,500,1);
disp('Done!');
toc;

% The parameters to calculate my homography (which was fed into the
% RansacHomoEst() function above) were reduced to speed up execution
% time. I loaded in a better estimate below which was calculated using more
% datapoints, and therefore took much longer to calculate. 
load('./data/homography-2B-2');

% Reshape column vector into 3x3 matrix
H = reshape(homography,[3,3]);
tform = projective2d(H);


%% Image stitching

LI = imread("./img_inputs/campus-left.jpg");
RI = imread("./img_inputs/campus-right.jpg");

% The stitch() function takes some time to process, so I preprocessed it
% and simply reloaded the variable here for quicker execution for the demo
% only. If you want to run the stitch() function, simply uncomment the
% function and comment out the load() function.
%SI = stitch(imwarp(LI,tform), RI, pruneVal);
load('./data/Part2B-2-SI');

figure;
imshow(uint8(imwarp(LI,tform)));
title("Warped left image");

figure;
imshow(uint8(RI));
title("Right image");

figure;
imshow(uint8(SI));
title("Combined image");

fprintf('Part B done!\n\n');