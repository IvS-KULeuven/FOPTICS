subroutine ComputeEpsilonCoreDistance(iobj)

use foptics_module
implicit real(8) (a-h,o-z)

real(8) x(NumberAttributes), temp(NumberAttributes)
integer DISTPOS(MinimumNumberPointsEpsilon)

! Find all objects in epsilon neigborhood (optimization using binning in combination with hashing of the binindices)

EpsilonDistances = 0.d0
do k = 1, NumberPerturbations ! Loop over the number of perturbations
 x = Attributes(iobj,1:NumberAttributes,k) ! Attributes of the object in question for a given perturbation set
      
 NumberObjectsEpsilon = 0
 do i = 1, NumberObjects ! Loop over the number of objects      
  if(i == iobj) cycle ! We are not computing distance of the object from itself
  NumberObjectsEpsilon = NumberObjectsEpsilon + 1 ! number of objects in the epsilon neighborhood is always one less than the total number of objects
  temp = dabs(Attributes(i,:,k) - x) ! for each object in a given perturbation set, compute the difference between that object's attributes and those of the object in question 
  do j = 1, NumberAttributes ! Loop over the number of attributes
   EpsilonDistances(NumberObjectsEpsilon,k) = EpsilonDistances(NumberObjectsEpsilon,k) + temp(j)*temp(j) ! Epsilon neighborhood distance of a point to the reference object as a sum of squared attribute differences
  enddo
  ObjectIndexInEpsilon(NumberObjectsEpsilon) = i ! Save index of the processed object in the neighborhood
 enddo

! Core distance of an object is equal to the MinimumNumberPointsEpsilon-th closest object's epsilon neighborhood distance to that object, provided that there is such an object within the epsilon neighborhood (else the core distance is undefined).
      
 if(NumberObjectsEpsilon < MinimumNumberPointsEpsilon) then ! Core distance is undefined when the number of objects in the neighborhood is lower than the pre-defined minimum
  CoreReachabilityDistance(iobj,k) = DistanceUndefined
 else
!  call cpu_time(ti)
  call D_rnkpar(EpsilonDistances(1:NumberObjectsEpsilon,k), NumberObjectsEpsilon, DISTPOS, MinimumNumberPointsEpsilon) ! call subroutine for partial sorting to find the NP-smallest distances (from ORDERPACK 2.0, Author: Michel Olagnon) 
  CoreReachabilityDistance(iobj,k) = EpsilonDistances(DISTPOS(MinimumNumberPointsEpsilon),k) ! CoreReachabilityDistance is defined by selecting MinimumNumberPointsEpsilon smallest EpsilonDistances and by extracting the MinimumNumberPointsEpsilon one (EpsilonDistances(DISTPOS(MinimumNumberPointsEpsilon),k))
!  call cpu_time(te)
!  ttot=ttot+te-ti 
 endif     
enddo

end