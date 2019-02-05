subroutine Subtract_RefValue(n,x,x0) ! Subroutine to subtract a reference value from an array. The array in question will be changed (!!!)
implicit real(8) (a-h,o-z)
real(8) x(n)

do i = 1, n 
 x(i) = x(i) - x0
enddo

end