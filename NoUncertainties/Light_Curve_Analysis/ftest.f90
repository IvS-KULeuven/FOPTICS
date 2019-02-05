subroutine ftest(var1,n1,var2,n2,f,prob) ! Subroutine for performing F-tests on variance-ratios (uses external function betai)

integer n1, n2
real(8) f, prob, df1, df2, var1, var2, betai

if (var1 > var2) then
 f = var1/var2
 df1 = dfloat(n1) - 1.d0
 df2 = dfloat(n2) - 1.d0
else
 f = var2/var1
 df1 = dfloat(n2) - 1.d0
 df2 = dfloat(n1) - 1.d0
endif
      
prob = 2.d0*betai(0.5d0*df2,0.5d0*df1,df2/(df2+df1*f))
if(prob > 1.d0) prob = 2.d0 - prob

end

!-----------------------------------------------------------------------
function betai(a,b,x) !    USES betacf, gammln

real(8) betai, a, b, x
real(8) bt, betacf, gammln
      
if(x < 0.d0 .or. x > 1.d0) stop 'bad argument x in betai'

if(x == 0.d0 .or. x == 1.d0) then
 bt = 0.d0
else
 bt = dexp(gammln(a+b) - gammln(a) - gammln(b) + a*dlog(x) + b*dlog(1.d0-x))
endif

if(x < (a + 1.d0)/(a + b + 2.d0)) then
 betai = bt*betacf(a,b,x)/a
 return
else
 betai = 1.d0 - bt*betacf(b,a,1.d0-x)/b
 return
endif
      
end

!-----------------------------------------------------------------------
function betacf(a,b,x)
      
integer MAXIT, m, m2
real(8) betacf, a, b, x, EPS, FPMIN, aa, c, d, del, h, qab, qam, qap
parameter (MAXIT = 1000, EPS = 3.e-7, FPMIN = 1.e-30)

qab = a + b
qap = a + 1.d0
qam = a - 1.d0
c = 1.D0
d = 1.d0 - qab*x/qap
if(dabs(d) < FPMIN) d = FPMIN
d = 1.d0/d
h = d

ios = 0
do m = 1, MAXIT
 m2 = 2*m
 aa = dfloat(m)*(b-dfloat(m))*x/((qam+dfloat(m2))*(a+dfloat(m2)))
 d = 1.d0 + aa*d
 if(dabs(d) < FPMIN) d = FPMIN
 c = 1.d0 + aa/c
 if(dabs(c) < FPMIN) c = FPMIN
 d = 1.d0/d
 h = h*d*c
 aa = -(a+dfloat(m))*(qab+dfloat(m))*x/((a+dfloat(m2))*(qap+dfloat(m2)))
 d = 1.d0 + aa*d
 if(dabs(d) < FPMIN) d = FPMIN
 c = 1.d0 + aa/c
 if(dabs(c) < FPMIN) c = FPMIN
 d = 1.d0/d
 del = d*c
 h = h*del
 if(dabs(del-1.d0) < EPS) then
  ios = 1; exit
 endif
enddo

if(ios == 0) write(6,*) 'a or b too big, or MAXIT too small in betacf'
betacf = h

return
end

!--------------------------------------------------------------------
      
function gammln(xx)

real(8) gammln, xx, ser, stp, tmp, x, y, cof(6)
integer j
save cof, stp
data cof, stp/76.18009172947146d0,-86.50532032941677d0,24.01409824083091d0,-1.231739572450155d0,.1208650973866179d-2,-.5395239384953d-5,2.5066282746310005d0/
      
x = xx
y = x
tmp = x + 5.5d0
tmp = (x+0.5d0)*dlog(tmp) - tmp
ser = 1.000000000190015d0

do j = 1, 6
 y = y + 1.d0
 ser = ser + cof(j)/y
enddo

gammln = tmp + dlog(stp*ser/x)
return

end