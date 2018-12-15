% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Visualizes corresponding points between two images. 

function [ h ] = show_correspondence(imgA, imgB, X1, Y1, X2, Y2)
    h = figure;
    subplot(1,2,1);
    imshow(rgb2gray(imgA))
    hold on;
    plot(X1,Y1,'ro');
    hold off;
    subplot(1,2,2);
    imshow(rgb2gray(imgB))
    hold on;
    plot(X2,Y2,'ro');
    hold off;
end
