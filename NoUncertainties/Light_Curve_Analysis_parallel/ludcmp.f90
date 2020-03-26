subroutine ludcmp(a,n,np,indx,ierr)
      
integer n, np, indx(n), NMAX, i, imax, j, k, ierr
real(8) d, a(np,np), TINY, aamax, dum, sum 
parameter (NMAX = 500,TINY = 1.0e-20)
real(8) vv(NMAX)
      
d = 1.d0
do i = 1, n
 aamax = 0.D0
  
 do j = 1, n
  if(dabs(a(i,j)) > aamax) aamax = dabs(a(i,j))
 enddo
  
 if(aamax == 0.d0) then
  ierr = 1
  return
 endif
  
 vv(i) = 1.d0/aamax
enddo

do j = 1, n
 
 do i = 1, j-1
  sum = a(i,j)
  do k = 1, i-1
   sum = sum - a(i,k)*a(k,j)
  enddo
  a(i,j) = sum
 enddo
 
 aamax = 0.d0
 do i = j, n
  sum = a(i,j)
  do k = 1, j-1
   sum = sum - a(i,k)*a(k,j)
  enddo
  a(i,j) = sum
  dum = vv(i)*dabs(sum)
  if(dum >= aamax) then
   imax = i
   aamax = dum
  endif
 enddo
        
 if(j /= imax) then
  do k = 1, n
   dum = a(imax,k)
   a(imax,k) = a(j,k)
   a(j,k) = dum
  enddo
  d = -d
  vv(imax) = vv(j)
 end if
        
 indx(j) = imax
 if(a(j,j) == 0.d0) a(j,j) = TINY
 if(j /= n) then
  dum = 1.d0/a(j,j)
  do i = j+1, n
   a(i,j) = a(i,j)*dum
  enddo
 endif

enddo

end
