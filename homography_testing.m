function homography_testing
% [cropped_marker, cropped_photo, photo_mask] = get_cropped_images(imread('marker2.jpg'),imread('testing/media/photo9.jpg'));
% image = im2double(imread('testing/media/photo9.jpg'));
% figure(1)
% imshow(photo_mask);


image = im2double(imread('testing/media/photo9.jpg'));
marker = im2double(imread('marker2.jpg'));
transform = get_marker_homography(image,marker);
% imshow(composite_images(image, marker, transform.T));

mask = zeros(size(image));  
one = ones(size(marker));
comp = logical(composite_images(mask, one, transform.T));
stats = regionprops(comp(:,:,1),'centroid');
offset = stats.Centroid



% get_marker_homography(cropped_photo,cropped_marker)