function homography_testing
[cropped_marker, cropped_photo, photo_mask] = get_cropped_images(imread('marker2.jpg'),imread('testing/media/photo9.jpg'));
get_marker_homography(imread('testing/media/photo9.jpg'),imread('marker2.jpg'))
% get_marker_homography(cropped_photo,cropped_marker)