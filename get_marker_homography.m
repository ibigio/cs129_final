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

originalLocations = matchedPtsOriginal.Location;
distortedLocations = matchedPtsDistorted.Location;

image_ok_x = originalLocations(:,1);
image_ok_y = distortedLocations(:,2);

marker_ok_x = originalLocations(:,1);
marker_ok_y = distortedLocations(:,2);

[min_x1, leftIndex] = min(image_ok_x);
[max_x1, rightIndex] = max(image_ok_x);
[min_y1, topIndex] = min(image_ok_y);
[max_y1, botIndex] = max(image_ok_y);
% cropped_im1 = imcrop(im1, [min_x1, min_y1, max_x1-min_x1, max_y1-min_y1]);
% cropped_im2 = imcrop(input_img,...
%     [marker_ok_x(leftIndex), marker_ok_y(topIndex), ...
%     marker_ok_x(rightIndex)-marker_ok_x(leftIndex), ...
%     marker_ok_y(botIndex)-marker_ok_y(topIndex)]);
% figure(909);
% imshow(cropped_im2)
% im2_mask = zeros(size(im2g));
% im2_mask(:,x2_ok(leftIndex):x2_ok(rightIndex)) = 1;
% im2_mask(y2_ok(topIndex):y2_ok(botIndex),:) = im2_mask(y2_ok(topIndex):y2_ok(botIndex),:) + 1;
% im2_mask = im2_mask > 1;


[transform,~,~] = ...
    estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,...
    'projective');

outputView = imref2d(size(input_img));
Ir = imwarp(marker,transform,'OutputView',outputView);
figure; imshow(Ir); 
title('DEBUG OUTPUT: image after transform applied');
end

