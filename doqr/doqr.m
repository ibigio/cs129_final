clear all
close all
% QR code finder.  We assume we have a "version 2" type code.
% See http://en.wikipedia.org/wiki/QR_code for details.
% The code is size 25x25 units.  The 3 big marker patterns are located at
% (x,y): (4,4), (22,4), (4,22).  The small alignment pattern is at (19,19).

movieObj = VideoReader('qr1.wmv'); % open file
%images = read(movieObj, [51 100]);    % get selected images
images = read(movieObj);    % get all images
nImg = size(images,4);      % Number of images read
fprintf('Read in %d images from video files\n', nImg);

% % This code makes a movie
% movieOut = VideoWriter('mymovie.avi');
% open(movieOut);

H = size(images,1);     % Height of image
W = size(images,2);     % Width of image
D = 1;                  % Only process every (2D+1)th row or column

for iImg=1:nImg
    Irgb = images(:,:,:,iImg);     % Get next image
    
    I = rgb2gray(Irgb);
    
    % Do local thresholding, by subtracting a local averaged image
    I2 = double(I);
    sigma = H/25;
    I3 = I2 - imfilter(I2, fspecial('gaussian', round(6*sigma), sigma));
    BW = I3>0;  % Now the threshold is zero
        
    % We will need connected component labeling to verify targets
    L = bwlabel(~BW);  % Find all black blobs
    blobsBlack = regionprops(L);
    
    % Look horizontally, for the finder symbol pattern (black, white,
    % black, white, black), where the sizes are 1,1,3,1,1.
    Idetect = false(H,W);
    for y=1:(2*D+1):H
        % Keep track of state:
        %   1 = black 2 = white 3 = black 4 = white 5 = black
        mystate = 1;
        stateCount = zeros(1,5);  % Number of pixels in each type
        blobLabel = zeros(1,5);   % Labels of regions
        
        for x=1:W
            if BW(y,x) && ~Idetect(y,x)
                % We are at a white pixel
                if mod(mystate,2) == 0
                    % We were counting white pixels
                    stateCount(mystate) = stateCount(mystate) + 1;
                else
                    % We were counting black pixels
                    if mystate == 5
                        % We may have a finder pattern - check the ratio of
                        % counts
                        if checkRatio(stateCount)
                            % Found a potential finder pattern at (xc,y)
                            xc = x - stateCount(5) - stateCount(4) - round(stateCount(3)/2);
                            
                            % Verify presence of pattern; get location
                            [fFoundit, x0, y0] = doVerify(BW, xc, y);
                            if fFoundit
                                % Once more check - the outer black ring
                                % (region 1) must surround the inner black
                                % ring (region 3).
                                i1 = blobLabel(1);  % label for region 1
                                i3 = blobLabel(3);  % label for region 3
                                bb1 = blobsBlack(i1).BoundingBox;
                                bb3 = blobsBlack(i3).BoundingBox;
                                
                                if bb1(1)<bb3(1) && bb1(2)<bb3(2) && ...
                                        bb1(1)+bb1(3)>bb3(1)+bb3(3) && ...
                                        bb1(2)+bb1(4)>bb3(2)+bb3(4)
                                    % Ok, everything looks good
                                    Idetect(y0-D:y0+D,x0) = true;
                                    mystate = 1;
                                    stateCount = zeros(1,5);
                                    blobLabel = zeros(1,5);
                                end
                            end
                            
                        else
                            % Not valid, shift and keep looking
                            mystate = 4;
                            stateCount(1) = stateCount(3);
                            stateCount(2) = stateCount(4);
                            stateCount(3) = stateCount(5);
                            stateCount(4) = 1;
                            stateCount(5) = 0;
                            
                            blobLabel(1) = blobLabel(3);
                            blobLabel(2) = blobLabel(4);
                            blobLabel(3) = blobLabel(5);
                            blobLabel(4) = 0;
                            blobLabel(5) = 0;
                        end
                    else
                        mystate = mystate + 1;
                        stateCount(mystate) = stateCount(mystate) + 1;
                    end
                end
            else
                % We are at a black pixel
                if mod(mystate,2) == 0
                    % We were counting white pixels
                    mystate = mystate + 1;
                end
                blobLabel(mystate) = L(y,x);
                stateCount(mystate) = stateCount(mystate) + 1;
            end
        end
    end
    
    % Ok, image Idetect holds the detections.  However, we may have
    % multiple hits for each target.  Do connected component labeling (blob
    % detection) so that we just get one detection for each blob.
    Idetect = imdilate(Idetect, strel('disk', 2));
    [Ld, nTargets] = bwlabel(Idetect);
    blobs = regionprops(Ld);
    
    % Get centroids of all targets found
    cTarget = zeros(nTargets,2);
    for i=1:nTargets
        cTarget(i,:) = blobs(i).Centroid;
    end    
    
    if nTargets ~= 3    
        % Couldn't find the targets ... display image anyway
        imshow(I, []);
        % Display image number    
        text(20,H-20,sprintf('%d',iImg),'Color','k','BackgroundColor','w');
        drawnow;
        
