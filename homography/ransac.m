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

function [model] = ransac(A,B)
    A_inlier = zeros(1);
    B_inlier = zeros(1);
    max_match = 0;
    
    for i = 1:1000
        % Random sample
        random_indexes = randi(length(A),5,1);
        sample1 = A(random_indexes,:);
        sample2 = B(random_indexes,:);
        % get transform
        T = calculate_transform(sample1,sample2);
        
        % Calculate forward transform error
        im1Transformed = transformForward(A,T);
        sd = (im1Transformed-B).^2;
        ssdForward = sum(sd,2);
        
        % Calculate backward transform error
        im2Transformed = transformBackward(B,T);
        sd = (im2Transformed-A).^2;
        ssdBackward = sum(sd,2);
        
        % masking to get inliers
        inlier_mask1 = ssdForward<0.5;
        inlier_mask2 = ssdBackward<0.5;
        
        inliers_A = inlier_mask1.*A;
        inliers_B = inlier_mask2.*B;
        
        % get matching
        matched_inliers = inliers_A(:,1)>0 & inliers_B(:,1)>0; 
        num_inliers = nnz(matched_inliers); %number of NON ZERO inliers
        matched_A = inliers_A(matched_inliers,:); 
        matched_B = inliers_B(matched_inliers,:);
        
        % updating max
        if num_inliers > max_match
            A_inlier = matched_A;
            B_inlier = matched_B;
            max_match = num_inliers;
        end 
    end
    
    % Recover the transform from most matched inlier.
    model = calculate_transform(A_inlier,B_inlier);
end