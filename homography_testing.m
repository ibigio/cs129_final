function homography_testing
% [cropped_marker, cropped_photo, photo_mask] = get_cropped_images(imread('marker2.jpg'),imread('testing/media/photo9.jpg'));
image = im2double(imread('testing/media/photo9.jpg'));
marker = im2double(imread('marker2.jpg'));
transform = get_marker_homography(image,marker);

o = composite_images(image, marker, transform.T);

figure(100);
imshow(o);
% get_marker_homography(cropped_photo,cropped_marker)