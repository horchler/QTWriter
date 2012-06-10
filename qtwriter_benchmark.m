function qtwriter_benchmark(clearfiles,filename)
%QTWRITER_BENCHMARK  Suite of speed and file size tests for QTWriter class
%   QTWRITER_BENCHMARK locates and adds the QTWriter class to the Matlab path if
%   necessary and runs a series of tests. Each test outputs a short demo movie
%   file to the 'Benchmark Movies' directory in the current directory (if the
%   'Benchmark Movies' directory does not exist, it will be created). Various
%   permutations of movie formats and movie properties are evaluated. Upon
%   successful completetion of the benchmarks, the QTWriter class is removed
%   from the path if it had been added. See the contents of this function for
%   the details of each benchmark.
%
%   QTWRITER_BENCHMARK(CLEARFILES) deletes the output movie file after each
%   benchmark. The input CLEARFILES is a logical value (TRUE or FALSE).
%
%   QTWRITER_BENCHMARK(CLEARFILES,FILENAME) saves the benchmark results to a
%   text file specified by FILENAME, which may include a relative or absolute
%   absolute path. A '.txt' extension is added if FILENAME has no extension.

%   Andrew D. Horchler, adh9 @ case . edu
%   Created: 5-30-12, Modified: 6-2-12
%   CC BY-SA, Creative Commons Attribution-ShareAlike License
%   http://creativecommons.org/licenses/by-sa/3.0/


% Make sure QTWriter on path, otherwise ensure in right location and add it
if strfind(path,'QTWriter')
    if exist('QTWriter','class') ~= 8
        error('QTWriter:qtwriter_benchmark:ClassNotFound',...
             ['The QTWriter directory is appears to be on the Matlab path, '...
              'but the QTWriter class cannot be found.']);
    end
    pathadded = false;
else
    if exist('QTWriter','dir') ~= 7
        error('QTWriter:qtwriter_benchmark:DirectoryNotFound',...
             ['The QTWriter directory is not be on the Matlab path and the '...
              'QTWriter is in the same directory as this function.']);
    end
    addpath QTWriter
    if exist('QTWriter','class') ~= 8
        rmpath QTWriter
        error('QTWriter:qtwriter_benchmark:ClassNotFoundAfterAdd',...
             ['The QTWriter directory was added to the Matlab path, but the '...
              'QTWriter class cannot be found.']);
    end
    pathadded = true;   % Will reset path at end
end

if nargin == 0
    clearfiles = false;
elseif ~islogical(clearfiles)
    error('QTWriter:qtwriter_benchmark:NotLogicalInput',...
          'Input argument must be a logical value (true or false).');
end

if nargin > 1
    % Check that provided path and extension are valid
    filename = validatefilepath(filename,'.txt');

    % Check if file can be created or overwritten, output full path
    filename = validatefile(filename);
    
    fid = fopen(filename,'w+');
    fprintf(fid,['QTWriter 1.1 - Benchmark - ' datestr(now,0) '\n\n']);
else
    fid = 1;
end

% Create movie directory if needed
if clearfiles
    tmp_moviename = tempname;
else
    movie_dir = dir('Benchmark Movies');
    if isempty(movie_dir)
        mkdir('Benchmark Movies');
    end
end

tests = 0;
runs = 10;
frames = 9;

hf = figure;

% Create noise animation
R = rand(256,512,3,frames);

% Create gradient animation
hh = shiftdim(hsv(256),-1);
G = zeros(256,256,3,frames);
G(:,:,1,1) = (0:255)'/511*hh(1,:,1);
G(:,:,2,1) = (0:255)'/511*hh(1,:,2);
G(:,:,3,1) = (0:255)'/511*hh(1,:,3);
for i = 2:frames
    G(:,:,:,i) = min(1.3*G(:,:,:,i-1),1);
end


% Try block to ensure path is reset
try

% Initialize noise
hn = image(R(:,:,:,1));
axis equal
axis off
set(gca,'Units','normalized');

% Default PNG compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Benchmark Movies/noise_png_default.mov';
end

% Warm up functions by running though movie once
movObj = QTWriter(moviefile);
for k = 1:frames
    set(hn,'CData',R(:,:,:,k));
    frame = getframe(gca);
    writeMovie(movObj,frame);
end
close(movObj);

openMovietimetotal = zeros(1,runs);
animationtimetotal = zeros(1,runs);
getframetimetotal = zeros(1,runs);
writeMovietimetotal = zeros(1,runs);
saveMovietimetotal = zeros(1,runs);

