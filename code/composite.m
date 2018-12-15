% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Simple form of compositing two images by averaging the
% overlap region. 

function [ out ] = composite(imgA, imgB)
    
    % Hint: we might consider generating some masks first...
    % Then we can composite.
    
    % Placeholder code
    imgA1 = imresize(imgA, [size(imgB,1) size(imgB,2)]);
    out = imgA1 + imgB;
end