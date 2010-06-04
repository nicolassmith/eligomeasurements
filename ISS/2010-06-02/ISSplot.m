% make ISS plots.

load('../../DARMcalib.mat')
load('../OLMONcalib.mat')

clear dataStructure;

% organize data
%offsets = [-29 -23 -15 -07 07 15 23 29];
offsets = [07 15 23 29];
offstring = '';

offsetCalib = 9.6/15;

for kk = 1:length(offsets)
    offstring = num2str(abs(offsets(kk)),'%02d');
    if offsets(kk)<0
        offstring = ['-' offstring];
    end
    
    dataStructure(kk).offset = offsets(kk)*1e-12*offsetCalib;
    dataStructure(kk).filenames = {['x0' offstring 'pm8Wlf.txt'],...
                                   ['x0' offstring 'pm8Whf.txt']};
    
    tempTF = [];                           
    for jj = 1:length(dataStructure(kk).filenames)
        tempTF = specpatch(tempTF,DTTloadTF(dataStructure(kk).filenames{jj}));
    end
    
    dataStructure(kk).fTF = calTF(tempTF,DARMcalib,OLMONcalib);
    dataStructure(kk).legend = [num2str(dataStructure(kk).offset*1e12) 'pm offset'];
end


figure(122)
SRSbode(dataStructure.fTF)
legend(dataStructure.legend)




% 
% 
% 
% TFm15pm = specpatch(DTTloadTF('x0-15pm8wlf.txt'),DTTloadTF('x0-15pm8whf.txt'));
% 
% TFm15pmcal = calTF(TFm15pm,DARMcalib,OLMONcalib);
% 
% figure(335)
% SRSbode(TF07pmcal,TFm15pmcal)
% title('Intensity Noise Coupling')
% legend('7pm','-15pm')
% ylabel('m/RIN')
% 
% % figure(333)
% % SRSbode(TF20pm,TF15pm)