for i = 1:runs
    % Open movie
    tic
    movObj = QTWriter(moviefile);
    openMovietimetotal(i) = toc;
    
    % Animate plot and write movie
    for k = 1:frames
        animationtime = tic;
        set(hn,'CData',R(:,:,:,k));
        animationtimetotal(i) = animationtimetotal(i)+toc(animationtime);
        
        % Get frame
        getframetime = tic;
        frame = getframe(gca);
        getframetimetotal(i) = getframetimetotal(i)+toc(getframetime);
        
        % Write each frame to the file
        writeMovietime = tic;
        writeMovie(movObj,frame);
        writeMovietimetotal(i) = writeMovietimetotal(i)+toc(writeMovietime);
    end
    
    % Finish writing movie
    tic
    close(movObj);
    saveMovietimetotal(i) = toc;
end

tests = tests+1;
if fid ~= 1 
    disp(['Benchmark ' int2str(tests) ' - RGB Noise - Default Photo PNG, RGB input, RGB output']);
end
fprintf(fid,['Benchmark ' int2str(tests) ' - RGB Noise - Default Photo PNG, RGB input, RGB output\n']);
outputbenchmark(moviefile,fid,openMovietimetotal,animationtimetotal,getframetimetotal,writeMovietimetotal,saveMovietimetotal);

% Close file, and clear object
clear movObj;
if clearfiles
    delete(moviefile);
end


% JPEG compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Benchmark Movies/noise_jpg_default.mov';
end

% Warm up functions by running though movie once
movObj = QTWriter(moviefile,'MovieFormat','Photo JPEG');
for k = 1:frames
    set(hn,'CData',R(:,:,:,k));
    frame = getframe(gca);
    writeMovie(movObj,frame);
end
close(movObj);

openMovietimetotal = zeros(1,runs);
animationtimetotal = zeros(1,runs);
getframetimetotal = zeros(1,runs);
writeMovietimetotal = zeros(1,runs);
saveMovietimetotal = zeros(1,runs);

for i = 1:runs
    % Open movie
    tic
    movObj = QTWriter(moviefile,'MovieFormat','Photo JPEG');
    openMovietimetotal(i) = toc;
    
    % Animate plot and write movie
    for k = 1:frames
        animationtime = tic;
        set(hn,'CData',R(:,:,:,k));
        animationtimetotal(i) = animationtimetotal(i)+toc(animationtime);
        
        % Get frame
        getframetime = tic;
        frame = getframe(gca);
        getframetimetotal(i) = getframetimetotal(i)+toc(getframetime);
        
        % Write each frame to the file
        writeMovietime = tic;
        writeMovie(movObj,frame);
        writeMovietimetotal(i) = writeMovietimetotal(i)+toc(writeMovietime);
    end

    % Finish writing movie
    tic
    close(movObj);
    saveMovietimetotal(i) = toc;
end

tests = tests+1;
if fid ~= 1 
    disp(['Benchmark ' int2str(tests) ' - RGB Noise - Photo JPEG, Quality 100, RGB input, RGB output']);
end
fprintf(fid,['Benchmark ' int2str(tests) ' - RGB Noise - Photo JPEG, Quality 100, RGB input, RGB output\n']);
outputbenchmark(moviefile,fid,openMovietimetotal,animationtimetotal,getframetimetotal,writeMovietimetotal,saveMovietimetotal);

% Close file, and clear object
clear movObj;
if clearfiles
    delete(moviefile);
end


% TIFF compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Benchmark Movies/noise_tif_default.mov';
end

% Warm up functions by running though movie once
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF');
for k = 1:frames
    set(hn,'CData',R(:,:,:,k));
    frame = getframe(gca);
    writeMovie(movObj,frame);
end
close(movObj);

openMovietimetotal = zeros(1,runs);
animationtimetotal = zeros(1,runs);
getframetimetotal = zeros(1,runs);
writeMovietimetotal = zeros(1,runs);
saveMovietimetotal = zeros(1,runs);

for i = 1:runs
    % Open movie
    tic
    movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF');
    openMovietimetotal(i) = toc;
    
    % Animate plot and write movie
    for k = 1:frames
        animationtime = tic;
        set(hn,'CData',R(:,:,:,k));
        animationtimetotal(i) = animationtimetotal(i)+toc(animationtime);
        
        % Get frame
        getframetime = tic;
        frame = getframe(gca);
        getframetimetotal(i) = getframetimetotal(i)+toc(getframetime);
        
        % Write each frame to the file
        writeMovietime = tic;
        writeMovie(movObj,frame);
        writeMovietimetotal(i) = writeMovietimetotal(i)+toc(writeMovietime);
    end

    % Finish writing movie
    tic
    close(movObj);
    saveMovietimetotal(i) = toc;
