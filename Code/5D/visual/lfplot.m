%function lfplot

% LFPLOT plots 2D slices of a light field l(nx,ny,nu,nv), with fixed
% (nx,ny), (ny,nv) and (nx,nu). Furthermore, EPI images (i.e. with fixed
% (ny,nv) and (nx,nu)) are plotted.
%
% Author - Chamira Edussooriya
% Date - July 23, 2013
% Last modified - Feb 06, 2021

clc;
close all;

%Reading input dataset from folder
folder_name = 'Dataset_video';
myFolder = sprintf('E:/Semester notes/Individual Research Project/%s', folder_name);

if ~isdir(myFolder)
errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
uiwait(warndlg(errorMessage));
return;
end
filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);
qarray = {'original LFV','reconstructed LFV with q value 1','reconstructed LFV with q value 25','reconstructed LFV with q value 120'};
for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    newFileName = erase(baseFileName,".mat");

    %loading lightfield video
    load(fullFileName);
    LF = lfv;
    clear lfv
    [Ny,Nx,Nv,Nu,Nc] = size(LF);

    minrgb = 0;         % minimum value of RGB components
    maxrgb = 255;     % maximum value of RGB components, 2^16-1 (16 bits)

    nxmin = 1;      % index for the first sub-aperture in x dimension
    nxmax = 8;      % index for the last sub-aperture in x dimension
    nymin = 1;     % index for the first sub-aperture in y dimension
    nymax = 8;     % index for the last sub-aperture in y dimension
    spc = 10;       % space between 2D images (in pixels)

    NvNy = Nv*(nymax-nymin+1) + spc*(nymax-nymin);
    NuNx = Nu*(nxmax-nxmin+1) + spc*(nxmax-nxmin);

    sais = zeros(NvNy,NuNx,Nc-1,'uint8');

    csai = squeeze(LF((Ny)/2,(Nx)/2,:,:,1:3));  % central SAI, uint8

    figure;
    imshow(csai,[minrgb,maxrgb]);
    qname = string(qarray(k));
    name = sprintf('%s%s', 'Central SAI of ',qname);
    title(name);

end 
%clear('LF');

