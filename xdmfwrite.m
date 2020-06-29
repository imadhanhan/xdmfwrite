function xdmf = xdmfwrite(filename,size,datatype)
%XDMFWRITE  Create an XDMF text file for an associated 3D H5 file.
%   XDMFWRITE(FILENAME,SIZE,DATATYPE) creates an
%   XDMF file with 3D extents given by SIZE and with attribute datasets
%   given by the h5 FILENAME with the datatype specified by DATATYPE. 
%   If DATATYPE is not specified, the default is double.
%
%   Example:  create an XDMF file for 'myfile.h5' that contains a
%   fixed-size 100x200x300 dataset.
%      xdmfwrite('myfile.h5',[100 200 300],'double');
%
%   Example:  create an XDMF file for a 3D matrix of ones in single single
%   precision with a fized-size of 100x200x300.
%       mydata=single(ones(100,200,300));
%       h5create('myfile.h5','/myDataset',size(mydata), 'Datatype','single');
%       h5write('myfile.h5','/myDataset', mydata);
%       xdmfwrite('myfile.h5',size(mydata),'single');
%
%   Written by Imad Hanhan, 2019.


fileinfo=h5info([pwd, '/', filename]);
totalsets=length(fileinfo.Datasets);


%Check if datatype is given:
if exist('datatype', 'var')==0
    datatype='double';
end

% Write the XDMF file
xdmf = fopen([filename(1:end-3), '.xdmf'], 'w');

fprintf(xdmf, '%s\n', '<?xml version="1.0"?>');
fprintf(xdmf, '%s\n', '<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd"[]>');
fprintf(xdmf, '%s\n', '<Xdmf xmlns:xi="http://www.w3.org/2003/XInclude" Version="2.2">');
fprintf(xdmf, '%s\n', ' <Domain>');
fprintf(xdmf, '%s\n', ' ');
fprintf(xdmf, '%s\n', '  <Grid Name="Cell Data" GridType="Uniform">');
fprintf(xdmf, '%s\n', ['    <Topology TopologyType="3DCoRectMesh" Dimensions="',num2str(size(3)+1), ' ', num2str(size(2)+1), ' ', num2str(size(1)+1), '"></Topology>']);
fprintf(xdmf, '%s\n', '    <Geometry Type="ORIGIN_DXDYDZ">');
fprintf(xdmf, '%s\n', '      <!-- Origin -->');
fprintf(xdmf, '%s\n', '      <DataItem Format="XML" Dimensions="3">0 0 0</DataItem>');
fprintf(xdmf, '%s\n', '      <!-- DxDyDz (Spacing/Resolution)-->');
fprintf(xdmf, '%s\n', '      <DataItem Format="XML" Dimensions="3">1 1 1</DataItem>');
fprintf(xdmf, '%s\n', '    </Geometry>');

for i = 1: totalsets
    fprintf(xdmf, '%s\n', ' ');
    fprintf(xdmf, '%s\n', ['      <Attribute Name="', fileinfo.Datasets(i).Name, '" AttributeType="Scalar" Center="Cell">']);
    fprintf(xdmf, '%s\n', ['      <DataItem Format="HDF" Dimensions="',num2str(size(3)), ' ', num2str(size(2)), ' ', num2str(size(1)), '" NumberType="', datatype, '" Precision="4" >']);
    fprintf(xdmf, '%s\n', ['       ',filename, ':/',fileinfo.Datasets(i).Name ]);
    fprintf(xdmf, '%s\n', '      </DataItem>');
    fprintf(xdmf, '%s\n', '       </Attribute>');
    fprintf(xdmf, '%s\n', ' ');
end

fprintf(xdmf, '%s\n', '  </Grid>');
fprintf(xdmf, '%s\n', '    <!-- *************** END OF Cell Data *************** -->');
fprintf(xdmf, '%s\n', ' ');
fprintf(xdmf, '%s\n', ' </Domain>');
fprintf(xdmf, '%s\n', '</Xdmf>');

fclose(xdmf);
