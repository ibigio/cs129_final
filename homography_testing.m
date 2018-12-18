function homography_testing

image = im2double(imread('testing/media/photo9.jpg'));
marker = im2double(imread('marker2.jpg'));
transform = get_marker_homography(image,marker);

[im1,im2,mask1,mask2] =  warp_image(marker, image, inv(transform.T), 0);
figure;
imshow(im2)


% mask = zeros(size(image));  
% one = ones(size(marker));
% comp = logical(composite_images(mask, one, transform.T));
% totalArea = bwarea(comp(:,:,1));
% halfWindowWidth = floor(1.3*sqrt(totalArea)/2);
% stats = regionprops(comp(:,:,1),'centroid');
% 
%  center= stats.Centroid;
%  centerX = center(1);
%  centerY = center(2);
%  
%  rect = [centerX-halfWindowWidth, centerY-halfWindowWidth, halfWindowWidth*2, halfWindowWidth*2];
%  
%  cutout = imcrop(image, rect);
% 
% imshow(cutout);




