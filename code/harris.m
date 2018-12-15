% Sample code for detecting Harris corners, following 
% Brown et al, CVPR 2005
%        by Alyosha Efros, so probably buggy...
%
% Taken from CMU Computational Photography web page
% by Patrick Doran on April 4th, 2010.
%

function [x,y,v] = harris(imrgb, border)
    im = im2double(rgb2gray(imrgb));
    g1 = fspecial('gaussian', 9,1);  % Gaussian with sigma_d 
    g2 = fspecial('gaussian', 11,1.5); % Gaussian with sigma_i 

    img1 = conv2(im,g1,'same');  % blur image with sigma_d
    Ix = conv2(img1,[-1 0 1],'same');  % take x derivative 
    Iy = conv2(img1,[-1;0;1],'same');  % take y derivative

    % Compute elements of the Harris matrix H
    %%% we can use blur instead of the summing window
    Ix2 = conv2(Ix.*Ix,g2,'same');
    Iy2 = conv2(Iy.*Iy,g2,'same');
    IxIy = conv2(Ix.*Iy,g2,'same');
    R = (Ix2.*Iy2 - IxIy.*IxIy) ... % det(H) 
        ./ (Ix2 + Iy2 + eps);       % trace(H) + epsilon

    % don't want corners close to image border
    R([1:border, end-border-1:end], :) = 0;
    R(:,[1:border,end-border-1:end]) = 0;
    max_r = max(R(:));
    R(R < 0.05 * max_r) = 0;

    % non-maxima supression within 3x3 windows
    nonmax = inline('max(x)');
    Rmax = colfilt(R,[3 3],'sliding',nonmax); % find neighbrhood max
    Rnm = R.*(R == Rmax);  % supress non-max

    % extract all interest points
    [y,x,v] = find(Rnm);

    % Get orientation
    g3 = fspecial('gaussian', 33,4.5); % Gaussian with sigma_o
    img3 = conv2(im,g3,'same'); % blur image with sigma_o
    Ix3 = conv2(img3,[-1 0 1],'same');
    Iy3 = conv2(img3,[-1;0;1],'same');
    inds = sub2ind(size(img3),y,x);
    U = [ Ix3(inds) Iy3(inds)];
    U = normr_1290(U);
    o = atan2(U(:,1),U(:,2));
    o = rad2deg(o);

end

