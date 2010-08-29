function phi = phicalc(n,seed)

    if n == 0
        phi = seed;
    elseif n > 0
        phi = 1 + 1 / phicalc(n-1,seed);
    else
        error('n out of range')
    end

end