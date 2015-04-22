function qtwriter_unittest(clearfiles)
%QTWRITER_UNITTEST  Suite of unit tests for QTWriter class
%   QTWRITER_UNITTEST locates and adds the QTWriter class to the Matlab path if
%   necessary and runs a series of tests. Each test outputs a short demo movie
%   file to the 'Unit Test Movies' directory in the current directory (if the
%   'Unit Test Movies' directory does not exist, it will be created). Various
%   permutations of movie formats and movie properties are evaluated. The movie
%   files should be opened in QuickTime Player to confirm their validity. Upon
%   successful completion of the tests, the QTWriter class is removed from the
%   path if it had been added. See the contents of this function for the details
%   of each test.
%
%   QTWRITER_UNITTEST(CLEARFILES) writes the movie file to a tempfile and
%   deletes this output file after each test. The input CLEARFILES is a logical
%   value (TRUE or FALSE).

%   Andrew D. Horchler, adh9 @ case . edu
%   Created: 4-30-12, Modified: 4-22-15


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

% Create movie directory if needed
if clearfiles
    tmp_moviename = tempname;
else
    movie_dir = dir('Unit Test Movies');
    if isempty(movie_dir)
        mkdir('Unit Test Movies');
    end
end

tic
tests = 0;
hf = figure;

% Try block to ensure path is reset
try

% Default PNG compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_default.mov';
end
movObj = QTWriter(moviefile);
outputmovie(movObj,clearfiles);
tests = tests+1;


% PNG compression, grayscale input, rgb output
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_rgb_grayinput.mov';
end
movObj = QTWriter(moviefile,'Colorspace','rgb');
outputmovie(movObj,clearfiles)
tests = tests+1;


% PNG compression, rgb input (no alpha), rgb plus transparency output
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_transparency_rgbinput.mov';
end
movObj = QTWriter(moviefile,'Transparency',true);
outputmovie(movObj,clearfiles)
tests = tests+1;


% PNG compression, rgb input (no alpha), gray rgb plus transparency output
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_gray_transparency_rgbinput.mov';
end
movObj = QTWriter(moviefile,'Transparency',true,'ColorSpace','grayscale');
outputmovie(movObj,clearfiles);
tests = tests+1;


% PNG compression, gray input (no alpha), gray rgb plus transparency output
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_gray_transparency_grayinput.mov';
end
movObj = QTWriter(moviefile,'Transparency',true,'ColorSpace','grayscale');
outputmovie(movObj,clearfiles);
tests = tests+1;


% PNG compression, grayscale input (no alpha), rgb plus transpareny ouptut
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_transparency_grayinput.mov';
end
movObj = QTWriter(moviefile,'Transparency',true);
outputmovie(movObj,clearfiles);
tests = tests+1;


% PNG compression, grascale input, grayscale ouput
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_gray.mov';
end
movObj = QTWriter(moviefile,'Colorspace','grayscale');
outputmovie(movObj,clearfiles);
tests = tests+1;


% PNG compression, rgb input, grayscale ouput
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_png_gray_rgbinput.mov';
end
movObj = QTWriter(moviefile,'Colorspace','grayscale');
outputmovie(movObj,clearfiles);
tests = tests+1;


% Photo JPEG compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_jpg_default.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo JPEG');
outputmovie(movObj,clearfiles);
tests = tests+1;


% Photo JPEG compression, Quality 50
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_jpg_50.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo JPEG','Quality',50);
outputmovie(movObj,clearfiles);
tests = tests+1;


% Photo JPEG compression, rgb input, grayscale output
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_jpg_gray.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo JPEG',...
    'ColorSpace','grayscale');
outputmovie(movObj,clearfiles);
tests = tests+1;


% Photo TIFF compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_tif_default.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF');
outputmovie(movObj,clearfiles);
tests = tests+1;


% TIFF compression, grayscale input, rgb output
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_tif_rgb_grayinput.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF','Colorspace','rgb');
outputmovie(movObj,clearfiles);
tests = tests+1;


% TIFF compression, grascale input, grayscale ouput
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_tif_gray.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF',...
    'Colorspace','grayscale');
outputmovie(movObj,clearfiles);
tests = tests+1;


% TIFF compression, rgb input, grayscale ouput
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_tif_gray_rgbinput.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF',...
    'Colorspace','grayscale');
outputmovie(movObj,clearfiles);
tests = tests+1;


% TIFF compression, uncompressed
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_tif_none.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF',...
    'CompressionType','none');
outputmovie(movObj,clearfiles);
tests = tests+1;


% TIFF compression, LZW compression type
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Unit Test Movies/peaks_tif_lzw.mov';
end
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF',...
    'CompressionType','lzw');
outputmovie(movObj,clearfiles);
tests = tests+1;


toc
disp(['All ' num2str(tests) ' unit tests passed.'])
close(hf);

% Reset path to prior state if directory was added
if pathadded
    rmpath QTWriter
end

catch err
    close(hf);
    clear movObj;
    
    % Reset path to prior state if directory was added
    if pathadded
        rmpath QTWriter
    end
    
    rethrow(err);
end

function outputmovie(movObj,clearfiles)
n = 19;
Z = peaks(n);
surf(Z);
frames = 4;
bound = ceil(max(abs(Z(:))));
axis([1 n 1 n -bound bound]);
set(gca,'nextplot','replacechildren');

% Animate plot and write movie
for k = 0:frames
	surf(sin(2*pi*k/frames)*Z,Z);

	% Vary the frame-rate
	movObj.FrameRate = k;

	% Write each frame to the file
	writeMovie(movObj,getframe(gcf));
end
 
% Set palindromic looping flag, Play All Frames flag, and Time-scale parameter
movObj.Loop = 'backandforth';
movObj.PlayAllFrames = true;
movObj.TimeScale = 1e3;
     
% Finish writing movie, close file, and clear object
if clearfiles
    delete(movObj.FileName);
end
close(movObj);
clear movObj;