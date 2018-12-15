clear;        
patch_size = 20;
homo_tracker = imread('marker2.jpg');
picture = imread('IMG_4684.jpg');


[X1 Y1 X2 Y2] = define_correspondence(homo_tracker, picture, patch_size);
show_correspondence(homo_tracker, picture, X1, Y1, X2, Y2);