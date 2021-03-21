function [SI] = stitch(LI, RI, pruneVal)
%STITCH Stitches two images into a composite
%   Given two images that have been warped to each other, stitch them
%   together

[leftF, rightF, prunedMatches] = sift(single(rgb2gray(LI)), single(rgb2gray(RI)), pruneVal);

% Obtain the coordinates of all matched features
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

% Get the median difference in coordinate values
diffX = median(xL-xR);
diffY = median(yL-yR);

% Get the pixel shift value
xShift = round(abs(diffX));
yShift = round(abs(diffY));

% Pad image to the left with zeros
if diffX > 0
    RI = pagetranspose(padarray(pagetranspose(RI),xShift,0,'pre'));
else
    LI = pagetranspose(padarray(pagetranspose(LI),xShift,0,'pre'));
end

% Pad image on top with zeros
if diffY > 0
    RI = padarray(RI,yShift,0,'pre');
else
    LI = padarray(LI,yShift,0,'pre');
end

% Pad images to the right and bottom with zeros
[rowsLI, colsLI, ~] = size(LI);
[rowsRI, colsRI, ~] = size(RI);
if(rowsLI>rowsRI)
    RI = padarray(RI,rowsLI-rowsRI,0,'post');
else
    LI = padarray(LI,rowsRI-rowsLI,0,'post');
end

if(colsLI>colsRI)
    RI = pagetranspose(padarray(pagetranspose(RI),colsLI-colsRI,0,'post'));
else
    LI = pagetranspose(padarray(pagetranspose(LI),colsRI-colsLI,0,'post'));
end

% Build composite image
SI = zeros(size(LI,1,2,3));
LIG = rgb2gray(LI);
RIG = rgb2gray(RI);

% Populate composite image by laying both images on top of each other and
% getting the max value per pixel
for i = 1:size(SI,1)
    for j = 1:size(SI,2)
        if(LIG(i,j)>RIG(i,j))
            SI(i,j,:) = LI(i,j,:);
        else
            SI(i,j,:) = RI(i,j,:);
        end
    end
end
end

