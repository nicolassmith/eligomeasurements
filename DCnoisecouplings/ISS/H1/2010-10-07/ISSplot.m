% make ISS plots.

load('../../DARMcalib.mat')
load('../OLMONcalib.mat')

clear dataStructure;

% organize data

measnums =  [05 06] ;
offset = 15;
measstring = '';

offsetCalib = 9.6/15;

for kk = 1:length(measnums)
    measstr = num2str(abs(measnums(kk)),'%02d');
    %if offsets(kk)<0
    %    offstring = ['-' offstring];
    %end
    
    dataStructure(kk).offset = offset*1e-12*offsetCalib;
    dataStructure(kk).filenames = {[measstr '-x0' num2str(offset,'%02d') 'pm8Wlf.txt'],...
                                   [measstr '-x0' num2str(offset,'%02d') 'pm8Whf.txt'],...
                                   [measstr '-x0' num2str(offset,'%02d') 'pm8W.txt']};
    
    tempTF = [];                           
    for jj = 1:length(dataStructure(kk).filenames)
        if exist(dataStructure(kk).filenames{jj},'file')
            tempTF = specpatch(tempTF,DTTloadTF(dataStructure(kk).filenames{jj}));
        end
    end
    
    dataStructure(kk).fTF = calTF(tempTF,DARMcalib,OLMONcalib);
    dataStructure(kk).legend = [num2str(dataStructure(kk).offset*1e12) 'pm offset, measurement ' measstr];
end


figure(122)
SRSbode(dataStructure.fTF)
legend(dataStructure.legend)

ylabel('m/RIN')
title('Measured Intensity Noise Coupling on H1 with DC readout')



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