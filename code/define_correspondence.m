% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Automatically computes a set of correspondence points between 
% two images.
%
% imgA:         input image A
% imgB:         input image B
% patch_size:   size of the area around an interest point that we will 
%               use to create a feature vector.
%
% X1:           x location of the correspondence points in image A
% y1:           y location of the correspondence points in image A
% X1:           x location of the correspondence points in image B
% Y1:           y location of the correspondence points in image B

function [ X1 Y1 X2 Y2 ] = define_correspondence( imgA, imgB, patch_size )
    % to make sure all points are within the patch_size
    border = patch_size / 2; 

    % harris will return a list of interest points 
    [xA yA] = harris(imgA, border); 
    [xB yB] = harris(imgB, border);
    
    % transform the interest points into feature vectors
    [featuresA] = get_features(imgA, xA, yA, patch_size);
    [featuresB] = get_features(imgB, xB, yB, patch_size);

    
    % Find out which feature in featuresA corresponds to which 
    % feature in featuresB. You can use dist2 to get the squared 
    % distance between two sets of points.
    
    D = dist2(featuresA, featuresB);

    [D index] = sort(D, 2);

    error = D(:,1) ./ D(:,2);

    FEATURE_ERROR = 0.2;
    MIN_NUM_MATCHES = 20;
    
    [e i] = sort(error);
    bestA = i(e < FEATURE_ERROR);
    if length(bestA) < MIN_NUM_MATCHES
        bestA = i(1:MIN_NUM_MATCHES);
    end
    bestB = index( bestA );

    X1 = xA(bestA);
    Y1 = yA(bestA);
    X2 = xB(bestB);
    Y2 = yB(bestB);
end