end

tests = tests+1;
if fid ~= 1 
    disp(['Benchmark ' int2str(tests) ' - RGB Noise - Photo TIFF, PackBits CompressionType, RGB input, RGB output']);
end
fprintf(fid,['Benchmark ' int2str(tests) ' - RGB Noise - Photo TIFF, PackBits CompressionType, RGB input, RGB output\n']);
outputbenchmark(moviefile,fid,openMovietimetotal,animationtimetotal,getframetimetotal,writeMovietimetotal,saveMovietimetotal);

% Close file, and clear object
clear movObj;
if clearfiles
    delete(moviefile);
end



% Initialize gradient
hg = image(G(:,:,:,1));
axis equal
axis off
set(gca,'Units','normalized');

% Default PNG compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Benchmark Movies/gradient_png_default.mov';
end

% Warm up functions by running though movie once
movObj = QTWriter(moviefile);
for k = 1:frames
    set(hg,'CData',G(:,:,:,k));
    frame = getframe(gca);
    writeMovie(movObj,frame);
end
close(movObj);

openMovietimetotal = zeros(1,runs);
animationtimetotal = zeros(1,runs);
getframetimetotal = zeros(1,runs);
writeMovietimetotal = zeros(1,runs);
saveMovietimetotal = zeros(1,runs);

for i = 1:runs
    % Open movie
    tic
    movObj = QTWriter(moviefile);
    openMovietimetotal(i) = toc;
    
    % Animate plot and write movie
    for k = 1:frames
        animationtime = tic;
        set(hg,'CData',G(:,:,:,k));
        animationtimetotal(i) = animationtimetotal(i)+toc(animationtime);
        
        % Get frame
        getframetime = tic;
        frame = getframe(gca);
        getframetimetotal(i) = getframetimetotal(i)+toc(getframetime);
        
        % Write each frame to the file
        writeMovietime = tic;
        writeMovie(movObj,frame);
        writeMovietimetotal(i) = writeMovietimetotal(i)+toc(writeMovietime);
    end
    
    % Finish writing movie
    tic
    close(movObj);
    saveMovietimetotal(i) = toc;
end

tests = tests+1;
if fid ~= 1 
    disp(['Benchmark ' int2str(tests) ' - RGB Gradient - Default Photo PNG, RGB input, RGB output']);
end
fprintf(fid,['Benchmark ' int2str(tests) ' - RGB Gradient - Default Photo PNG, RGB input, RGB output\n']);
outputbenchmark(moviefile,fid,openMovietimetotal,animationtimetotal,getframetimetotal,writeMovietimetotal,saveMovietimetotal);

% Close file, and clear object
clear movObj;
if clearfiles
    delete(moviefile);
end


% JPEG compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Benchmark Movies/gradient_jpg_default.mov';
end

% Warm up functions by running though movie once
movObj = QTWriter(moviefile,'MovieFormat','Photo JPEG');
for k = 1:frames
    set(hg,'CData',G(:,:,:,k));
    frame = getframe(gca);
    writeMovie(movObj,frame);
end
close(movObj);

openMovietimetotal = zeros(1,runs);
animationtimetotal = zeros(1,runs);
getframetimetotal = zeros(1,runs);
writeMovietimetotal = zeros(1,runs);
saveMovietimetotal = zeros(1,runs);

for i = 1:runs
    % Open movie
    tic
    movObj = QTWriter(moviefile,'MovieFormat','Photo JPEG');
    openMovietimetotal(i) = toc;
    
    % Animate plot and write movie
    for k = 1:frames
        animationtime = tic;
        set(hg,'CData',G(:,:,:,k));
        animationtimetotal(i) = animationtimetotal(i)+toc(animationtime);
        
        % Get frame
        getframetime = tic;
        frame = getframe(gca);
        getframetimetotal(i) = getframetimetotal(i)+toc(getframetime);
        
        % Write each frame to the file
        writeMovietime = tic;
        writeMovie(movObj,frame);
        writeMovietimetotal(i) = writeMovietimetotal(i)+toc(writeMovietime);
    end

    % Finish writing movie
    tic
    close(movObj);
    saveMovietimetotal(i) = toc;
end

tests = tests+1;
if fid ~= 1 
    disp(['Benchmark ' int2str(tests) ' - RGB Gradient - Photo JPEG, Quality 100, RGB input, RGB output']);
