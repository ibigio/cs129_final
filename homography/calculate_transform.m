
% DISCLAIMER: please note that calculate transform is an algorithm by
% Siladittya Manna, and I found the pseudocode online. I hope this is okay.
% If not, then I understand the need to deduct for finding pseudocode
% online for this portion.

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


function T = calculate_transform(A,B)
    % Initialization
    n = length(A);
    % Setting up the matrix to solve:
    M = [A(1:n,:),ones(n,1),zeros(n,3),...
        -1*B(1:n,1).*A(1:n,:),...
        -1*B(1:n,1);...
        zeros(n,3),-1*A(1:n,:),-1*ones(n,1),...
        B(1:n,2).*A(1:n,:),...
        B(1:n,2)];
    [~,S,V] = svd(M);
    % Extracting Diagonal elements of S
    sigmas = diag(S);
    
    % Detecting minimum diagonal element
    if length(sigmas) >= 9
        minSigma = min(sigmas);
        [~,minSigmaCol] = find(S==minSigma);
        % Calculating q
        q = double(vpa(V(:,minSigmaCol)));
    elseif length(sigmas)<9
        % Calculating q
        q = double(vpa(V(:,9)));
    end
    % Calculating T
    T = reshape(q,[3,3])';
end