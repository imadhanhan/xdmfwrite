# xdmfwrite

XDMFWRITE is a Matlab function that can be used to create an XDMF text file for an associated 3D H5 file. This is useful when attempting to visualize a 3D matrix in ParaView. As of January 2020, this function accepts an h5 file with multiple datasets (scalars only, no vector capability yet).

The inputs are as follows:
XDMFWRITE(FILENAME,SIZE,DATATYPE) creates an XDMF file with 3D extents given by SIZE and with an attribute dataset given by the h5 FILENAME with the datatype specified by DATATYPE. If DATATYPE is not specified, the default is double.

Example:  create an XDMF file for 'myfile.h5' that contains a fixed-size 100x200x300 dataset.
	xdmfwrite('myfile.h5',[100 200 300],'double');

Example:  create an XDMF file for a 3D matrix of ones in single single precision with a fized-size of 100x200x300.
	mydata=single(ones(100,200,300));
	h5create('myfile.h5','/myDataset',size(mydata), 'Datatype','single');
	h5write('myfile.h5','/myDataset', mydata);
	xdmfwrite('myfile.h5',size(mydata),'single');

Written by Imad Hanhan, 2019.
