function [ patch ] = get_patch_to_insert_synthesis( method, tilesize, overlapsize, to_fill, to_fill_mask, texture, border)
% Texture Synthesis stencil code
% Written by Emanuel Zgraggen for CS 129 Computational Photography, Brown U.
%
% method:       1 = random, 2 = best ssd, 3 = best ssd + min cut
% tilesize:     size of the tiles to use (patch size)
% overlapsize:  size of the overlap region (same in each direction -> right
%               and above)
% to_fill:      patch of the synthesized image at current location
% to_fill_mask: mask of the synthesized image at current patch location 
% texture:      texure image
%
% patch:        patch of size |tilesize|x|tilesize|x|channels| that 
%               will be inserted at current location (needs to inlcude to
%               overlap region. 


% random patch
if method == 1
    [sample, y, x] = get_random_img_patch(texture, tilesize); 
    patch = sample;
end

% best ssd patch
if method == 2
    patch = get_ssd_patch(tilesize, 200, to_fill, to_fill_mask, texture, 0.2);
end

% best ssd patch + min cut
if method == 3    
    base_patch = get_ssd_patch(tilesize, 200, to_fill, to_fill_mask, texture, 0.2, border);
    % vertical and horizontal overlaps
    diffs = (to_fill - base_patch).^2;
    
    vo = diffs(1:overlapsize,:,:);
    ho = diffs(:,1:overlapsize,:);
    
    v_seam = get_min_seam(vo,2);
    h_seam = get_min_seam(ho,1);
    
     seam_mask = ones(tilesize);
     for i=1:size(v_seam,1)
         seam_mask(h_seam(i,1),1:h_seam(i,2)-1) = 0;
         seam_mask(1:v_seam(i,1)-1,v_seam(i,2)) = 0;
     end
    
    patch = (1 - seam_mask) .* to_fill + (seam_mask).* base_patch;
    
end

end

function [ patch ] = get_ssd_patch(tilesize, reps, to_fill, to_fill_mask, texture, tolerance, border)
    min_diff = inf;
    coords = [0,0];
    for i=1:reps
        [sample, y, x] = get_random_img_patch(texture, tilesize, border);
        
        diff_mat = ((sample - to_fill) .* to_fill_mask) .^ 2;
        diff = sum(diff_mat(:));
        if diff < min_diff * (1 + tolerance)
            min_diff = diff;
            coords = [y,x];
        end
    end
    patch = texture(coords(1):coords(1) + tilesize - 1, coords(2):coords(2) + tilesize - 1, :);
end
