function [ transform ] = get_marker_homography(input_img,marker)
%GET_MARKER_HOMOGRAPHY Finds homography between input_img and marker
%   
%   Inputs: 
%       - input_img :   input image with a marker somewhere in the frame
%       - marker :      marker to find in input_img
%
%   Output:
%       - transform :           the projective transform that takes marker to
%       input_img
% [marker, input_img] = get_cropped_images(marker,input_img);

marker = rgb2gray(marker);
input_img = rgb2gray(input_img);

ptsOriginal  = detectSURFFeatures(input_img);
ptsDistorted = detectSURFFeatures(marker);
[featuresOriginal,validPtsOriginal] = ...
    extractFeatures(input_img,ptsOriginal);
[featuresDistorted,validPtsDistorted] = ...
    extractFeatures(marker,ptsDistorted);

index_pairs = matchFeatures(featuresOriginal,featuresDistorted);
matchedPtsOriginal  = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));

[transform,~,~] = ...
    estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,...
    'projective');

outputView = imref2d(size(input_img));
Ir = imwarp(marker,transform,'OutputView',outputView);
figure; imshow(Ir); 
title('DEBUG OUTPUT: image after transform applied');
end

