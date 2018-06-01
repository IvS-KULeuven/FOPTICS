COMPILER = /usr/local/bin/gfortran
LINKER = /usr/local/bin/gfortran
FFLAGS = -ffree-line-length-512 -O3

SRCDIR = source
OBJDIR = source
TARGETDIR = .

TARGET = foptics

all: $(TARGET)

# Note: the foptics_module.f90 should be compiled first because it generates a .mod file which is needed by the other source files.

$(TARGET): foptics_module.o foptics_main.o foptics_input.o optics.o ComputeEpsilonCoreDistance.o D_rnkpar.o ComputeReachabilityDistanceAddSeed.o
	$(COMPILER) -o $(TARGETDIR)/$(TARGET) $(OBJDIR)/*.o

foptics_module.o: $(SRCDIR)/foptics_module.f90 
	$(COMPILER) $(FFLAGS) -c $(SRCDIR)/foptics_module.f90 -o $(OBJDIR)/foptics_module.o

foptics_main.o: $(SRCDIR)/foptics_main.f90 
	$(COMPILER) $(FFLAGS) -c $(SRCDIR)/foptics_main.f90 -o $(OBJDIR)/foptics_main.o
	
foptics_input.o: $(SRCDIR)/foptics_input.f90 
	$(COMPILER) $(FFLAGS) -c $(SRCDIR)/foptics_input.f90 -o $(OBJDIR)/foptics_input.o
	
optics.o: $(SRCDIR)/optics.f90 
	$(COMPILER) $(FFLAGS) -c $(SRCDIR)/optics.f90 -o $(OBJDIR)/optics.o
	
ComputeEpsilonCoreDistance.o: $(SRCDIR)/ComputeEpsilonCoreDistance.f90 
	$(COMPILER) $(FFLAGS) -c $(SRCDIR)/ComputeEpsilonCoreDistance.f90 -o $(OBJDIR)/ComputeEpsilonCoreDistance.o
	
D_rnkpar.o: $(SRCDIR)/D_rnkpar.f90
	$(COMPILER) $(FFLAGS) -c $(SRCDIR)/D_rnkpar.f90 -o $(OBJDIR)/D_rnkpar.o
	
ComputeReachabilityDistanceAddSeed.o: $(SRCDIR)/ComputeReachabilityDistanceAddSeed.f90 
	$(COMPILER) $(FFLAGS) -c $(SRCDIR)/ComputeReachabilityDistanceAddSeed.f90 -o $(OBJDIR)/ComputeReachabilityDistanceAddSeed.o



clean:
	@rm -f $(OBJDIR)/*.o
	@rm -f $(SRCDIR)/*.mod
	@rm -f $(TARGETDIR)/*.mod
	@rm -f $(TARGETDIR)/$(TARGET)

