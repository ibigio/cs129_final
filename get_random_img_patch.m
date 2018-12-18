function [ patch, y, x ] = get_random_img_patch( img, tilesize, border)
% Texture Synthesis stencil code
% Written by Emanuel Zgraggen for CS 129 Computational Photography, Brown U.
%
% img:          image to draw patch from 
% tilesize:     size of the tiles to use (patch size)
%
% patch:        random patch of size |tilesize|x|tilesize|x|channels|
%               coming from img

if (randi(2) - 1)
    % x is free, y is constrained
    x = randi(size(img, 2) - tilesize);
    y = randi(border - tilesize) + (randi(2) - 1) * (size(img, 1) - border);
else
    % x is constrained, y is free
    y = randi(size(img, 1) - tilesize);
    x = randi(border - tilesize) + (randi(2) - 1) * (size(img, 2) - border);
end




patch = img(y:y + tilesize - 1, x:x + tilesize - 1, :);

end

