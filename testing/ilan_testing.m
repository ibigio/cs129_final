frame = im2double(imread('media/test_frame_small.jpg'));
marker = im2double(imread('media/marker.JPG'));
cover = im2double(imread('media/cover.JPG'));

s_f = size(frame);
s_m = size(marker);
s_c = size(cover);


load T.mat;

test = composite_images(frame, cover, T);
imshow(test);

