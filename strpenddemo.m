function strpenddemo
%STRPENDDEMO  Simulate and animate string pendulum hanging between two cylinders
%
%   See also: QTWriter

%   Andrew D. Horchler, adh9 @ case . edu
%   Created: 3-7-01, Modified: 11-14-13


outputMovie = true;
variableRate = true;

% Parameters
R = 1;              % String length, cylinder diameter
g = 9.81;           % Gravity
if variableRate
    h = [0 3];      % Time-span
else
    h = 0:0.05:3;	%#ok<*UNRCH>
end
y0 = [0;2.3];       % Initial conditions: angle, angular rate

% Specify integration tolerances and event function
opts = odeset('RelTol',1e-4,'AbsTol',1e-6,'Events',@events);

tic
[t,y] = ode45(@(t,y)pendf(t,y,g/R),h,y0,opts);	% Integrate ode function pendf
disp(['Simulating: ' num2str(toc) ' seconds.']);

% Plot data: angle, angular rate, step-size, with true steps indicated
figure
subplot(311)
plot(t,y(:,1),'b',t(1:4:end),y(1:4:end,1),'k.')
title('String Pendulum - Simulation Data','Interpreter','latex')
ylabel('$\theta$ (rad)','Interpreter','latex')
axis tight
subplot(312)
plot(t,y(:,2),'b',t(1:4:end),y(1:4:end,2),'k.')
ylabel('$\dot{\theta}$ (rad/s)','Interpreter','latex')
axis tight
subplot(313)
plot(t,[0;diff(t)],'b',t(1:4:end),[0;diff(t(1:4:end))]/4,'k.')
xlabel('$time$ (sec)','Interpreter','latex')
ylabel('$time-step$ (sec)','Interpreter','latex')
axis tight


% Create movie object
if outputMovie
    tic
    movObj = QTWriter('strpenddemo.mov','MovieFormat','Photo PNG');
    disp(['Initializing movie: ' num2str(toc) ' seconds.']);
end

% Run animation of data simulated above
animtime = tic;
hf = figure;
axis equal
ax = [-1.6 1.6 -2.5 0.5]*R;
axis(ax);
%set(hf,'Renderer','painters','Color',[1 1 1]);	% Fast animation, many objects
%set(hf,'Renderer','zbuffer','Color',[1 1 1]); 	% Smooth fast animation
%set(hf,'DoubleBuffer','on','Color',[1 1 1]);	% Smooth animation, surf plots
set(hf,'Renderer','opengl','Color',[1 1 1]);  	% Smooth animation
ht = text(0,0,'String Pendulum Animation','FontSize',12);
tsz = get(ht,'Extent');
set(ht,'Position',[-0.5*tsz(3) -2.25*R 0]);
axis off
hold on

% Transform into x-y coordinates
n = 15;
angles = y(:,1)*(0:n)/n;
ay1 = abs(angles);
cy1 = cos(angles);
x1 = R*sign(angles).*(1-cy1);
y1 = -R*sin(ay1);
R2ay1 = R*(2-ay1(:,end));
x2 = x1(:,end)+R2ay1.*sin(y(:,1));
y2 = y1(:,end)-R2ay1.*cy1(:,end);

% Line, arc, and point for primary pendulum
xline = [x1 x2];
yline = [y1 y2];
zline = zeros(1,n+2);
radius = 0.05*R;
theta = 0:pi/20:2*pi;
z = ones(1,length(theta));
xcirc = bsxfun(@plus,x2(:,z),radius*cos(theta));
ycirc = bsxfun(@plus,y2(:,z),radius*sin(theta));
zcirc = z+1;

% Allocate handle vectors for fading animation
fadescale = 1/12;
fade = (4*fadescale:fadescale:1-fadescale)'*[1 1];
m = size(fade,1);
hfade_lines = zeros(1,m);
hfade_points = zeros(1,m);
line_colors = [fade ones(m,1)];
point_colors = [ones(m,1) fade];
for j = 1:m
    hfade_lines(j) = line(xline(1,:),yline(1,:),zline+j,'LineWidth',1,...
        'LineSmoothing','on','Visible','off');
    hfade_points(j) = patch(xcirc(1,:),ycirc(1,:),zcirc+2*j,...
        point_colors(j,:),'LineSmoothing','on','Visible','off');
end

% Draw initial condition
hline = line(xline(1,:),yline(1,:),zline+2*m+1,'Color',[0 0 0],...
    'LineWidth',2,'LineSmoothing','on');
