function [homography] = computeHomography(prunedMatches,leftF,rightF)
%COMPUTEHOMOGRAPHY Computes a homography transformation given sets of matches
%   Given a set of features from two images, return the estimated
%   homography transformation

% Select N random coordinate pairs
N = 4;
r = randperm(size(prunedMatches,2),N);

% Start building known matrix A
A = zeros(2*N,9);
for i = 1:N
    % Finds the indexes of the coordinate pairings from the matches matrix
    indexOfLeftCoord = prunedMatches(1,r(i));
    indexOfRightCoord = prunedMatches(2,r(i));
    
    % Obtain the coordinate pairs from the feature matrix
    xL = leftF(1,indexOfLeftCoord);
    yL = leftF(2,indexOfLeftCoord);
    xR = rightF(1,indexOfRightCoord);
    yR = rightF(2,indexOfRightCoord);
    
    % Build A matrix
    A((2*i-1):2*i,:) = [xL yL 1 0 0 0 -xR*xL -xR*yL -xR;
                        0 0 0 xL yL 1 -yR*xL -yR*yL -yR];
end

% Obtain homography transformation matrix
[~, ~, V] = svd(A);
homography = V(:,end);
end

