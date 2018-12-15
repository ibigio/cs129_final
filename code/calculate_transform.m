% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Given a set of corresponding points, find the least square solution 
% of the homography that transforms between them. 
%
%
% X1:           x location of the correspondence points in image A
% Y1:           y location of the correspondence points in image A
% X2:           x location of the correspondence points in image B
% Y2:           y location of the correspondence points in image B
%
%
% T:            the calculated homography (|3|x|3| matrix)

function T = calculate_transform(X1, Y1, X2, Y2)

    % Placeholder code
    T = [1 0 0; 0 1 0; 0 0 1];

end