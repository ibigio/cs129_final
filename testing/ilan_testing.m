%frame = im2double(imread('media/test_frame_small.jpg'));
frame = im2double(imread('media/photo9.jpg'));
marker = im2double(imread('media/marker.JPG'));
cover = im2double(imread('media/cover.JPG'));

imshow(frame)

s_f = size(frame);
s_m = size(marker);
s_c = size(cover);
% T = load('T.mat');
% T = T.T;

transform = get_marker_homography(frame, marker);
T = transform.T;

imshow(frame)

%     B = frame;
%     tform = projective2d(inv(T));
%     [im2, RB] = imwarp(B,tform);
%     imshow(im2)
%     crop = im2(1:100, 1:100);
%     imshow(crop)

[ im1, im2 , mask1, mask2] = warp_image(marker, frame, inv(T), 0);
imshow(im2);
    crop = im2(1:100, 1:100);
    %imshow(crop)

% [ im1, im2 , mask1, mask2] = warp_image(A, B, T, mode, mask_pano);
% 
% test = composite_images(frame, cover, T);
% imshow(test);

