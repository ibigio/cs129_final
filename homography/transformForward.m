function transformed = transformForward(toTransform,T)
    transformed = [(T(1,1:2)*toTransform'+T(1,3))./(T(3,1:2)*toTransform'+T(3,3)); 
        (T(2,1:2)*toTransform'+T(2,3))./(T(3,1:2)*toTransform'+T(3,3))]';
end

