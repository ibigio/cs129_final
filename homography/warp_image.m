% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Warps an img according to projective transfomation T

function [ im1, im2 , mask1, mask2] = warp_image(A, B, T, mode, mask_pano)
    
    mask1 = ones(size(A));
    mask2 = ones(size(B));
    
    if mode == 1
        mask1 = mask_pano;
    elseif mode == 2
        mask2 = mask_pano;
    end
    
    tform = projective2d(T);
    im1 = A;
    [im2, RB] = imwarp(B,tform);
    mask2 = imwarp(mask2,tform);
    
    XWL = round(RB.XWorldLimits(1));
    YWL = round(RB.YWorldLimits(1));
    
    if XWL > 0
        im2 = imtranslate(im2, [XWL, 0], 'FillValues',0,'OutputView','full');
        mask2 = imtranslate(mask2, [XWL, 0], 'FillValues',0,'OutputView','full');
    else
        im1 = imtranslate(im1, [-XWL, 0], 'FillValues',0,'OutputView','full');
        mask1 = imtranslate(mask1, [-XWL, 0], 'FillValues',0,'OutputView','full');
    end
    
    if YWL > 0
        im2 = imtranslate(im2, [0, YWL], 'FillValues',0,'OutputView','full');
        mask2 = imtranslate(mask2, [0, YWL], 'FillValues',0,'OutputView','full');
    else
        im1 = imtranslate(im1, [0, -YWL], 'FillValues',0,'OutputView','full');
        mask1 = imtranslate(mask1, [0, -YWL], 'FillValues',0,'OutputView','full');
    end
end