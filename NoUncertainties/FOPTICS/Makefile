FF = gfortran
FLAG = -c -ffree-line-length-512
BDIR = .

all: $(BDIR)/foptics Makefile

$(BDIR)/foptics: foptics_module.o foptics_main.o foptics_input.o optics.o ComputeEpsilonCoreDistance.o D_rnkpar.o ComputeReachabilityDistanceAddSeed.o Makefile
	$(FF)  -o $(BDIR)/foptics *.o

foptics_module.o: foptics_module.f90 
	$(FF)  $(FLAG) foptics_module.f90

foptics_main.o: foptics_main.f90 
	$(FF)  $(FLAG) foptics_main.f90
	
foptics_input.o: foptics_input.f90 
	$(FF)  $(FLAG) foptics_input.f90
	
optics.o: optics.f90 
	$(FF)  $(FLAG) optics.f90
	
ComputeEpsilonCoreDistance.o: ComputeEpsilonCoreDistance.f90 
	$(FF)  $(FLAG) ComputeEpsilonCoreDistance.f90
	
D_rnkpar.o: D_rnkpar.f90 
	$(FF)  $(FLAG) D_rnkpar.f90
	
ComputeReachabilityDistanceAddSeed.o: ComputeReachabilityDistanceAddSeed.f90 
	$(FF)  $(FLAG) ComputeReachabilityDistanceAddSeed.f90

clean:
	@rm -f *.o
	@rm -f *.mod
