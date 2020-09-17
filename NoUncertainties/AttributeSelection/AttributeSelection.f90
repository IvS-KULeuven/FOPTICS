implicit real(8) (a-h,o-z)
character(900) input_file, InputDirectory, OutputDirectory, FileExt, file_name, file_name_new, star_ID, arg
character(2000) string
real(8), allocatable :: Attributes(:)
integer, allocatable :: AttributeIndices(:)

call getarg(1,input_file) ! Get name of the input file from the command line
open(1,file=trim(adjustl(input_file)),status='old',iostat=ios) ! Open file and check whether it exists
if(ios /= 0) then
 write(*,"('Input file ',a,' does not exist or could not be opened')") trim(adjustl(input_file))
 stop
endif

read(1,"(a)") InputDirectory ! Get path to the input directory with all attribute files
k = 0; k = index(InputDirectory,'!',back=.true.); if(k /= 0) InputDirectory(k:) = ' ' ! Skip comments
read(1,"(a)") OutputDirectory ! Get path to the output directory where selected attributes will be stored in files
k = 0; k = index(OutputDirectory,'!',back=.true.); if(k /= 0) OutputDirectory(k:) = ' ' ! Skip comments
read(1,"(a)") FileExt ! Get file name extension
k = 0; k = index(FileExt,'!',back=.true.); if(k /= 0) FileExt(k:) = ' ' ! Skip comments
read(1,*) NumberAttributes, NumberSelectedAttributes ! Number of input and selected (in this order) attributes 
allocate(Attributes(NumberAttributes),AttributeIndices(NumberSelectedAttributes)) ! Array allocations
read(1,*) (AttributeIndices(i), i = 1, NumberSelectedAttributes)
close(1) ! Close input file

arg = ' '; write(arg,"('mkdir -p ',a)") trim(adjustl(OutputDirectory)); ios = system(trim(adjustl(arg)))

write(string,"('ls ',a,'*.* > attribute_files.txt')") trim(adjustl(InputDirectory)); ios = system(trim(adjustl(string))) ! Get files of all files in the input directory
open(1,file='attribute_files.txt',status='old',iostat=ios) ! Open file with attribute file names and check whether it exists
if(ios /= 0) then
 write(*,"('file attribute_files.txt does not exist or could not be opened')")
 stop
endif

do ! Infinite loop over the number of attribute files; it will be broken once all of the files have been processed
 read(1,"(a)",iostat=ios) file_name ! File name with attributes
 if(ios /= 0) exit
 open(2,file=trim(adjustl(file_name)),status='old',iostat=ios) ! Open the file with attributes and check whether it exists
 if(ios /= 0) then
  write(*,"('File with attributes ',a,' does not exist or could not be opened')") trim(adjustl(file_name))
  stop
 endif

 k = 0; k = index(file_name,'.',back=.true.); m = 0; m = index(file_name,'/',back=.true.)
 write(file_name_new,"(a,a,'_sel',a)") trim(adjustl(OutputDirectory)), trim(adjustl(file_name(m+1:k-1))), trim(adjustl(file_name(k:))) ! Name of the output file
 open(3,file=trim(adjustl(file_name_new))) ! Open output file

 do ! Infinite loop over the number of objects in a given attribute file; the loop will be broken once all objects have been processed
  read(2,"(a)",iostat=ios) string; if(ios /= 0) exit; kk = kk + 1
  do ! Infinite loop to get rid of possible NaN's in the attributes list. NaN's will be replace with zero's
   mm = 0; mm = index(string,'NaN'); nn = 0; nn = index(string,'Infinity')
   if(mm /= 0) then
    write(string(mm-1:mm+5),"('0.000  ')")
   elseif(nn /= 0) then
    write(string(nn-1:nn+7),"('0.000    ')")
   else
    exit
   endif
  enddo
  k = 0; k = index(string,trim(adjustl(FileExt)),back=.true.); k = k + len(trim(adjustl(FileExt))) ! Identify end of string and beginning of float numbers in a file line
  read(string(1:k),"(a)") star_ID; read(string(k+1:),*) (Attributes(i), i = 1, NumberAttributes) ! Read data from the attribute file
  Attributes(1) = dlog10(Attributes(1))

  string = ' '; write(string,"(a)") trim(adjustl(star_ID)) ! Write star id into a string
  do i = 1, NumberSelectedAttributes ! Loop over the number of selected attributes
   k = 0; k = len(trim(adjustl(string))); write(string(k+1:),"(' ',f13.8)") Attributes(AttributeIndices(i)) ! Write selected attributes into a string
  enddo
  write(3,"(a)") trim(adjustl(string))
 enddo
 close(2); close(3) ! close attributes files

enddo

close(1,status='delete') ! Delete temporary file
deallocate(Attributes,AttributeIndices) ! deallocate arrays

end