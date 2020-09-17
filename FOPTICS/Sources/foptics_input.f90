subroutine foptics_input ! Subroutine to get all the input
use foptics_module ! declarations common to subroutines and the main program
implicit real(8) (a-h,o-z)

!!!!!!!!!!!!! local declarations !!!!!!!!!!!!!!!!!!

character(500) filename, arg
character(200), allocatable :: InputFilesArray(:)

call getarg(1,InputList) ! Get input directory from the command line
call getarg(2,OutputFile) ! Get Output file name from the command line
call getarg(3,arg) ! Get the number of attributes from the command line
read(arg,*) NumberAttributes ! Read off the actual number from the string variable
call getarg(4,arg) ! Get a value associated with undefined distance (used in optics)
read(arg,*) DistanceUndefined
call getarg(5,arg) ! Get a minimum number of points that a neighborhood should include
read(arg,*) MinimumNumberPointsEpsilon

!!!!!!!!!!!!!!! Get perturbed data sets !!!!!!!!!!!!!!!!!!!!!!!

open(1,file=trim(adjustl(InputList)),status='old',iostat=ios) ! Open the list and return an error message in case it could not be opened
if(ios /= 0) then
 write(*,"('List of file names associated with the perturbed data sets ',a,' could not be opened')") trim(adjustl(InputList))
 stop
endif

NumberPerturbations = 0 ! We will get the number of perturbed data sets in the loop below
do
 read(1,*,iostat=ios)
 if(ios /= 0) exit
 NumberPerturbations = NumberPerturbations + 1
enddo
rewind(1); allocate(InputFilesArray(NumberPerturbations)) ! Go back to the first file record; allocate an array where the file names will be stored

do i = 1, NumberPerturbations
 read(1,"(a)") InputFilesArray(i) ! Get the file names and store them in the array
enddo
close(1) ! Close the list

!!!!!!!!!!!!!!! Get perturbed attributes !!!!!!!!!!!!!!!!!!!!!!!!

do iper = 1, NumberPerturbations ! Loop over the number of attribute files
 filename = ' '; filename = trim(adjustl(InputFilesArray(iper))) ! Get the file name

 open(1,file=trim(adjustl(filename)),status='old',iostat=ios) ! Open an attribute file and check whether it exists
 if(ios /= 0) then
  write(*,"('The attribute file ',a,'could not be opened')") trim(adjustl(filename))
 endif
 
 if(iper == 1) then ! Get the number of entries in a file (= number of objects) and allocate necessary arrays. Do it once as all the files are supposed to have the same lenght
  NumberObjects = 0 ! Number of stars (= number of objects)
  do
   read(1,*,iostat=ios)
   if(ios /= 0) exit
   NumberObjects = NumberObjects + 1
  enddo
  rewind(1); allocate(ObjectID(NumberObjects),Attributes(NumberObjects,NumberAttributes,NumberPerturbations),ObjectOrder(NumberObjects)) ! Memory allocation
 endif

 do iobject = 1, NumberObjects ! Loop over the number of stars
  read(1,"(a)") arg ! Read a string from the input file
  k = 0; k = index(arg,'/',back=.true.); kk = 0; kk = index(arg,' ') ! Get some indices to extract object name from the string
  read(arg(k+1:kk),'(a)') ObjectID(iobject); read(arg(kk+1:),*) (Attributes(iobject,ia,iper), ia = 1, NumberAttributes) ! Get the object ID and the associated attributes
  if(iper == 1) ObjectOrder(iobject) = iobject
  do ia = 1, NumberAttributes
   if(Attributes(1,ia,iper) == 0.0) Attributes(1,ia,iper) = 1.d-5
  enddo
 enddo
 close(1)

enddo

deallocate(InputFilesArray)

!!!!!!!!!!!!!!! Normalize attributes by the corresponding attribute ranges !!!!!!!!!!!!!!!!!!!!!!!!
!(assuming the dataset is a cuboid with sides equal to the range of the attribute values in each dimension. Attribute ranges are used to normalize.)!

do i = 1, NumberAttributes
 attmin = minval(Attributes(:,i,:)) ! minimum value of an attribute among all objects and perturbed data sets
 attmax = maxval(Attributes(:,i,:)) ! maximum value of an attribute among all objects and perturbed data sets      
 attrange = attmax - attmin ! attribute range computed as the difference between the maximum and minimum attribute values
 Attributes(:,i,:) = Attributes(:,i,:)/attrange ! Normalize attributes by the corresponding range
enddo

end