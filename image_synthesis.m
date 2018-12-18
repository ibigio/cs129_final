function [ out ] = image_synthesis( input, outsize, tilesize, overlapsize, method, isdebug, border)
% Texture Synthesis stencil code
% Written by Emanuel Zgraggen for CS 129 Computational Photography, Brown U.
%
% input:        input texure image
% outsize:      size of result image
% tilesize:     size of the tiles to use (patch size)
% overlapsize:  size of the overlap region (same in each direction -> right
%               and above)
% texture:      texure image
% method:       1 = random, 2 = best ssd, 3 = best ssd + min cut
% isdebug:      debug flag
%
% out:          synthezied image of size |outsize(1)|x|outsize(2)|x|channels| that 


% do some calculation so that we have an easy time indexing
temp = tilesize - overlapsize;
imout = zeros(ceil(outsize(1) / temp) * temp + overlapsize, ceil(outsize(2) / temp) * temp + overlapsize, size(input, 3));
imout_mask = logical(zeros(ceil(outsize(1) / temp) * temp + overlapsize, ceil(outsize(2) / temp) * temp + overlapsize));

if isdebug~=0
    h = imshow(imout);
end

for y=1:tilesize - overlapsize:outsize(1)
    for x=1:tilesize - overlapsize:outsize(2)
        % the patch of the result image that we want to fill
        to_fill = imout(y:y + tilesize - 1, x:x + tilesize - 1, :);
        
        % the current mask (includes right and above overlap)
        to_fill_mask = imout_mask(y:y + tilesize - 1, x:x + tilesize - 1);
        
        % get the patch we want to insert at current location 
        patch_to_insert = get_patch_to_insert_synthesis(method, tilesize, overlapsize, to_fill, to_fill_mask, input, border);
        
        % update result image and mask
        imout(y:y + tilesize - 1, x:x + tilesize - 1, :) = patch_to_insert;
        imout_mask(y:y + tilesize - 1, x:x + tilesize - 1) = 1; 
        
        if isdebug ~= 0
            set(h,'CData', imout);
            drawnow;
        end
    end
end

% crop the image to outsize
out = imcrop(imout, [0, 0, outsize(2), outsize(1)]);

end

