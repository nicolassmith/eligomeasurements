% this is where I measured the dither amplitudes of beacon alignment

[QPD3P,QPD3Y,QPD4P,QPD4Y] = DTTloadspec('03-ditheramponQPDs.txt');

PDSUM = DTTloadspec('01-highfreqOMCpdspec-PDSUM.txt');

DARM = DTTloadspec('besth1noise.txt');

SRSspec(QPD3P,QPD3Y,QPD4P,QPD4Y)

specCell = {QPD3P,QPD3Y,QPD4P,QPD4Y};

legend('3p','3y','4p','4y')

TTnames = {'P1','Y1','P2','Y2'};
TTfreqs = [1.1,0.9,3.5,3.2];


QPDnames = {'QPD3P','QPD3Y','QPD4P','QPD4Y'};

freqwindow = 0.03;%hz half width of integration window.


for TTdof = 1:4
    for QPD = 1:4
        intdata.([TTnames{TTdof} '_' QPDnames{QPD}]) = ...
            intASD(specCell{QPD},TTfreqs(TTdof) - freqwindow,TTfreqs(TTdof) + freqwindow);
    end
end

% getting TT angles from QPD signals is as easy as 123

% phi = w/(2*a) * sqrt(pi/2) * PIT
% phi is the angle, w is beam spot size, a is lever arm, PIT is pitch signal

% distance from TTs to OMC input
a.TT1 = 2.191; 
a.TT2 = 0.351;

%parameters
lambda = 1064e-9;
w0     = 0.5e-3;
zR     = pi*w0^2/lambda;

a.QPD3 = 0.41*zR; %QPD3 position (numerical val is in units of rayleigh range)
a.QPD4 = 0.047*zR; %QPD4 position

%compute beam widths
w.QPD3 = w0 * sqrt(1 + (a.QPD3/zR)^2);
w.QPD4 = w0 * sqrt(1 + (a.QPD4/zR)^2);


TTs = {'TT1','TT2'};
QPDs = {'QPD3','QPD4'};

for T = TTs
    for Q = QPDs
        leverarm = a.(Q{1}) + a.(T{1}); % total lever arm
        calib.([T{1} 'ang_' Q{1}]) = w.(Q{1}) /(2*leverarm) * sqrt(pi/2);
    end
end


% now apply calibration

for TT = ['1','2']
    for TTd = ['P','Y']
        for QPD = ['3','4']
            for QPDd = ['P','Y']
                datastring = [TTd TT '_QPD' QPD QPDd];
                calstring = ['TT' TT 'ang_QPD' QPD];
                calintdata.(datastring) = calib.(calstring) * intdata.(datastring);
            end
        end
    end
end

display(calintdata)

% now we're gonna get the drumhead amplitude

fDrum = 9225;
fCalLine = 1144.1;
fwindow = 1;

DrumRIN = intASD(PDSUM,fDrum-fwindow,fDrum+fwindow);
CalRIN = intASD(PDSUM,fCalLine-fwindow,fCalLine+fwindow);

CalDARM = intASD(DARM,fCalLine-fwindow,fCalLine+fwindow);

DrumDARM = DrumRIN * CalDARM / CalRIN * fDrum / fCalLine;

display(DrumDARM)