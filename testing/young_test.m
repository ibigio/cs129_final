image = im2double(imread('media/photo9.jpg'));
marker = im2double(imread('../marker2.jpg'));
texture = generate_fill_texture(image,marker);
imshow(texture)