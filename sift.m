function [leftF,rightF,prunedMatches] = sift(leftImg,rightImg,pruneVal)
%SIFT Get necessary variables for panoramic stitching
%   produces list of features using SIFT from the provided 2 images as well
%   as the list of sorted feature matches

% Detect keypoints and extract descriptors
[leftF, leftD] = vl_sift(leftImg);
[rightF, rightD] = vl_sift(rightImg);

% Basic matching algorithm using vl_ubcmatch
[matches, scores] = vl_ubcmatch(leftD, rightD);

% Sort distances from lowest to highest and get sort index returned as a vector 
[~, sortedIndex] = sort(scores);

% Sort matches vector according to how scores was sorted so the index values
% still match between matches and scores
sortedMatches = matches(:, sortedIndex);

prunedMatches = sortedMatches(:,1:pruneVal);
end

