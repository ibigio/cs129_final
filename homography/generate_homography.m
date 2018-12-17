function generate_homography 
    im1 = imread('photo8.JPG') ;
    im2 = imread('marker.jpg') ;

    % make single
    im1 = im2single(im1) ;
    im2 = im2single(im2) ;

    % make grayscale
    if size(im1,3) > 1, im1g = rgb2gray(im1) ; else im1g = im1 ; end
    if size(im2,3) > 1, im2g = rgb2gray(im2) ; else im2g = im2 ; end

    % --------------------------------------------------------------------
    %                                                         SIFT matches
    % --------------------------------------------------------------------

    [f1,d1] = vl_sift(im1g) ;
    [f2,d2] = vl_sift(im2g) ;

    [matches, scores] = vl_ubcmatch(d1,d2) ;

    numMatches = size(matches,2) ;

    X1 = f1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
    X2 = f2(1:2,matches(2,:)) ; X2(3,:) = 1 ;

    x1 = X1(1,:);
    y1 = X1(2,:);
    x2 = X2(1,:);
    y2 = X2(2,:);
    
    pairs1 = zeros(length(x1),2);
    pairs1(:,1) = x1;
    pairs1(:,2) = y1;
    
    pairs2 = zeros(length(x2),2);
    pairs2(:,1) = x2;
    pairs2(:,2) = y2;
    
    T = ransac(pairs1, pairs2)
    [ warpedA warpedB maskA maskB] = warp_image(im1, im2, T, 0);
    figure(10)
    imshow(warpedA)
    figure(11)
    imshow(warpedB)
    
    
end
