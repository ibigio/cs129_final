frame = im2double(imread('media/test_frame_small.jpg'));
marker = im2double(imread('media/marker.JPG'));
cover = im2double(imread('media/cover.JPG'));

s_f = size(frame);
s_m = size(marker);
s_c = size(cover);

load T.mat;

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

[ im1, im2 , mask1, mask2] = warp_image(A, B, T, mode, mask_pano);

test = composite_images(frame, cover, T);
imshow(test);

