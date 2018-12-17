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
    itters = 1000;
    err = 0.5;
    num_points = numel(X1);
    num_corrs = 4;
    max_inliers = 0;
    
    for i=1:itters
        % Random sample
        r = randsample(num_points, num_corrs);
        
        % Transform
        T = calculate_transform(X1(r), Y1(r), X2(r), Y2(r));
        
        % Estimate output with transform and input points
        mXY = [X2 Y2 ones(num_points,1)] * T;
        mXY = mXY ./ mXY(:,3);
        
        % Compare estimated and real output
        dist = (mXY(:,1:2) - [X1 Y1]).^2;
        inliers = sum(dist(:) <= err^2);
        
        % Update best
        if inliers > max_inliers
            max_inliers = inliers;
            model = T;
        end    
    end
end