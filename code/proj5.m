% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.

warning('off','MATLAB:singularMatrix');
warning('off','Matlab:nearlySingularMatrix');

imgdir = '../data/';
outdir = '../results';
N = 2; %defaulting to run only on the first two of eight test sets

for i = 1:N
    close all;
    
    prefix = sprintf('source%03d',i);
    files = dir(sprintf('%s/%s/*.jpg',imgdir,prefix));
    
    display(sprintf('-------'));
    display(sprintf('Processing files in %s:', prefix));
    
    T = length(files);
    filenames = cell(T,1);
    for j = 1:T
        filenames{j} = sprintf('%s/%s/%s',imgdir,prefix,files(j).name);
    end
    
    
%     For STEP 5: Prewarp the images into spherical images.
%     Leave this section commented out until you finish normal stitching.
%     Then, uncomment this section, and run the code using the images from
%     imgCell instead.
%
%     When you get to this step, consider which image-space transform is 
%     now needed---we might not need to estimate a homography. 
%     Write two code paths with a switch for planar/spherical as needed.
% 
%     focal_len = 500;
%     imgCell = cell(T,1);
%     for j = 1:length(filenames)
%         img = im2double(imread(filenames{j}));
%         imgCell{j} = spherical_conversion(img, focal_len);
%     end
    

    % loop over all input image and combine 
    A = im2double(imread(filenames{1}));
    for j = 2:length(filenames)
        B = im2double(imread(filenames{j}));
        
        % STEP 1: Define correspondences between the 2 images
        % This is computed for you.
        tstart = tic;
        display(sprintf('Calculating potential correspondences... '));
        patch_size = 40;
        [X1 Y1 X2 Y2] = define_correspondence(A, B, patch_size);
        show_correspondence(A, B, X1, Y1, X2, Y2);
        display(sprintf('\bdone in %1.3f', toc(tstart)));
                
        % STEP 2: Find best Homography using RANSAC
        % You must implement this.
        % ransac() should call calculate_transform() to estimage a homography H
        tstart = tic;
        display(sprintf('Starting RANSAC of feature points... '));
        T = ransac(X1, Y1, X2, Y2);
        display(sprintf('\bdone in %1.3f', toc(tstart)));
                
        % STEP 3:  Warp both images into new image space
        % You must implement this.
        tstart = tic;
        display(sprintf('Warping second image to first... '));
        [ warpedA warpedB ] = warp_image(A, B, T);
                
        % STEP 4: Composite the two warped images
        % You must implement this.
        tstart = tic;
        display(sprintf('Compositing... '));
        [ panorama ] = composite(warpedA, warpedB);
        display(sprintf('\bdone in %1.3f', toc(tstart)));

        
        % set the current combined image as the first image (A)
        % for the next iteration
        A = panorama;
    end 
    
    figure;
    imshow(panorama);
    imwrite(panorama,sprintf('%s/panorama%03d.jpg',outdir,i));
end
