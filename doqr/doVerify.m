function [fFoundit, x0, y0] = doVerify(BW, xc, yc)
% Verify presence of 1:1:3:1:1 pattern at xc,yc; refine location

fFoundit = false;       % Set to true if we have verified pattern

x0 = [];        % We have to initialize or else Matlab complains
y0 = [];

[H,W] = size(BW);

% Make sure pixel (xc,yc) is black
if BW(yc,xc)   return;     end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starting at (xc,yc), look vertically for the pattern 1:1:3:1:1
stateCount = [0,0,1,0,0];

y = yc-1;   % Search upwards
while (y>=1) && ~BW(y,xc)
    stateCount(3) = stateCount(3) + 1;  % inc count for black region
    y = y-1;
end
while (y>=1) && BW(y,xc)
    stateCount(2) = stateCount(2) + 1;  % inc count for white region
    y = y-1;
end
while (y>=1) && ~BW(y,xc)
    stateCount(1) = stateCount(1) + 1;  % inc count for black region
    y = y-1;
end

y = yc+1;   % Search downwards
while (y<=H) && ~BW(y,xc)
    stateCount(3) = stateCount(3) + 1;  % inc count for black region
    y = y+1;
end
while (y<=H) && BW(y,xc)
    stateCount(4) = stateCount(4) + 1;  % inc count for white region
    y = y+1;
end
while (y<=H) && ~BW(y,xc)
    stateCount(5) = stateCount(5) + 1;  % inc count for black region
    y = y+1;
end

% Return if vertical pattern doesn't check out
if ~checkRatio(stateCount)      return;     end

% Pattern is verified in vertical direction; refine center
y0 = y - stateCount(5) - stateCount(4) - round(stateCount(3)/2);
x0 = xc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starting at (x0,y0), look diagonally-1 for the pattern 1:1:3:1:1
stateCount = [0,0,1,0,0];

x = x0-1;   % Search upwards
y = y0-1;
while (x>=1) && (y>=1) && ~BW(y,x)
    stateCount(3) = stateCount(3) + 1;  % inc count for black region
    x = x-1;
    y = y-1;
end
while (x>=1) && (y>=1) && BW(y,x)
    stateCount(2) = stateCount(2) + 1;  % inc count for white region
    x = x-1;
    y = y-1;
end
while (x>=1) && (y>=1) && ~BW(y,x)
    stateCount(1) = stateCount(1) + 1;  % inc count for black region
    x = x-1;
    y = y-1;
end

x = x0+1;   % Search downwards
y = y0+1;
while (x<=W) && (y<=H) && ~BW(y,x)
    stateCount(3) = stateCount(3) + 1;  % inc count for black region
    x = x+1;
    y = y+1;
end
while (x<=W) && (y<=H) && BW(y,x)
    stateCount(4) = stateCount(4) + 1;  % inc count for white region
    x = x+1;
    y = y+1;
end
while (x<=W) && (y<=H) && ~BW(y,x)
    stateCount(5) = stateCount(5) + 1;  % inc count for black region
    x = x+1;
    y = y+1;
end

% Return if diagonal-1 pattern doesn't check out
if ~checkRatio(stateCount)      return;     end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starting at (x0,y0), look diagonally-2 for the pattern 1:1:3:1:1
stateCount = [0,0,1,0,0];

x = x0+1;   % Search upwards
y = y0-1;
while (x<=W) && (y>=1) && ~BW(y,x)
    stateCount(3) = stateCount(3) + 1;  % inc count for black region
    x = x+1;
    y = y-1;
end
while (x<=W) && (y>=1) && BW(y,x)
    stateCount(2) = stateCount(2) + 1;  % inc count for white region
    x = x+1;
    y = y-1;
end
while (x<=W) && (y>=1) && ~BW(y,x)
    stateCount(1) = stateCount(1) + 1;  % inc count for black region
    x = x+1;
    y = y-1;
end

x = x0-1;   % Search downwards
y = y0+1;
while (x>=1) && (y<=H) && ~BW(y,x)
    stateCount(3) = stateCount(3) + 1;  % inc count for black region
    x = x-1;
    y = y+1;
end
while (x>=1) && (y<=H) && BW(y,x)
    stateCount(4) = stateCount(4) + 1;  % inc count for white region
    x = x-1;
    y = y+1;
end
while (x>=1) && (y<=H) && ~BW(y,x)
    stateCount(5) = stateCount(5) + 1;  % inc count for black region
    x = x-1;
    y = y+1;
end

% Return if diagonal-2 pattern doesn't check out
if ~checkRatio(stateCount)      return;     end


% Ok, it checks out in the other directions
fFoundit = true;

return

