subroutine lubksb(a,n,np,indx,b) ! Subroutine for solving a set of linear equations (using LU-decomposition)
      
integer n, np, indx(n), i, ii, j, ll
real(8) a(np,np), b(n), sum

ii = 0
do i = 1, n
 ll = indx(i)
 sum = b(ll)
 b(ll) = b(i)
 if(ii /= 0) then
  do j = ii, i-1
   sum = sum - a(i,j)*b(j)
  enddo
 elseif(sum /= 0.D0) then
  ii = i
 endif
 b(i) = sum
enddo

do i = n, 1, -1
 sum = b(i)
 do j = i+1, n
  sum = sum - a(i,j)*b(j)
 enddo
 b(i) = sum/a(i,i)
enddo
      
end