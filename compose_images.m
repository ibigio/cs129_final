function [ out_img ] = compose_images(base_img,comp_img, H)
%UNTITLED4 Composes comp_img onto base_img according to homography H, using
%          poisson blending for realism.
%
%   Inputs:
%       - base_img :    base image that composition will be done onto
%       - com_img :     image to compose onto base_img
%       - H :           homography between base_img and comp_img
%
%   Output:
%       - out_img :     final composition

out_im = base_img;
end