%         newFrameOut = getframe;
%         % Make sure we didn't grab any extra rows or columns
%         newFrameOut.cdata = newFrameOut.cdata(1:H, 1:W, :);
%         writeVideo(movieOut,newFrameOut);
        continue;
    end
    
    % Sort targets in the order   1---2
    %                             | /
    %                             3
    % First get distance between every pair.
    distances = zeros(3,3);
    for i1=1:nTargets
        for i2=i1+1:nTargets
            d12 = norm(cTarget(i1,:)-cTarget(i2,:));
            distances(i1,i2) = d12;
        end
    end
    [i2,i3] = find( distances == max(distances(:)) );
    allids = 1:3;
    i1 = find( ~(allids==i2 | allids==i3) );    % Get remaining id
    % Switch i2 and i3 if necessary
    A = [ cTarget(i1,:) 1;
          cTarget(i2,:) 1;
          cTarget(i3,:) 1 ];
    if det(A) < 0
        iTemp = i3;
        i3 = i2;
        i2 = iTemp;
    end
    
    % Ok, if we got here, we found the three targets.  The coordinates are
    % in cTarget(3,2).  The order is given by the indices i1,i2,i3, where
    % the order is   1---2
    %                | /
    %                3
    

    % Look for alignment marker.  It should be a small dark dot surrounded
    % by a white region.  It should be centered at these coordinates:
    %  x=19/22, y=19/22, where 1.0 is the distance between the main 3
    %  targets.
    vx = cTarget(i2,:) - cTarget(i1,:);
    vy = cTarget(i3,:) - cTarget(i1,:);
    pAlign = cTarget(i1,:) + (19/22)*vx + (19/22)*vy;
    wAlign = (7/22)*max(norm(vx), norm(vy));    % size of search region 
    Lc = imcrop(L, [pAlign(1)-wAlign/2 pAlign(2)-wAlign/2 wAlign wAlign]);
    blobIndices = unique(Lc(Lc>0));     % Indices of blobs in search region
    areas = cat(1,blobsBlack(blobIndices).Area);    % Their areas
    [~,i] = min(areas);     % Smallest blob
    pMarker = blobsBlack(blobIndices(i)).Centroid;
    
    % Fit a projective transform to targets.
    % Multiply the desired 25x25 pattern by 5.
    pMod = [                % model points
        20,20;  % (4,4)
        110,20; % (22,4)
        20,110; % (4,22)
        95,95]; % (19,19)
    pImg = [
        cTarget(i1,:);
        cTarget(i2,:);
        cTarget(i3,:);
        pMarker];
    %tform = cp2tform(pImg,pMod,'projective');
    tform = maketform('projective',pImg,pMod);
    Iqrcode = imtransform(I,tform, ...
        'XData', [1 125], 'YData', [1 125] );
    % Insert the qrcode image into the original image
    I(1:125, 1:125) = Iqrcode;
    
