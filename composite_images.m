function [ out_img ] = composite_images(base_img, comp_img, H)
%C         Composes comp_img onto base_img according to homography H, using
%          poisson blending for realism.
%
%   Inputs:
%       - base_img :    base image that composition will be done onto
%       - com_img :     image to compose onto base_img
%       - H :           homography between base_img and comp_img
%
%   Output:
%       - out_img :     final composition

    [ imgA, imgB , maskA, maskB] = warp_image(base_img, comp_img, H, 0);
    
    [h1, w1, d1] = size(imgA);
    [h2, w2, d2] = size(imgB);
    h_max = max(h1, h2);
    w_max = max(w1, w2);

    out1 = zeros(h_max,w_max,3);
    out2 = out1;
    mask2 = out1;

    out1(1:h1,1:w1,:) = imgA;
    out2(1:h2,1:w2,:) = imgB;
    mask2(1:h2,1:w2,:) = maskB;
    mask2 = imdilate(mask2, true(15));
    
    figure(20)
    imshow(out2);
    
    figure(30)
    imshow(out1)
    
    disp('Blending...')
    
    out_img = imblend(out2, mask2, out1);
end

