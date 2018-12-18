function homography_testing

image = im2double(imread('testing/media/photo9.jpg'));
marker = im2double(imread('marker2.jpg'));
transform = get_marker_homography(image,marker);

mask = zeros(size(image));  
one = ones(size(marker));
comp = logical(composite_images(mask, one, transform.T));
totalArea = bwarea(comp(:,:,1));
windowWidth = floor(1.3*sqrt(totalArea));
stats = regionprops(comp(:,:,1),'centroid');

 center= stats.Centroid;
 centerX = center(1);
 centerY = center(2);
 
[rNum, cNum, ~] = size(image);
[yy, xx] = ndgrid((1:rNum)-centerY, (1:cNum)-centerX);

mask1 = xx < -windowWidth/2 | xx > windowWidth/2 | ...
    yy < -windowWidth/2 | yy > windowWidth/2;
mask1 = logical(1-mask1);
figure; imshow(mask1)
cutout = image.*mask1;



