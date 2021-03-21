function [bestHomo] = RansacHomoEst(prunedMatches,leftF,rightF,M,N,errorThresh)
%RANSACHOMOEST Uses RANSAC to determine best homography transformation
%   matches = the feature matching of leftF and rightF
%   leftF = List of SIFT generated features of left image
%   rightF = List of SIFT generated features of right image
%   M = The number of affine transformation estimates to obtain
%   N = Given an estimated affine, the number of samples to obtain to check
%   for inliers
%   errorThresh = the pixel error threshold

% Keep track of the best homography transformation and the number of inliers
bestHomo = [];
maxInliers = 0;
for i = 1:M
    % Obtain estimated homography transformation
    homography = computeHomography(prunedMatches, leftF, rightF);
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
        
        % Get estimated result 
        H = reshape(homography,[3,3])';
        b = H*[xL;yL;1];
        
        xError = abs((b(1)/b(3))-xR);
        yError = abs((b(2)/b(3))-yR);
        
        % Check if coordinate is within error threshold, if so, consider it
        % an inlier
        if (xError < errorThresh) && (yError < errorThresh)
            numOfInliers = numOfInliers+1;
        end
    end
    if numOfInliers > maxInliers
        bestHomo = H;
    end
end

% Compute homography based on all inliers of best set
Ap = zeros(2*size(prunedMatches,2),9);
for i = 1:size(prunedMatches,2)
    % Finds the indexes of the coordinate pairings from the matches matrix
    indexOfLeftCoord = prunedMatches(1,i);
    indexOfRightCoord = prunedMatches(2,i);

    % Obtain the coordinate pairs from the feature matrix
    xL = leftF(1,indexOfLeftCoord);
    yL = leftF(2,indexOfLeftCoord);
    xR = rightF(1,indexOfRightCoord);
    yR = rightF(2,indexOfRightCoord);

    % Get estimated result
    b = bestHomo*[xL;yL;1];

    xError = abs((b(1)/b(3))-xR);
    yError = abs((b(2)/b(3))-yR);

    % Check if coordinate is within error threshold, if so, consider it
    % an inlier
    if (xError < errorThresh) && (yError < errorThresh)
        % Build A matrix
        Ap((2*i-1):2*i,:) = [xL yL 1 0 0 0 -xR*xL -xR*yL -xR;
                            0 0 0 xL yL 1 -yR*xL -yR*yL -yR];
    end
end

% Obtain homography transformation matrix
[~, ~, V] = svd(Ap);
bestHomo = V(:,end);

end

