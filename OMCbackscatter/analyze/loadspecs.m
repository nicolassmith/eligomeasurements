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