%     % Fit an affine transformation to targets.
%     pMod = [30; 30;   100; 30;  30; 100]; % model points (x1;y1; x2;y2; x3;y3)
%     pImg = [cTarget(i1,:); cTarget(i2,:); cTarget(i3,:)];
%     
%     % Calculate the transformation T from image to model; ie pMod = T pImg.
%     A = zeros(2*3,6);
%     for i=1:3
%         A( 2*(i-1)+1, :) = [ pImg(i,1)  pImg(i,2)  0       0       1  0];
%         A( 2*(i-1)+2, :) = [ 0        0        pImg(i,1) pImg(i,2) 0  1];
%     end
%     b = pMod;
%     x = A\b;
%     
%     T = [ x(1)  x(2)    x(5);
%         x(3)  x(4)    x(6);
%         0     0       1];
% 
%     % Ok, apply the transformation to the image to align it to the model.
%     % We'll use Matlab's imtransform function.
%     tform = maketform('affine', T');
%     Iqrcode = imtransform(I,tform, ...
%         'XData', [1 130], 'YData', [1 130] );
%         
%     % Insert the qrcode image into the original image
%     I(1:130, 1:130) = Iqrcode;
    
    imshow(I, []);
    % Display image number    
    text(20,H-20,sprintf('%d',iImg),'Color','k','BackgroundColor','w');

    % Draw targets (1=red, 2=green, 3=yellow)
    rectangle('Position', [cTarget(i1,1)-5 cTarget(i1,2)-5 10 10],'FaceColor','r');
    rectangle('Position', [cTarget(i2,1)-5 cTarget(i2,2)-5 10 10],'FaceColor','g');
    rectangle('Position', [cTarget(i3,1)-5 cTarget(i3,2)-5 10 10],'FaceColor','y');
    
    % Draw location of alignment marker (blue)
    rectangle('Position', [pMarker(1)-4 pMarker(2)-4 8 8], 'FaceColor', 'b');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find the pose of the target.
    K = [ 528 0 325;        % Camera intrinsics (assume no lens dist)
        0  528 234;
        0   0   1];
    Kinv = inv(K);

    % This is a P4P problem (pose from 4 points)
    p1 = Kinv*[cTarget(i1,:) 1]';   % Normalized image coords
    p2 = Kinv*[cTarget(i2,:) 1]';
    p3 = Kinv*[cTarget(i3,:) 1]';
    p4 = Kinv*[pMarker 1]';
    P1 = [4;  4; 0];                % Points in model coords
    P2 = [22; 4; 0];
    P3 = [4; 22; 0];
    P4 = [19;19; 0];
    
    % Use Hung-Yeh-Harwood algorithm
    d12 = norm(P2-P1);  % distance from 1 to 2
    u12 = (P2-P1)/d12;  % unit vector from 1 to 2
    d13 = norm(P3-P1);  % distance from 1 to 3
    u13 = (P3-P1)/d13;  % unit vector from 1 to 3
    
    % Point 4 can be expressed in terms of the other 3 points;
    % ie (P4-P1) = a*u12 + b*u13
    a = dot(u12, P4-P1);
    b = dot(u13, P4-P1);
    
    % Let P1=k1*p1, P2=k2*p2, P3=k3*p3, P4=k4*p4.
    % Then  P4-P1 = a*u12 + b*u13 = a*(P2-P1)/d12 + b*(P3-P1)/d13
    % or    k4*p4-k1*p1 = (a/d12)*(k2*p2-k1*p1) + (b/d13)*(k3*p3-k1*p1)
    %       m4*p4-p1 = (a/d12)*(m2*p2-p1) + (b/d13)*(m3*p3-p1)
    %  where m4=k4/k1, m3=k3/k1, m2=k2/k1
    % Collecting terms:
    % (a/d12)*m2*p2 + (b/d13)*m3*p3 - m4*p4 = (a/d12)*p1 + (b/d13)*p1 - p1
    A = [ (a/d12)*p2  (b/d13)*p3  -p4 ];
    c = [ (a/d12)*p1 + (b/d13)*p1 - p1 ];
    m = A\c;    % m = [m2;m3;m4]
    
    ux = (m(1)*p2 - p1)/norm(m(1)*p2 - p1); % Assume P1,P2 define X axis
    uy = (m(2)*p3 - p1)/norm(m(2)*p3 - p1); % Assume P1,P3 define Y axis
    uz = cross(ux,uy);
    R_m_c = [ux uy uz];
    
    % Force R_m_c to be a valid rotation matrix
    [U,S,V] = svd(R_m_c);
    R_m_c = U*eye(3)*V';
    
    k1 = d12/norm(m(1)*p2 - p1);    % Distance to point P1
    % k1 is in units of the size of a QR code "module".
    P1_c = k1*p1;       % Point 1 in camera coordinates
    
    % Define the model origin to be in the center of the QR code; ie at
    % point (13,13,0).  Subtract that from P1.
    tmorg_c = P1_c - R_m_c * (P1-[13;13;0]);
        
    % Scale translation to be in units of the width of the entire QR code.
    tmorg_c = tmorg_c/25;     % QR code version 2 is 25 modules wide
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     % Define a cube model to be drawn
%     Xvertices = [-1 -1 -1  1 -1 -1;  1  1 -1  1  1  1;  1  1 -1  1  1  1; -1 -1 -1  1 -1 -1];
%     Yvertices = [-1 -1 -1 -1 -1  1; -1 -1  1  1 -1  1;  1  1  1  1 -1  1;  1  1 -1 -1 -1  1];
%     Zvertices = [-1  1 -1 -1 -1 -1; -1  1 -1 -1 -1 -1; -1  1  1  1  1  1; -1  1  1  1  1  1];
% 
%     % Offset it by z = -.5 and make it smaller
%     Xvertices = Xvertices * 0.1;
%     Yvertices = Yvertices * 0.1;
%     Zvertices = (Zvertices-0.5) * 0.1;
%     
%     for i=1:size(Xvertices,2)
%         % Get XYZ vertices for this face
%         P = [Xvertices(:,i)'; Yvertices(:,i)'; Zvertices(:,i)'; ones(1,4)];
%         p = K * [ R_m_c tmorg_c ] * P;
%         p(1,:) = p(1,:)./p(3,:);
%         p(2,:) = p(2,:)./p(3,:);
%         
%         patch(p(1,:), p(2,:), 'c');
%     end
    
    % Draw model coordinate axes 
    p0 = K * [ R_m_c tmorg_c ] * [0; 0; 0; 1];
    p0 = p0 / p0(3);
    px = K * [ R_m_c tmorg_c ] * [0.25; 0; 0; 1];
    px = px / px(3);
    py = K * [ R_m_c tmorg_c ] * [0; -0.25; 0; 1];
    py = py / py(3);
    pz = K * [ R_m_c tmorg_c ] * [0; 0; -0.25; 1];
    pz = pz / pz(3);
    
    line([p0(1) px(1)], [p0(2) px(2)], 'Color', 'r', 'LineWidth', 3);
    line([p0(1) py(1)], [p0(2) py(2)], 'Color', 'g', 'LineWidth', 3);
    line([p0(1) pz(1)], [p0(2) pz(2)], 'Color', 'b', 'LineWidth', 3);

    drawnow;    
    pause(0.1);

%     newFrameOut = getframe;
%     % Make sure we didn't grab any extra rows or columns
%     newFrameOut.cdata = newFrameOut.cdata(1:H, 1:W, :);
%     writeVideo(movieOut,newFrameOut);
end

% close(movieOut);


