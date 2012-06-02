QTWriter
========
######Version 1.1, 5-26-12######

```OBJ = QTWriter(FILENAME)``` constructs a QTWriter object to write QuickTime movie data to a '.mov' file that lossless Photo PNG compression. ```FILENAME``` is a string enclosed in single quotation marks that specifies the name of the file to create. If ```FILENAME``` does not include an extension the QTWriter constructor appends the '.mov' extension. ```FILENAME``` can include an absolute or relative path.

```OBJ = QTWriter(...,'PropertyName','PropertyValue',...)``` specifies options via property name-value pairs. In addition to the default ```'Photo PNG'``` compression, ```'Photo TIFF'``` and ```'Photo JPEG'``` formats can be specified via the ```'MovieFormat'``` property. Lossless Photo TIFF compression yields larger file sizes than Photo PNG, but is faster (using ```'LZW'``` or the default ```'PackBits'``` ```'CompressionType'```). Photo JPEG is a lossy format and the ```'Quality'``` property can be used to specify the level of compression to use. The ```'ColorSpace'``` property specifies if the movie is to be output as 24-bit RGB truecolor or 8-bit grayscale. The ```'Transparency'``` property indicates if the movie is to be output with an alpha channel (Photo PNG format only).

Frames are written via the ```writeMovie(FRAME)``` method of the QTWriter object. The frame rate of the movie can be continuously varied via the ```'FrameRate'``` property of the QTWriter object (see ```STRPENDDEMO```). The looping behavior of the output movie can be specified via the 'Loop' property of the QTWriter object: ```'none'```, ```'loop'```, or ```'backandforth'```. Finally, the output movie can be forced to play every frame via the ```'PlayAllFrames'``` property of the QTWriter object. The close method of the QTWriter object is called to finish writing the movie and clean up associated data.
  

--------
  
QTWriter is inspired by MakeQTMovie by Malcolm Slaney (Interval Research, March 1999) and parts are based on the VideoWriter class in Matlab R2011b.
    
References:  
   https://engineering.purdue.edu/~malcolm/interval/1999-066/  
   http://developer.apple.com/library/mac/#documentation/QuickTime/QTFF  

Tested with Matlab 7.14.0.739 (R2012a)  
Mac OS X 10.6.8 Build: 10K549, Java 1.6.0_31-b04-415-10M3635  
Compatibility maintained back through Matlab 7.4 (R2007a)  

Andrew D. Horchler, adh9 @ case . edu  
Created: 10-3-11, Revision: 1.1, 5-26-12  
CC BY-SA, Creative Commons Attribution-ShareAlike License  
http://creativecommons.org/licenses/by-sa/3.0/