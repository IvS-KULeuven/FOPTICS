subroutine linfit(N,NFU,X,W,FU,A,B)

integer N, NFU
real(8) X(N), W(N)
real(8) A(NFU,NFU), B(NFU)
real(8) FU(NFU,N)

A = 0.d0
B = 0.d0

do k = 1, NFU
 do i = 1, N
  B(k) = B(k) + W(i)*X(i)*FU(k,i)
 end do
end do

do k = 1, NFU
 do j = 1, NFU
  do i = 1, N
   A(k,j) = A(k,j) + W(i)*FU(k,i)*FU(j,i)
  end do
 end do
end do

end