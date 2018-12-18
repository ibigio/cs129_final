image = im2double(imread('/Users/youngzheng/Documents/GitHub/cs129_final/testing/media/photo8.jpg'));
marker = im2double(imread('marker2.jpg'));
texture = generate_fill_texture(image,marker);
imshow(texture)