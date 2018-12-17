function transformedPoints = transformBackward(toTransform,T)
    iT=inv(T);
    transformedPoints = [(iT(1,1:2)*toTransform'+iT(1,3))./(iT(3,1:2)*toTransform'+iT(3,3));...
        (iT(2,1:2)*toTransform'+iT(2,3))./(iT(3,1:2)*toTransform'+iT(3,3))]';
end