function strucout = calibratelengthnoise(strucin)


    Finesse = 370;
    lambda = 1064e-9;
    P_t0 = 20.7104; %PDSUM
    P_i0 = 379.952; %QPD3SUM

    strucin.closedloop = [strucin.lengthloop(:,1),1./(1-strucin.lengthloop(:,2))];
    
    loopcorrectedspectrum = applytfinterp(strucin.closedloop,strucin.rawPSD);
    
    Pin = strucin.P_i * P_t0/P_i0 ;
    
    Ptrans = strucin.P_t ;
    
    delta = sqrt(Pin/Ptrans - 1); %detuning
    
    calcoefficient = Pin / Ptrans^2 / (4 * Finesse) / (2 * delta) * lambda;
    
    calibratedspectrum = colmult(loopcorrectedspectrum,[1,calcoefficient]);
    
    strucin.lengthnoisespectrum = calibratedspectrum;
    
    strucout = strucin;
    
end
