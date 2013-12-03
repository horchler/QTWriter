QTWriter
========
####Export QuickTime Movies with Matlab####
######Version 1.1, 12-3-13######
Download Repository: [ZIP Archive](https://github.com/horchler/QTWriter/archive/master.zip) (12 MB)  
Download just the ```QTWriter``` class, ```getframebg```, and ```strpenddemo``` M-files: [ZIP archive](https://github.com/horchler/QTWriter/raw/master/QTWriter.zip) (22.7 KB)  
View demo code and example exported movies on the project website: [http://horchler.github.io/QTWriter/](http://horchler.github.io/QTWriter/)  

========

[```QTWriter```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m) &nbsp;Create a QuickTime movie writer object.  

```OBJ = QTWriter(FILENAME)``` constructs a QTWriter object to write QuickTime movie data to a &ldquo;.mov&rdquo; file using lossless Photo PNG compression. ```FILENAME``` is a string enclosed in single quotation marks that specifies the name of the file to create. If ```FILENAME``` does not include an extension the QTWriter constructor appends the &ldquo;.mov&rdquo; extension. ```FILENAME``` can include an absolute or relative path.

```OBJ = QTWriter(...,'PropertyName','PropertyValue',...)``` specifies options via property name-value pairs. In addition to the default ```'Photo PNG'``` compression, ```'Photo TIFF'``` and ```'Photo JPEG'``` formats can be specified via the ```'MovieFormat'``` property. Lossless Photo TIFF compression yields larger file sizes than Photo PNG, but is faster (using ```'LZW'``` or the default ```'PackBits'``` for the ```'CompressionType'``` property). Photo JPEG is a lossy format and the ```'Quality'``` property can be used to specify the level of compression to use. The ```'ColorSpace'``` property specifies if the movie is to be output as 24-bit RGB truecolor or 8-bit grayscale. The ```'Transparency'``` property indicates if the movie is to be output with an alpha channel (Photo PNG format only).

Frames are written via the [```writeMovie(FRAME)```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m#L409-479) method of the QTWriter object. The frame rate of the movie can be continuously varied via the ```'FrameRate'``` property of the QTWriter object (see [```strpenddemo```](https://github.com/horchler/QTWriter/blob/master/strpenddemo.m)). The looping behavior of the output movie can be specified via the ```'Loop'``` property of the QTWriter object: ```'none'```, ```'loop'```, or ```'backandforth'```. Finally, the output movie can be forced to play every frame via the ```'PlayAllFrames'``` property of the QTWriter object. The [```close()```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m#L343-394) method of the QTWriter object is called to finish writing the movie and clean up associated data.

Please refer to the detailed help included within [```QTWriter```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m#L2-149) for further details and options.  
&nbsp;  

#####How to install (and uninstall) QTWriter:  
 1. Download and expand the *[QTWriter.zip](https://github.com/horchler/QTWriter/raw/master/QTWriter.zip)* ZIP archive.  
 2. Move the resultant *QTWriter* folder to the desired permanent location.  
 3. If you wish to add QTWriter to your Matlab path, navigate to *QTWriter/* and run [```QTWriter.install()```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m#L646-686). This adds the necessary files and folders to Matlab's search path. To uninstall QTWriter, run ```QTWriter.install('remove')```.  
 4. Type ```help QTWriter``` in the Matlab command window to view the documentation. See below for how to contribute code to the project. Email enquiries of any nature are always welcome.  
&nbsp; 

#####How to contribute fixes and new functionality to QTWriter:  
 1. Download and expand the *[QTWriter-master.zip](https://github.com/horchler/QTWriter/archive/master.zip)* ZIP archive of the full repository.  
 2. Move the resultant *QTWriter-master* folder to the desired permanent location. Rename this folder if desired. 
 3. If you wish to add QTWriter to your Matlab path, navigate to *QTWriter-master/QTWriter/* and run [```QTWriter.install()```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m#L646-686). This adds the necessary files and folders to Matlab's search path. To uninstall QTWriter, run ```QTWriter.install('remove')```.  
 4. To view and edit the code, type ```edit QTWriter``` in the Matlab command window.
 5. Two M-files are currently available for testing QTWriter: [```qtwriter_unittest```](https://github.com/horchler/QTWriter/blob/master/qtwriter_unittest.m) and [```qtwriter_benchmark```](https://github.com/horchler/QTWriter/blob/master/qtwriter_benchmark.m).
 6. Minor edits and bug reports and fixes can be submitted via email. To add new functionality or make propose major changes, please [fork the repository](https://help.github.com/articles/fork-a-repo). Any new features should be accompanied by some means of testing. Email with any questions.  
&nbsp;   

--------
  
Copyright &copy; Andrew D. Horchler, *adh9 @ case . edu*  
Created: 10-3-11, Revision: 1.1, 12-3-13  
License: BSD 3-clause license (see below)

QTWriter is inspired by [```MakeQTMovie```](https://engineering.purdue.edu/%7Emalcolm/interval/1999-066/MakeQTMovie.m) by Malcolm Slaney (Interval Research, March 1999) and  
parts are based on the [```VideoWriter```](http://www.mathworks.com/help/techdoc/ref/videowriterclass.html) class in Matlab R2011b.
    
References:  
&nbsp;&nbsp;&nbsp;&nbsp;&ndash;&nbsp;&nbsp;[MakeQTMovie - Create QuickTime movies in Matlab](https://engineering.purdue.edu/~malcolm/interval/1999-066/)  
&nbsp;&nbsp;&nbsp;&nbsp;&ndash;&nbsp;&nbsp;[QuickTime File Format Specification](https://developer.apple.com/library/mac/documentation/QuickTime/QTFF/QTFFPreface/qtffPreface.html)  
&nbsp;  

This version tested with Matlab 8.1.0.604 (R2013a)  
Mac OS X 10.9 Build: 13A603, Java 1.6.0_65-b14-462-11M4609  
QuickTime Player Pro 7.6.6 (1709), QuickTime Version 7.7.3 (2826), and QuickTime Player X 10.3 (727.1)  
Compatibility maintained back through Matlab 7.4 (R2007a)

--------

Copyright &copy; 2012&ndash;2013, Andrew D. Horchler  
All rights reserved.  

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of Case Western Reserve University nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ANDREW D. HORCHLER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.