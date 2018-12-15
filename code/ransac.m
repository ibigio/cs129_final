% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Run RANSAC to recover the homography. 
%
%
% X1:           x location of the correspondence points in image A
% y1:           y location of the correspondence points in image A
% X1:           x location of the correspondence points in image B
% Y1:           y location of the correspondence points in image B
%
%
% model:        the recovered homography (|3|x|3| matrix)

function [model] = ransac(X1, Y1, X2, Y2)
    % your code here.
    % use (and implement) calculate_transform to calculate a homography
    % between many random sets of points. 
    % return the homography with the most inliers.

    %placeholder
    model = [1 0 -50; ...
             0 1 -50; ...
             0 0 1];

end