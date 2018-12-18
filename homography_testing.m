function homography_testing

image = im2double(imread('testing/media/photo9.jpg'));
marker = im2double(imread('marker2.jpg'));
transform = get_marker_homography(image,marker);
mask = zeros(size(image));  
one = ones(size(marker));
comp = logical(composite_images(mask, one, transform.T));
stats = regionprops(comp(:,:,1),'centroid');
offset = stats.Centroid;
