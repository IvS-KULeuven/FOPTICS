subroutine LombScargle_Periodogram(ifreq) ! Compute Lomb-Scargle periodogram

use lomb_scargle
implicit real(8) (a-h,o-z)
     
if(ifreq == 1) then
 call scar1
else
 call scar2
endif

end




