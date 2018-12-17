function homography_testing
get_marker_homography(imread('testing/media/photo8.jpg'),imread('marker2.jpg'))
% [cropped_marker, cropped_photo] = get_cropped_images(imread('marker2.jpg'),imread('testing/media/photo8.jpg'));
% get_marker_homography(cropped_photo,cropped_marker)