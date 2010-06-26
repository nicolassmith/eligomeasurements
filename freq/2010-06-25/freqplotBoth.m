% do both 

freqPlot

dataStructure1 = dataStructure;

run ../2010-06-05/freqPlot.m

close(121)
close(122)


dataStructure = [dataStructure,dataStructure1];

figure(121)
SRSbode(dataStructure.fTF)
legend(dataStructure.legend)

title('measured frequency noise coupling for DC readout')
ylabel('m/Hz')