function  output = imblend( source, mask, target, transparent )
%Source, mask, and target are the same size (as long as you do not remove
%the call to fiximages.m). You may want to use a flag for whether or not to
%treat the source object as 'transparent' (e.g. taking the max gradient
%rather than the source gradient).

[h,w,d] = size(mask);

mask_size = sum(sum(mask(:,:,1)));
num_defined_vals = (4 * mask_size) + (h*w);

vec_i = zeros([1,num_defined_vals]);
vec_j = zeros([1,num_defined_vals]);
vec_v = zeros([1,num_defined_vals]);

count = 1;

for i=1:h
    for j=1:w
        p = (h*(j-1)) + i;
        if mask(i,j,1) == 1
            
            vec_i(1,count) = p;
            vec_i(1,count+1) = p;
            vec_i(1,count+2) = p;
            vec_i(1,count+3) = p;
            vec_i(1,count+4) = p;
            
            vec_j(1,count) = p;
            vec_j(1,count+1) = max(p-1,1);
            vec_j(1,count+2) = min(p+1, h*w);
            vec_j(1,count+3) = max(p-h,1);
            vec_j(1,count+4) = min(p+h, h*w);
            
            vec_v(1,count) = 4;
            vec_v(1,count+1) = -1 * (p-1 >= 1);
            vec_v(1,count+2) = -1 * (p+1 <= h*w);
            vec_v(1,count+3) = -1 * (p-h >= 1);
            vec_v(1,count+4) = -1 * (p+h <= h*w);
            
            count = count + 5;
        else
            vec_i(1,count) = p;
            vec_j(1,count) = p;
            vec_v(1,count) = 1;
            
            count = count + 1;
        end
    end
end

A = sparse(vec_i, vec_j, vec_v);

lap = [0 -1 0 ; -1 4 -1 ; 0 -1 0];

result = zeros(h,w,d);

for channel=1:d
    grads = filter2(lap,source(:,:,channel));
    b_mat = grads .* mask(:,:,channel) + target(:,:,channel) .* ~mask(:,:,channel);
    
    b = b_mat(:);
    x = A\b;
    result(:,:,channel) = reshape(x,h,w);
end



output = result;





%output = source .* mask + target .* ~mask;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% As explained on the web page, we solve for output by setting up a large
% system of equations, in matrix form, which specifies the desired value or
% gradient or Laplacian (e.g.
% http://en.wikipedia.org/wiki/Discrete_Laplace_operator)

% The comments here will walk you through a conceptually simple way to set
% up the image blending, although it is not necessarily the most efficient
% formulation. 

% We will set up a system of equations A * x = b, where A has as many rows
% and columns as there are pixels in our images. Thus, a 300x200 image will
% lead to A being 60000 x 60000. 'x' is our output image (a single color
% channel of it) stretched out as a vector. 'b' contains two types of known 
% values:
%  (1) For rows of A which correspond to pixels that are not under the
%      mask, b will simply contain the already known value from 'target' 
%      and the row of A will be a row of an identity matrix. Basically, 
%      this is our system of equations saying "do nothing for the pixels we 
%      already know".
%  (2) For rows of A which correspond to pixels under the mask, we will
%      specify that the gradient (actually the discrete Laplacian) in the
%      output should equal the gradient in 'source', according to the final
%      equation in the webpage:
%         4*x(i,j) - x(i-1, j) - x(i+1, j) - x(i, j-1) - x(i, j+1) = 
%         4*s(i,j) - s(i-1, j) - s(i+1, j) - s(i, j-1) - s(i, j+1)
%      The right hand side are measurements from the source image. The left
%      hand side relates different (mostly) unknown pixels in the output
%      image. At a high level, for these rows in our system of equations we
%      are saying "For this pixel, I don't know its value, but I know that
%      its value relative to its neighbors should be the same as it was in
%      the source image".

% commands you may find useful: 
%   speye - With the simplest formulation, most rows of 'A' will be the
%      same as an identity matrix. So one strategy is to start with a
%      sparse identity matrix from speye and then add the necessary
%      values. This will be somewhat slow.
%   sparse - if you want your code to run quickly, compute the values and
%      indices for the non-zero entries in A and then construct 'A' with a
%      single call to 'sparse'.
%      Matlab documentation on what's going on under the hood with a sparse
%      matrix: www.mathworks.com/help/pdf_doc/otherdocs/simax.pdf
%   reshape - convert x back to an image with a single call.
%   sub2ind and ind2sub - how to find correspondence between rows of A and
%      pixels in the image. It's faster if you simply do the conversion
%      yourself, though.
%   see also find, sort, diff, cat, and spy


