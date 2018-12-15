function fFound = checkRatio(count)

fFound = false;     % We will return true if ratio is ok

% Make sure all counts are > 0
minSize = min(count);
if minSize == 0     return;     end

% Get total counts; should be at least 7
totalSize = sum(count);
if totalSize < 7    return;     end

% Get expected size of one module
moduleSize = ceil(totalSize/7);
%maxDeviation = moduleSize/2;
maxDeviation = moduleSize/2;

% See if each module size is close to the expected value (1,1,3,1,1)
fFound = ...
    abs(count(1)-moduleSize) < maxDeviation && ...
    abs(count(2)-moduleSize) < maxDeviation && ...
    abs(count(3)-3*moduleSize) < 3*maxDeviation && ...
    abs(count(4)-moduleSize) < maxDeviation && ...
    abs(count(5)-moduleSize) < maxDeviation;

return

