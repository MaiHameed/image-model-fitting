clear;

% Load images, converted to single and grayscale
leftImg = single(rgb2gray(imread("./img_inputs/bonus-left.jpg")));
rightImg = single(rgb2gray(imread("./img_inputs/bonus-right.jpg")));

% The number of matches to extract from SIFT result
pruneVal = 3900;

% The sift() function takes a bit of time to complete so I stored all of
% the workspace variables for quicker execution. If you want to see it run
% instead, simply comment out the load() command, and uncomment the sift()
% command
load('./data/bonus-a');
%[leftF, rightF, prunedMatches] = sift(leftImg, rightImg, pruneVal);

%% Compute homography transformation

% From sample list, compute homography transformation
disp('Computing homography transformation estimate using RANSAC');
disp('This might take some time...');
tic;
homography = RansacHomoEst(prunedMatches,leftF,rightF,500,500,5);
disp('Done!');
toc;

% The parameters to calculate my homography (which was fed into the
% RansacHomoEst() function above) were reduced to speed up execution
% time. I loaded in a better estimate below which was calculated using more
% datapoints, and therefore took much longer to calculate. 
load('./data/bonus-b');

% Reshape column vector into 3x3 matrix
H = reshape(homography,[3,3]);
tform = projective2d(H);

%% Image stitching

LI = imread("./img_inputs/bonus-left.jpg");
RI = imread("./img_inputs/bonus-right.jpg");

% The stitch() function takes some time to process, so I preprocessed it
% and simply reloaded the variable here for quicker execution for the demo
% only. If you want to run the stitch() function, simply uncomment the
% function and comment out the load() function.
%SI = stitch(imwarp(LI,tform), RI, pruneVal);
load('./data/bonus-c');

figure;
imshow(uint8(imwarp(LI,tform)));
title("Warped left image");

figure;
imshow(uint8(RI));
title("Right image");

figure;
imshow(uint8(SI));
title("Combined image");

fprintf('Bonus done!\n\n');