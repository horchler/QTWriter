function qtwriter_unittest(clearfiles)
%QTWRITER_UNITTEST  
%
%	Andrew D. Horchler, adh9@case.edu, Created 4-30-12, Modified: 4-30-12

%   CC BY-SA, Creative Commons Attribution-ShareAlike License
%   http://creativecommons.org/licenses/by-sa/3.0/


% Make sure QTWriter on path, otherwise ensure in right location and add it
if strfind(path,'QTWriter')
    if exist('QTWriter','class') ~= 8
        error('QTWriter:qtwriter_unittest:ClassNotFound',...
             ['The QTWriter directory is appears to be on the Matlab path, '...
              'but the QTWriter class cannot be found.']);
    end
    pathadded = false;
else
    if exist('QTWriter','dir') ~= 7
        error('QTWriter:qtwriter_unittest:DirectoryNotFound',...
             ['The QTWriter directory is not be on the Matlab path and the '...
              'QTWriter is in the same directory as this function.']);
    end
    addpath QTWriter
    if exist('QTWriter','class') ~= 8
        rmpath QTWriter
        error('QTWriter:qtwriter_unittest:ClassNotFoundAfterAdd',...
             ['The QTWriter directory was added to the Matlab path, but the '...
              'QTWriter class cannot be found.']);
    end
    pathadded = true;   % Will reset path at end
end

if nargin == 0
    clearfiles = false;
elseif ~islogical(clearfiles)
    error('QTWriter:qtwriter_unittest:NotLogicalInput',...
          'Input argument must be a logical value (true or false).');
end


% Create an animation
tic
hf = figure;
Z = peaks(19);
surf(Z);
frames = 4;
axis tight;
set(gca,'nextplot','replacechildren');


% Try block to ensure path is reset
try
% Default PNG compression
movObj = QTWriter('peaks_png_default.mov');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(hf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_default.mov');
end


% PNG compression, grayscale input, rgb output
movObj = QTWriter('peaks_png_rgb_grayinput.mov','Colorspace','rgb');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,rgb2gray(frame2im(getframe(hf))));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_rgb_grayinput.mov');
end


% PNG compression, rgb input (no alpha), rgb plus transparency output
movObj = QTWriter('peaks_png_transparency_rgbinput.mov','Transparency',true);

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(hf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_transparency_rgbinput.mov');
end


% PNG compression, rgb input (no alpha), gray rgb plus transparency output
movObj = QTWriter('peaks_png_gray_transparency_rgbinput.mov',...
    'Transparency',true,'ColorSpace','grayscale');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(hf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_gray_transparency_rgbinput.mov');
end


% PNG compression, gray input (no alpha), gray rgb plus transparency output
movObj = QTWriter('peaks_png_gray_transparency_grayinput.mov',...
    'Transparency',true,'ColorSpace','grayscale');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,rgb2gray(frame2im(getframe(hf))));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_gray_transparency_grayinput.mov');
end


% PNG compression, grayscale input (no alpha), rgb plus transpareny ouptut
movObj = QTWriter('peaks_png_transparency_grayinput.mov','Transparency',true);

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,rgb2gray(frame2im(getframe(hf))));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_transparency_grayinput.mov');
end


% PNG compression, grascale input, grayscale ouput
movObj = QTWriter('peaks_png_gray.mov','Colorspace','grayscale');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,rgb2gray(frame2im(getframe(hf))));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_gray.mov');
end


% PNG compression, rgb input, grayscale ouput
movObj = QTWriter('peaks_png_gray_rgbinput.mov','Colorspace','grayscale');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(hf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_png_gray_rgbinput.mov');
end


% Photo JPEG compression
movObj = QTWriter('peaks_jpg_default.mov','MovieFormat','Photo JPEG');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(hf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_jpg_default.mov');
end


% Photo JPEG compression, Quality 50
movObj = QTWriter('peaks_jpg_50.mov','MovieFormat','Photo JPEG','Quality',50);

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(hf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_jpg_50.mov');
end


% Photo JPEG compression, rgb input, grayscale output
movObj = QTWriter('peaks_jpg_gray.mov','MovieFormat','Photo JPEG',...
    'ColorSpace','grayscale');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(hf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
close(movObj);
clear movObj;
if clearfiles
    delete('peaks_jpg_gray.mov');
end

toc
disp('All 11 unit tests passed.')


% Reset path to prior state if directory was added
if pathadded
    rmpath QTWriter
end

catch err
    clear movObj;
    close hf;
    
    % Reset path to prior state if directory was added
    if pathadded
        rmpath QTWriter
    end
    
    rethrow(err);
end