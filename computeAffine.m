function [affineMatrix] = computeAffine(matches,leftF,rightF)
%COMPUTEAFFINE Computes an affine transformation given sets of matches
%   Given a set of features from two images, return the estimated affine
%   transformation

% Select N random coordinate pairs
N = 3;
r = randperm(size(matches,2),N);

% Start building known matrices A and b 
A = zeros(2*N,6);
b = zeros(2*N,1);
for i = 1:N
    % Finds the indexes of the coordinate pairings from the matches matrix
    indexOfLeftCoord = matches(1,r(i));
    indexOfRightCoord = matches(2,r(i));
    
    % Obtain the coordinate pairs from the feature matrix
    xL = leftF(1,indexOfLeftCoord);
    yL = leftF(2,indexOfLeftCoord);
    xR = rightF(1,indexOfRightCoord);
    yR = rightF(2,indexOfRightCoord);
    
    % Build A matrix
    A((2*i-1):2*i,:) = [xL yL 0 0 1 0;
                        0 0 xL yL 0 1];
    % Build b matrix
    b((2*i-1):2*i) = [xR; yR];
end

% Obtain affine transformation matrix
affineMatrix  = A\b;
end

