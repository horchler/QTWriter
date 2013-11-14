function [x,m]=getframebg(h)
%GETFRAMEBG  Get movie frame in background - a faster version of GETFRAME.
%   F = GETFRAMEBG captures a frame from the current figure. F is a structure
%   with 'cdata' and 'colormap' fields. F.cdata is a HEIGHT-by-WIDTH-by-3 uint8
%   matrix of image data and F.colormap is a double matrix that will be empty on
%   systems that use truecolor graphics.
%
%   [X,M] = GETFRAMEBG returns a frame from the current axis as separate image
%   data and colormap matrices, X and M, respectively.
%
%   [...] = GETFRAMEBG(H) captures a frame from the figure handle H.
%
%   Example:
%       surf(peaks);
%     	f = getframebg;
%       imshow(f.cdata);
%
%   Note: Unlike GETFRAME, GETFRAMEBG performs a low level screen capture and
%   thus figure windows being captured and even the Matlab environment do not
%   need to be in the foreground. GETFRAMEBG will continue to capture if a
%   screen saver activates. Additionally, to further improve performance,
%   GETFRAMEBG does not include an implicit call to DRAWNOW, so graphics will
%   not update unless this is added by the user.
%
%   See also GETFRAME, ADDFRAME, IM2FRAME, FRAME2IM, DRAWNOW, HARDCOPY.

% 	NOTE: This code relies on a semi-undocumented function, HARDCOPY, which may
% 	not exist in future Matlab releases.

%   Inspired by: http://mathworks.com/support/solutions/en/data/1-3NMHJ5/
%   Some code is loosely based on GETFRAME in Matlab R2012a. 

%   Andrew D. Horchler, adh9 @ case . edu
%   Created: 6-13-12, Modified: 11-12-13


% Check handle
if nargin == 0
    h = gcf;
else
    if length(h) ~= 1
        error('getframebg:NonScalarHandle',...
              'Input must be a scalar Handle Graphics object handle.');
    end
    if ~ishghandle(h,'Figure')
        error('getframebg:InvalidHandle',...
              'Input must be a Handle Graphics object figure handle.');
    end

    % Setting the visible property avoids implicit drawnow in figure
    if h ~= gcf
        set(h,'visible','on')
    end
end

% Get original paper position and units
original = get(h,{'PaperPositionMode','Units','Renderer'});

% Ensure paper position and units are reset to original values
resetOriginal = onCleanup(@()set(h,'PaperPositionMode',original{1},...
                          'Units',original{2}));

% Set paper position and units for hardcopy
set(h,'PaperPositionMode','auto','Units','pixels');

% Set renderer string for hardcopy
rendererString = ['-d' original{3}];
if ~any(strcmpi(rendererString,{'-dopengl','-dzbuffer'}))
    rendererString = '-dzbuffer';
end

% Get frame
x.cdata = hardcopy(h,rendererString,'-r0');
x.colormap = [];

% Check that hardcopy was successful
if length(x.cdata) < 3
    if strcmpi(rendererString,'-dopengl');
        error('getframebg:RenderFailedOpenGL',...
             ['GETFRAMEBG was unable to capture data and may be '...
              'incompatible with this usage case. Try setting the '...
              '''Renderer'' property of the parent figure to ''zbuffer'' '...
              'or use GETFRAME.']);
    else
        error('getframebg:RenderFailed',...
             ['GETFRAMEBG was unable to capture data and may be '...
              'incompatible with this usage case. Use GETFRAME.']);
    end
end

% Optional two output argument form
if nargout == 2
    m = x.colormap;
    x = x.cdata;
end