function phiplot(n,seed)
    phin = zeros(1,n);
    phi = seed;
    for jj = 1:n
        phi = 1+1/phi;
        phin(jj)=phi;
    end
    plot(phin/phicalc(100,1))
    disp(phin')
end