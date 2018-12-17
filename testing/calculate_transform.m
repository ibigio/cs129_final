% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Given a set of corresponding points, find the least square solution 
% of the homography that transforms between them. 
%
%
% X1:           x location of the correspondence points in image A
% Y1:           y location of the correspondence points in image A
% X2:           x location of the correspondence points in image B
% Y2:           y location of the correspondence points in image B
%
%
% T:            the calculated homography (|3|x|3| matrix)
% T transforms B to A

function T = calculate_transform(X1, Y1, X2, Y2)
    % Populate A matrix
    A = zeros(8);
    A(1:4,1) = X2;
    A(1:4,2) = Y2;
    A(1:4,3) = 1;
    A(5:8,4) = X2;
    A(5:8,5) = Y2;
    A(5:8,6) = 1;
    A(1:4,7) = -X2 .* X1;
    A(5:8,7) = -X2 .* Y1;
    A(1:4,8) = -Y2 .* X1;
    A(5:8,8) = -Y2 .* Y1;
    
    % Populate b matrix
    b = [X1;Y1];
    
    % Solve
    T = reshape([A\b;1], [3,3]);
end