addpath('../07-07')

G_DARM = DTTloadTF('darmolg.txt');

baseline = DTTloadspec('01-baselinespectrum-pdsum.txt');

spec2 = DTTloadspec('02-f0.3hz_a22ctsexcspec-pdsum.txt');

spec4 = DTTloadspec('04-f0.5hz_a2000ctsexcspec-pdsum.txt');

spec6 = DTTloadspec('06-f0.2hz_a3000ctsexcspec-pdsum.txt');

spec5 = DTTloadspec('05-f0.2hz_a2000ctsexcspec-pdsum.txt');

spec3 = DTTloadspec('03-f0.3hz_a1500ctsexcspec-pdsum.txt');

CLG_DARM = [G_DARM(:,1),1./(1-G_DARM(:,2))];


baseline_OL = applytfinterp(tfinv(CLG_DARM),baseline);
spec2_OL = applytfinterp(tfinv(CLG_DARM),spec2);
spec4_OL = applytfinterp(tfinv(CLG_DARM),spec4);
spec6_OL = applytfinterp(tfinv(CLG_DARM),spec6);
spec5_OL = applytfinterp(tfinv(CLG_DARM),spec5);
spec3_OL = applytfinterp(tfinv(CLG_DARM),spec3);

SRSspec(baseline_OL,spec2_OL,spec4_OL,spec6_OL,spec5_OL,spec3_OL)
%legend('b','2','4','6','5','3')

legend('baseline','A=34\mum f=0.3Hz','26\mum 0.5Hz','50\mum 0.2Hz','33\mum 0.2Hz','25\mum 0.3Hz')