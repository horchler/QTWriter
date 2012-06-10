QTWriter
========
####Export QuickTime Movies with Matlab####
######Version 1.1, 6-9-12######

[```OBJ = QTWriter(FILENAME)```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m) constructs a QTWriter object to write QuickTime movie data to a &ldquo;.mov&rdquo; file using lossless Photo PNG compression. ```FILENAME``` is a string enclosed in single quotation marks that specifies the name of the file to create. If ```FILENAME``` does not include an extension the QTWriter constructor appends the &ldquo;.mov&rdquo; extension. ```FILENAME``` can include an absolute or relative path.

```OBJ = QTWriter(...,'PropertyName','PropertyValue',...)``` specifies options via property name-value pairs. In addition to the default ```'Photo PNG'``` compression, ```'Photo TIFF'``` and ```'Photo JPEG'``` formats can be specified via the ```'MovieFormat'``` property. Lossless Photo TIFF compression yields larger file sizes than Photo PNG, but is faster (using ```'LZW'``` or the default ```'PackBits'``` for the ```'CompressionType'``` property). Photo JPEG is a lossy format and the ```'Quality'``` property can be used to specify the level of compression to use. The ```'ColorSpace'``` property specifies if the movie is to be output as 24-bit RGB truecolor or 8-bit grayscale. The ```'Transparency'``` property indicates if the movie is to be output with an alpha channel (Photo PNG format only).

Frames are written via the [```writeMovie(FRAME)```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m#L372-442) method of the QTWriter object. The frame rate of the movie can be continuously varied via the ```'FrameRate'``` property of the QTWriter object (see [```STRPENDDEMO```](https://github.com/horchler/QTWriter/blob/master/strpenddemo.m)). The looping behavior of the output movie can be specified via the ```'Loop'``` property of the QTWriter object: ```'none'```, ```'loop'```, or ```'backandforth'```. Finally, the output movie can be forced to play every frame via the ```'PlayAllFrames'``` property of the QTWriter object. The [```close()```](https://github.com/horchler/QTWriter/blob/master/QTWriter/QTWriter.m#L306-353) method of the QTWriter object is called to finish writing the movie and clean up associated data.

View demo code and example exported movies on the project website: http://horchler.github.com/QTWriter/  

Download just the QTWriter class and STRPENDDEMO M-files as a [ZIP archive](https://github.com/horchler/QTWriter/raw/master/QTWriter.zip) (17.3 KB).

--------
  
Copyright &copy; Andrew D. Horchler, *adh9 @ case . edu*  
Created: 10-3-11, Revision: 1.1, 6-9-12  
CC BY-SA, [Creative Commons Attribution-ShareAlike License](http://creativecommons.org/licenses/by-sa/3.0/)  
  
QTWriter is inspired by [```MakeQTMovie```](https://engineering.purdue.edu/%7Emalcolm/interval/1999-066/MakeQTMovie.m) by Malcolm Slaney (Interval Research, March 1999) and  
parts are based on the [```VideoWriter```](http://www.mathworks.com/help/techdoc/ref/videowriterclass.html) class in Matlab R2011b.
    
References:
 - [MakeQTMovie - Create QuickTime movies in Matlab](https://engineering.purdue.edu/~malcolm/interval/1999-066/)
 - [QuickTime File Format Specification](http://developer.apple.com/library/mac/#documentation/QuickTime/QTFF)

This version tested with Matlab 7.14.0.739 (R2012a)  
Mac OS X 10.6.8 Build: 10K549, Java 1.6.0_31-b04-415-10M3635  
QuickTime Player Pro 7.6.6 (1709) Version 1790, QuickTime Player X 10.0 (131)  
Compatibility maintained back through Matlab 7.4 (R2007a)