end
fprintf(fid,['Benchmark ' int2str(tests) ' - RGB Gradient - Photo JPEG, Quality 100, RGB input, RGB output\n']);
outputbenchmark(moviefile,fid,openMovietimetotal,animationtimetotal,getframetimetotal,writeMovietimetotal,saveMovietimetotal);

% Close file, and clear object
clear movObj;
if clearfiles
    delete(moviefile);
end


% TIFF compression
if clearfiles
    moviefile = [tmp_moviename int2str(tests) '.mov'];
else
    moviefile = 'Benchmark Movies/gradient_tif_default.mov';
end

% Warm up functions by running though movie once
movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF');
for k = 1:frames
    set(hg,'CData',G(:,:,:,k));
    frame = getframe(gca);
    writeMovie(movObj,frame);
end
close(movObj);

openMovietimetotal = zeros(1,runs);
animationtimetotal = zeros(1,runs);
getframetimetotal = zeros(1,runs);
writeMovietimetotal = zeros(1,runs);
saveMovietimetotal = zeros(1,runs);

for i = 1:runs
    % Open movie
    tic
    movObj = QTWriter(moviefile,'MovieFormat','Photo TIFF');
    openMovietimetotal(i) = toc;
    
    % Animate plot and write movie
    for k = 1:frames
        animationtime = tic;
        set(hg,'CData',G(:,:,:,k));
        animationtimetotal(i) = animationtimetotal(i)+toc(animationtime);
        
        % Get frame
        getframetime = tic;
        frame = getframe(gca);
        getframetimetotal(i) = getframetimetotal(i)+toc(getframetime);
        
        % Write each frame to the file
        writeMovietime = tic;
        writeMovie(movObj,frame);
        writeMovietimetotal(i) = writeMovietimetotal(i)+toc(writeMovietime);
    end

    % Finish writing movie
    tic
    close(movObj);
    saveMovietimetotal(i) = toc;
end

tests = tests+1;
if fid ~= 1 
    disp(['Benchmark ' int2str(tests) ' completed - RGB Gradient - Photo TIFF, PackBits CompressionType, RGB input, RGB output']);
end
fprintf(fid,['Benchmark ' int2str(tests) ' - RGB Gradient - Photo TIFF, PackBits CompressionType, RGB input, RGB output\n']);
outputbenchmark(moviefile,fid,openMovietimetotal,animationtimetotal,getframetimetotal,writeMovietimetotal,saveMovietimetotal);

% Close file, and clear object
clear movObj;
if clearfiles
    delete(moviefile);
end


if fid ~= 1 
    st = fclose(fid);
    if st ~= 0
        error('QTWriter:qtwriter_benchmark:FileCloseUnsuccessful',...
              'Unable to close file ''%s''',filename);
    end
end
close(hf);
disp(['Completed ' num2str(tests) ' benchmarks.'])

% Reset path to prior state if directory was added
if pathadded
    rmpath QTWriter
end

catch err
    clear movObj;
    fclose(fid);
    close(hf);
    
    % Reset path to prior state if directory was added
    if pathadded
        rmpath QTWriter
    end
    
    rethrow(err);
end


function outputbenchmark(moviefile,fid,openMovietime,animationtime,getframetime,writeMovietime,saveMovietime)

openMovietimemean = mean(openMovietime);
openMovietimemin = min(openMovietime);
openMovietimemax = max(openMovietime);

animationtimemean = mean(animationtime);
animationtimemin = min(animationtime);
animationtimemax = max(animationtime);

getframetimemean = mean(getframetime);
getframetimemin = min(getframetime);
getframetimemax = max(getframetime);

writeMovietimemean = mean(writeMovietime);
writeMovietimemin = min(writeMovietime);
writeMovietimemax = max(writeMovietime);

saveMovietimemean = mean(saveMovietime);
saveMovietimemin = min(saveMovietime);
saveMovietimemax = max(saveMovietime);

