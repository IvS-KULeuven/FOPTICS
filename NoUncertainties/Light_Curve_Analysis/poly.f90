subroutine poly(N,T,FUNCP,deg) ! Computes intermediates of the polynomial

integer N, deg
real(8) T(N), FUNCP(deg+1,N)

do i = 1, N
 do j = 1, deg+1
  FUNCP(j,i) = (T(i))**real(j-1,8)
 end do
end do

end