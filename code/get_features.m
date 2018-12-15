% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Returns a set of feature descriptors for a given set of interest points. 
%
%
% img:          input image A
% x / y:        x and y locations of interest points
% patch_size:   area to compute the feature vector from ( should be
%               centered at x/y).
%
% features:     the list of computed features. should have the 
%               following dimension | length(x) | patch_size * patch_size| 

function [features] = get_features(img, x, y, patch_size)
    img = im2double(rgb2gray(img));

    % Choose center consistently (even width window)
    % Remember to apply a border parameter to harris and anms
    features = zeros(length(x), patch_size * patch_size);
    for i=1:length(x)
        winX = x(i)-patch_size/2 : x(i)+patch_size/2-1;
        winY = y(i)-patch_size/2 : y(i)+patch_size/2-1;

        feat = img(winY,winX,:); 
        feat = imresize(feat,[patch_size patch_size]);

        % "Standardize" the vector
        feat = (feat - mean(feat(:))) / std(feat(:));

        features(i,:) = feat(:);
    end
end