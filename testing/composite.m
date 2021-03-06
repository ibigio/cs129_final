% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Simple form of compositing two images by averaging the
% overlap region.

function [ out mask ] = composite(imgA, imgB, maskA, maskB)
    [h1, w1, d1] = size(imgA);
    [h2, w2, d2] = size(imgB);
    h_max = max(h1, h2);
    w_max = max(w1, w2);

    out1 = zeros(h_max,w_max,3);
    out2 = out1;
    mask1 = out1;
    mask2 = out1;

    out1(1:h1,1:w1,:) = imgA;
    out2(1:h2,1:w2,:) = imgB;
    mask1(1:h1,1:w1,:) = maskA;
    mask2(1:h2,1:w2,:) = maskB;
    overlap = mask1 & mask2;
    
    out = imblend(out2, mask2, out1);
    %out = (out1 .* ~overlap) + out2;
    %out = (out1 + out2) .* ~overlap + (((out1 + out2) / 2) .* overlap);
    mask = mask1 | mask2;
end

