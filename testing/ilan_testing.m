frame = im2double(imread('media/test_frame_small.jpg'));
marker = im2double(imread('media/marker.JPG'));
cover = im2double(imread('media/cover.JPG'));

s_f = size(frame);
s_m = size(marker);
s_c = size(cover);

% Find Homography
%[ X1, Y1, X2, Y2 ] = define_correspondence( frame, marker, 20 );
%show_correspondence(frame, marker, X1, Y1, X2, Y2);
%T = ransac(X1, Y1, X2, Y2);

% Instead, just load homography:
load T.mat;

[ im1, im2 , mask1, mask2] = warp_image(frame, cover, T, 0);

[ out, mask ] = composite(im1, im2, mask1, mask2);

imshow(out);

