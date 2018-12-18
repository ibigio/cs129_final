function [ min_seam ] = get_min_seam(img, dimension)
    A = img;
    channality = size(size(img));
    
    if channality(2) > 2
        A = rgb2gray(img);
    end
    d = [1,2];
    if dimension == 2
        A = A';
        d = [2,1];
    end
    s = size(A);
    E = A;
    % get energy matrix
    for i=2:s(1)
        for j=1:s(2)
            E(i,j) = E(i,j) + min( E( i-1 , max(j-1,1):min(j+1,s(2)) ) );
        end
    end
    
    % find min seam
    min_seam = zeros(s(1),2);
    [C,I] = min(E(end,:));
    min_seam(s(1),d(1)) = s(1);
    min_seam(s(1),d(2)) = I;
    for i=2:s(1)
        index = 1 + s(1) - i;
        oldI = I;
        [C,I] = min( E( index, max(I-1,1):min(I+1,s(2))) );
        I = (oldI + I) - ((oldI-1 >= 1) + 1);
        min_seam(index,d(1)) = index;
        min_seam(index,d(2)) = I;
    end
end