fprintf(fid,['Opening movie: ' num2str(openMovietimemean) ' seconds (Min: ' num2str(openMovietimemin) ', Max: ' num2str(openMovietimemax) ').\n']);
fprintf(fid,['Animating: ' num2str(animationtimemean) ' seconds (Min: ' num2str(animationtimemin) ', Max: ' num2str(animationtimemax) ').\n']);
fprintf(fid,['Getting frame: ' num2str(getframetimemean) ' seconds (Min: ' num2str(getframetimemin) ', Max: ' num2str(getframetimemax) ').\n']);
fprintf(fid,['Writing movie: ' num2str(writeMovietimemean) ' seconds (Min: ' num2str(writeMovietimemin) ', Max: ' num2str(writeMovietimemax) ').\n']);
fprintf(fid,['Saving movie: ' num2str(saveMovietimemean) ' seconds (Min: ' num2str(saveMovietimemin) ', Max: ' num2str(saveMovietimemax) ').\n']);
movieinfo = dir(moviefile);
moviefilesize = movieinfo.bytes/1e6;
fprintf(fid,['File size: ' num2str(moviefilesize,'%0.2f') ' MB.\n']);
fprintf(fid,'\n');


function filename=validatefile(filename)
if isempty(filename) || ~ischar(filename)
    error('QTWriter:qtwriter_benchmark:validatefile:EmptyFileString',...
          'The file name must be a non-empty string.');
end

% Check if file can be opened to read/write, create if doesn't exist
[fid,fidMessage] = fopen(filename,'a+');
if fid == -1
    error('QTWriter:qtwriter_benchmark:validatefile:FileOpenError',...
          'Unable to open file ''%s'':\n\n%s',filename,fidMessage);
end
st = fclose(fid);
if st ~= 0
    error('QTWriter:qtwriter_benchmark:validatefile:FileCloseUnsuccessful',...
          'Unable to close file ''%s''',filename);
end

[success,info] = fileattrib(filename);	%#ok<*ASGLU>
if usejava('jvm')
    filename = char(java.io.File(info.Name).getCanonicalPath());
else
    filename = info.Name;
end

    
function filename=validatefilepath(filename,extensions)
if isempty(filename) || ~ischar(filename)
    error('QTWriter:qtwriter_benchmark:validatefilepath:EmptyFileString',...
          'The file name must be a non-empty string.');
end

% Convert file separators if necessary and split into parts
filename = regexprep(filename,'[\/\\]',filesep);
[pathString,baseFile,extensionProvided] = fileparts(filename);

% Check that path to file exists
if isempty(pathString)
    pathString = pwd;
elseif exist(pathString,'dir') ~= 7
    error('QTWriter:qtwriter_benchmark:validatefilepath:InvalidFilePath',...
          'The specified directory, ''%s'', does not exist.',...
          pathString);
end

% Check that extension(s) are valid, remove leading period if needed
if nargin == 2
    if ~ischar(extensions)
        if isempty(extensions) || ~iscell(extensions)
            error('QTWriter:qtwriter_benchmark:validatefilepath:InvalidExtension',...
                 ['The optional extensions argument must be '...
                  'string or a non-empty cell array of strings.']);
        end

        if isempty(extensionProvided)
            extensionProvided = extensions{1};
        else
            % Go through cell array and remove any leading periods
            for i = 1:length(extensions)
                if isempty(extensions{i}) || ~ischar(extensions{i})
                    error('QTWriter:qtwriter_benchmark:validatefilepath:InvalidExtensionList',...
                         ['The optional extensions argument is '...
                          'a cell array, but one or more of its '...
                          'elements is empty or not a string.']);
                end
                extensions{i} = regexprep(extensions{i},'^(\.)','');
            end

            % Compare file name extension to those in extensions
            if ~any(strcmpi(extensionProvided(2:end),extensions))
                apos = {''''};
                period = {'.'};
                comma = {','};
                sp = {' '};
                v = ones(1,length(extensions));
                validExtensions = [apos(v);period(v);...
                                   extensions(:)';apos(v);...
                                   comma(v);sp(v)];
                validExtensions = cell2mat(validExtensions(:)');
                error('QTWriter:qtwriter_benchmark:validatefilepath:InvalidFileExtensions',...
                     ['File name must have one of the following ',...
                      'extensions: %s.'],validExtensions(1:end-2));
            end
        end
    else
        if isempty(extensions)
            error('QTWriter:qtwriter_benchmark:validatefilepath:EmptyFileExtension',...
                 ['The optional extensions argument must be '...
                  'non-empty string or non-empty cell array of '...
                  'strings.']);
        end

        if isempty(extensionProvided)
            extensionProvided = extensions;
        else
            extensions = regexprep(extensions,'^(\.)','');
            if ~strcmpi(extensionProvided(2:end),extensions)
                error('QTWriter:qtwriter_benchmark:validatefilepath:InvalidFileExtension',...
                      'File name must have a ''.%s'' extension.',...
                      extensions);
            end
        end
    end
end

filename = fullfile(pathString,[baseFile extensionProvided]);