hpoint = patch(xcirc(1,:),ycirc(1,:),zcirc+2*m+2,[1 0 0],'EdgeColor',[1 0 0],...
    'LineSmoothing','on');
patch(R*((xcirc(1,:)-x2(1))/radius-1),R*(ycirc(1,:)-y2(1))/radius,zcirc,...
    [0 0 0]+0.95,'EdgeColor',[0 0 0]+0.97,'LineSmoothing','on');
patch(R*((xcirc(1,:)-x2(1))/radius+1),R*(ycirc(1,:)-y2(1))/radius,zcirc,...
    [0 0 0]+0.95,'EdgeColor',[0 0 0]+0.97,'LineSmoothing','on');
patch(xline(1,1)+2*radius*[-1 0 1],yline(1,1)+2*radius*[1 0 1],[0 0 0]+2*m+3,...
    [0 0 0]+0.2,'EdgeColor',[0 0 0]+0.3,'LineSmoothing','on');
ht = text(-1.5*R,0.3*R,realmax,['Time: ' num2str(t(1),4) ' '],'FontSize',14);
hc = text(-1.5*R,0.1*R,realmax,'Frame: 1 ','FontSize',14);
hr = text(-1.5*R,-0.1*R,realmax,'   0 FPS ','FontSize',14);

% Get frame (implicit drawnow)
fps = 1./diff(t);
if outputMovie
    getframetime = tic;
    ha = gca;
    frame = getframe(ha);
    getframetimetotal = toc(getframetime);
    
    % Frame-rates
    movtime = tic;
    movObj.FrameRate = 0;
    
    % Write first frame
    movObj.writeMovie(frame);
    movtimetotal = toc(movtime);
else
    drawnow
end

% Animation loop
for i = 2:length(t)
    % Apply fading effect
    hfade_lines = hfade_lines([end 1:end-1]);
    hfade_points = hfade_points([end 1:end-1]);
    set(hfade_lines(1),'XData',xline(i-1,:),'YData',yline(i-1,:),...
        'Color',line_colors(1,:),'Visible','on');
    set(hfade_points(1),'XData',xcirc(i-1,:),'YData',ycirc(i-1,:),...
        'FaceColor',point_colors(1,:),'EdgeColor',point_colors(1,:),...
        'Visible','on');
    for j = 2:min(m,i-1)
        set(hfade_lines(j),'Color',line_colors(j,:));
        set(hfade_points(j),'FaceColor',point_colors(j,:),...
            'EdgeColor',point_colors(j,:));
    end
    
    % Update data for primary pendulum animation
    set(hline,'XData',xline(i,:),'YData',yline(i,:));
    set(hpoint,'XData',xcirc(i,:),'YData',ycirc(i,:));
    
    % Update frame counters
    set(ht,'String',['Time: ' num2str(t(i),4) ' ']);
    set(hc,'String',['Frame: ' num2str(i) ' ']);
    s = num2str(fps(i-1),4);
    set(hr,'String',[20+zeros(1,4-length(s)) s ' FPS ']);
    
    if outputMovie
    	% Get frame (implicit drawnow)
        getframetime = tic;
        frame = getframe(ha);
        getframetimetotal = getframetimetotal+toc(getframetime);
        
        % Set frame-rate and write frame
        movtime = tic;
        movObj.FrameRate = fps(i-1);
        movObj.writeMovie(frame);
        movtimetotal = movtimetotal+toc(movtime);
    else
        drawnow('expose')
    end
end

if outputMovie
    disp(['Animating: '...
        num2str(toc(animtime)-getframetimetotal-movtimetotal) ' seconds.']);
    disp(['Getting frame: ' num2str(getframetimetotal) ' seconds.']);
    disp(['Writing movie: ' num2str(movtimetotal) ' seconds.']);
    
    % Set looping property
    movObj.Loop = 'loop';
	
    % Finish writing movie and close movie object
    tic
    movObj.close();
    disp(['Saving movie: ' num2str(toc) ' seconds.']);
else
    disp(['Animating: ' num2str(toc(animtime)) ' seconds.']);
end



function ydot=pendf(t,y,gR) %#ok<INUSL>
ydot = [y(2);
        (sign(y(1))*y(2)^2-gR*sin(y(1)))/(2-abs(y(1)))];


function [value,isterminal,direction]=events(t,y)	%#ok<INUSL>
value = y(1);
isterminal = 1;
direction = 1;