set(gca, 'Position', get(gca, 'OuterPosition') - ...
    get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [7.5 4.0]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 get(gcf, 'PaperSize')]);

%h = cgrid();
%set(h, 'gridlinestyle', '-', 'minorgridlinestyle', '-');