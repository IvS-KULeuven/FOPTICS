subroutine Subtract_Polynomial ! subroutine to subtract a polynomial from the data
use light_curve
implicit real(8) (a-h,o-z)

integer indxP(ndeg+1)
real(8) func(ndeg+1,ntimes), ap(ndeg+1,ndeg+1), bp(ndeg+1), polyn(ntimes) ! Some local declarations

call poly(ntimes,times,func,ndeg) ! Prepare intermediates of the polynomial
call linfit(ntimes,ndeg+1,flux,weights,func,ap,bp) ! The following three subroutines are responsible for calculation of least-squares fits
call ludcmp(ap,ndeg+1,ndeg+1,indxP)
call lubksb(ap,ndeg+1,ndeg+1,indxP,bp)

polyn = 0.d0 ! Compute polynomial
do it = 1, ntimes
 do j = 1, ndeg+1
  polyn(it) = polyn(it) + bp(j)*func(j,it)
 enddo
enddo

do it = 1, ntimes ! Subtract polynomial from the data
 flux(it) = flux(it) - polyn(it)
end do

end
      

