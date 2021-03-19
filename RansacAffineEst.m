function [bestAffine] = RansacAffineEst(prunedMatches,leftF,rightF,M,N,errorThresh)
%RANSACAFFINEEST Uses RANSAC to determine best affine transformation
%   matches = the feature matching of leftF and rightF
%   leftF = List of SIFT generated features of left image
%   rightF = List of SIFT generated features of right image
%   M = The number of affine transformation estimates to obtain
%   N = Given an estimated affine, the number of samples to obtain to check
%   for inliers
%   errorThresh = the pixel error threshold

% Keep track of the best affine transformation and the number of inliers
bestAffine = [];
maxInliers = 0;
for i = 1:M
    % Obtain estimated affine transformation
    affine = computeAffine(prunedMatches, leftF, rightF);
    numOfInliers = 0;
    
    r = randperm(size(prunedMatches,2),N);
    for j = 1:N
        % Finds the indexes of the coordinate pairings from the matches matrix
        indexOfLeftCoord = prunedMatches(1,r(j));
        indexOfRightCoord = prunedMatches(2,r(j));

        % Obtain the coordinate pairs from the feature matrix
        xL = leftF(1,indexOfLeftCoord);
        yL = leftF(2,indexOfLeftCoord);
        xR = rightF(1,indexOfRightCoord);
        yR = rightF(2,indexOfRightCoord);
        
        % Build A matrix
        A = [xL yL 0 0 1 0;
             0 0 xL yL 0 1];
        
        % Get estimated result 
        b = A*affine;
        
        xError = abs(b(1)-xR);
        yError = abs(b(2)-yR);
        
        % Check if coordinate is within error threshold, if so, consider it
        % an inlier
        if (xError < errorThresh) && (yError < errorThresh)
            numOfInliers = numOfInliers+1;
        end
    end
    if numOfInliers > maxInliers
        bestAffine = affine;
    end
end

% Compute affine based on all inliers of best set
Ap = zeros(2*size(prunedMatches,2),6);
bp = zeros(2*size(prunedMatches,2),1);
for i = 1:size(prunedMatches,2)
    % Finds the indexes of the coordinate pairings from the matches matrix
    indexOfLeftCoord = prunedMatches(1,i);
    indexOfRightCoord = prunedMatches(2,i);

    % Obtain the coordinate pairs from the feature matrix
    xL = leftF(1,indexOfLeftCoord);
    yL = leftF(2,indexOfLeftCoord);
    xR = rightF(1,indexOfRightCoord);
    yR = rightF(2,indexOfRightCoord);

    % Build A matrix
    A = [xL yL 0 0 1 0;
         0 0 xL yL 0 1];

    % Get estimated result 
    b = A*bestAffine;

    xError = abs(b(1)-xR);
    yError = abs(b(2)-yR);

    % Check if coordinate is within error threshold, if so, consider it
    % an inlier
    if (xError < errorThresh) && (yError < errorThresh)
        % Build A matrix
        Ap((2*i-1):2*i,:) = [xL yL 0 0 1 0;
                            0 0 xL yL 0 1];
        % Build b matrix
        bp((2*i-1):2*i) = [xR; yR];
    end
end

% Obtain affine transformation matrix
bestAffine  = Ap\bp;

end

