%OMC cal line mode matching

QPD1unlocked = 0.0113442;
QPD3unlocked = 0.00227875;

QPD1locked = 0.00590854;
QPD3locked = 0.0043296;

QPD1highpower = 0.0155304;
QPD3highpower = 0.010472;


ratiounlocked = QPD1unlocked / QPD3unlocked ;
ratiolocked = QPD1locked / QPD3locked ;
ratiohighpower = QPD1highpower / QPD3highpower ;

mismatchlocked = ratiolocked / ratiounlocked ;
mismatchhighpower = ratiohighpower / ratiounlocked ;

disp(['Locked mismatch: ' num2str(mismatchlocked)])
disp(['High power mismatch: ' num2str(mismatchhighpower)])