function [cropped_im1, cropped_im2] = get_cropped_images(im1, im2)

%   im1 = imread('marker.JPG') ;
%   im2 = imread('photo8.jpg') ;
% 
%   
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


% --------------------------------------------------------------------
%                                         RANSAC with homography model
% --------------------------------------------------------------------

clear H score ok ;
for t = 1:100
  % estimate homograpyh
  subset = vl_colsubset(1:numMatches, 4) ;
  A = [] ;
  for i = subset
    A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
  end
  [U,S,V] = svd(A) ;
  H{t} = reshape(V(:,9),3,3) ;

  % score homography
  X2_ = H{t} * X1 ;
  du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
  dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
  ok{t} = (du.*du + dv.*dv) < 6*6 ;
  score(t) = sum(ok{t}) ;
end

[score, best] = max(score) ;
H = H{best} 
ok = ok{best} ;

x1_ok = x1(ok);
y1_ok = y1(ok);
x2_ok = x2(ok);
y2_ok = y2(ok);

pointsA = [x1_ok, y1_ok];
pointsB = [x2_ok, y2_ok];

%find boundaries:
[min_x1, leftIndex] = min(x1_ok);
[max_x1, rightIndex] = max(x1_ok);
[min_y1, topIndex] = min(y1_ok);
[max_y1, botIndex] = max(y1_ok);
cropped_im1 = imcrop(im1, [min_x1, min_y1, max_x1-min_x1, max_y1-min_y1]);
cropped_im2 = imcrop(im2,...
    [x2_ok(leftIndex), y2_ok(topIndex), ...
    x2_ok(rightIndex)-x2_ok(leftIndex), ...
    y2_ok(botIndex)-y2_ok(topIndex)]);

function err = residual(H)
 u = H(1) * X1(1,ok) + H(4) * X1(2,ok) + H(7) ;
 v = H(2) * X1(1,ok) + H(5) * X1(2,ok) + H(8) ;
 d = H(3) * X1(1,ok) + H(6) * X1(2,ok) + 1 ;
 du = X2(1,ok) - u ./ d ;
 dv = X2(2,ok) - v ./ d ;
 err = sum(du.*du + dv.*dv) ;
end

if exist('fminsearch') == 2
  H = H / H(3,3) ;
  opts = optimset('Display', 'none', 'TolFun', 1e-8, 'TolX', 1e-8) ;
  H(1:8) = fminsearch(@residual, H(1:8)', opts) ;
else
  warning('Refinement disabled as fminsearch was not found.') ;
end

end