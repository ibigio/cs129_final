function homography_testing
% [cropped_marker, cropped_photo, photo_mask] = get_cropped_images(imread('marker2.jpg'),imread('testing/media/photo9.jpg'));
image = imread('testing/media/photo9.jpg');
marker = imread('marker2.jpg');
transform = get_marker_homography(image,marker);

composite_images(image, marker, transform.T);
% get_marker_homography(cropped_photo,cropped_marker)