function [n] = normr_1290(m)
    [mr,mc]=size(m);
    if (mc == 1)
        n = m ./ abs(m);
    else
        n=sqrt(ones./(sum((m.*m)')))'*ones(1,mc).*m;
    end
end