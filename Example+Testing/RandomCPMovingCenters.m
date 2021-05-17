clc,clear,close all

%--------------------------------------------------------------------------
% References of the BASE CODE, not this one.
%--------------------------------------------------------------------------
% Coding Challenge #50.1 
% https://www.youtube.com/watch?v=QHEQuoIKgNE&t=1s
% Python Pygame Circle Packing - Coding Challenge 
% https://www.youtube.com/watch?v=HLUqDIOng80&feature=youtu.be

%-------------------------------------------------------------------------
%% Driving Variables
%-------------------------------------------------------------------------
W=2000; % mm ~ 8'
H=W;  % mm ~ 4'

% Desired Density 
densityDesired = 0.96;

% Minimum Circle Radius
minRadius = 20; % mm 

% Maximum Circle Radius - Govern by Code
maxRadius = 1000; % mm

% Gap Between Circles
minGap = 1; % mm

borderGap = 1; %mm
%-------------------------------------------------------------------------
%% Global Variables
%-------------------------------------------------------------------------

area = W*H;
density = 0;

% Add a Border Around Default Panel Size
xMin = borderGap;
xMax = W-borderGap;
yMin = borderGap;
yMax = H-borderGap;
areaBorder = (xMax-xMin)*(yMax-yMin);
densityBorder = 0;

% Number of Seed Circles
startCircles=1; 

% Seed the Circles a minimum Radius from the Border
x=randi([xMin+minRadius xMax-minRadius],startCircles,1);
y=randi([yMin+minRadius yMax-minRadius],startCircles,1);
r=minRadius*ones(startCircles,1);

% Factor to Grow the Radius Per Each Iteration
radGrow = 1;

% While Loop Iterations for Density
iterations = 0;
maxIterations = 1E6;

%-------------------------------------------------------------------------
%% Main Loop
%-------------------------------------------------------------------------

% Grow Initial Set Of Circles and Grow to Max Radius
for m = 1:startCircles
    % Grow Initial Set Of Circles and Grow to Max Radius
    for n= 1:H % Iterate To Max Width
        
        % Add Grow Factor to Radius
        r(m)=r(m)+radGrow;
        
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            r(m)=r(m)-radGrow;
            break
        end
    end
  
    % MOVE TO THE RIGHT GROWING 
   for j= 1:H
        
        % Add Grow Factor to Radius
        x(m)=x(m)+radGrow;
        r(m)=r(m)+radGrow; 
        
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            r(m)=r(m)-radGrow; 
            break
        end 
      
   end

  % MOVE TO THE RIGHT WITHOUT GROWING 
   for j= 1:H
        
        % Add Grow Factor to Radius
        x(m)=x(m)+radGrow;
        
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            x(m)=x(m)-radGrow;
            break
        end 
   end

   
  % MOVING UPWARDS GROWING
    for i= 1:H
        
        % Add Grow Factor to Radius
        y(m)=y(m)+radGrow;
        x(m)=x(m)-radGrow;
        r(m)=r(m)+radGrow;
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            y(m)=y(m)-radGrow;
            r(m)=r(m)-radGrow;
            break
        end
    end
    

 
  % MOVING UPWARDS WITHOUT GROWING
    for i= 1:H
        
        % Add Grow Factor to Radius
        y(m)=y(m)+radGrow;
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            y(m)=y(m)-radGrow;
            break
        end
    end
    
 
 
% MOVING TO THE LEFT GROWING
    for i= 1:H
        
        % Add Grow Factor to Radius
        x(m)=x(m)-radGrow;
        y(m)=y(m)-radGrow;
        r(m)=r(m)+radGrow;
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            x(m)=x(m)+radGrow;
            r(m)=r(m)-radGrow;
            break
        end
    end

 
 % MOVING TO THE LEFT WITHOUT GROWING
    for i= 1:H
        
        % Add Grow Factor to Radius
        x(m)=x(m)-radGrow;
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            x(m)=x(m)+radGrow;
            break
        end
    end
 
 
    % MOVING DOWN GROWING
    for i= 1:H
        
        % Add Grow Factor to Radius
        y(m)=y(m)-radGrow;
        x(m)=x(m)+radGrow;
        r(m)=r(m)+radGrow;
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            y(m)=y(m)+radGrow;
            r(m)=r(m)-radGrow;
            break
        end
    end
    
 
  % MOVING DOWN WITHOUT GROWING
    for i= 1:H
        
        % Add Grow Factor to Radius
        y(m)=y(m)-radGrow;
     
        % Test border and Size of Circles
        sizeTest=tests(x(m),y(m),r(m),xMin,xMax,yMin,yMax,maxRadius);

        if sizeTest == 1
            % Subtract Away Value That Broke the Test
            y(m)=y(m)+radGrow;
            break
        end
    end
    
end




% Begin Adding Circles and Detect Overlaps
while densityBorder < densityDesired
    % Generate a New Circle
    [xNew,yNew,rNew]=newCircle(xMin,xMax,yMin,yMax,minRadius);

    % Test if Circle Overlaps any Pre-Existing Circle with a Gap
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        rNew=rNew+radGrow;
    end
    
    % Subtract Growth Factor Since Last Test Failed
    rNew=rNew-radGrow;
    
    %TO THE RIGHT GROWING
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        xNew=xNew+radGrow;
        rNew=rNew+radGrow;
    end
    xNew=xNew-radGrow;
    rNew=rNew-radGrow;
    %TO THE RIGHT WITHOUT GROWING
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        xNew=xNew+radGrow;
    end
    xNew=xNew-radGrow;
    %UPWARDS GROWING
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        yNew=yNew+radGrow;
        xNew=xNew-radGrow;
        rNew=rNew+radGrow;
    end
    yNew=yNew-radGrow;
    xNew=xNew+radGrow;
    rNew=rNew-radGrow;
    %UPWARDS WITHOUT GROWING
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        yNew=yNew+radGrow;
    end
    yNew=yNew-radGrow;
    %TO THE LEFT GROWING
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        xNew=xNew-radGrow;
        yNew=yNew-radGrow;
        rNew=rNew+radGrow;
    end
    yNew=yNew+radGrow;
    xNew=xNew+radGrow;
    rNew=rNew-radGrow;
    %TO THE LEFT WITHOUT GROWING
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        xNew=xNew-radGrow;
    end
    xNew=xNew+radGrow;
    %DOWNWARDS GROWING 
    while overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        
        yNew=yNew-radGrow;
        xNew=xNew+radGrow;
        rNew=rNew+radGrow;
    end
    yNew=yNew+radGrow;
    xNew=xNew-radGrow;
    rNew=rNew-radGrow;
    
    % Re-Do Test Since an Initial New May Not H
    if overlapAndBoundary(x,y,r,xNew,yNew,rNew,xMin,xMax,yMin,yMax,maxRadius,minGap)==0
        % Append New Circle to List
        x = [x; xNew];
        y = [y; yNew];
        r = [r; rNew];
    end

    areaCovered=sum(pi*r.^2);
    density = areaCovered/area;
    densityBorder = areaCovered/areaBorder;
    
    iterations=iterations+1;
    
    if iterations > maxIterations
        break
    end
end
% Plot the Resulting Circles
drawCircs(x,y,r,W,H);

%-------------------------------------------------------------------------
%% Export a point list
%-------------------------------------------------------------------------
fid=fopen('pointlist.csv','w')
fprintf(fid,'%f,%f,%f,\r',[x y zeros(length(x),1)]');
fclose(fid);

%-------------------------------------------------------------------------
%% Export a DXF
%-------------------------------------------------------------------------
clc
fid = fopen('randCirclePanel.dxf','w');
fprintf(fid,'0\rSECTION\r2\rENTITIES\r0\r');
fprintf(fid,'CIRCLE\r8\r0\r10\r%f\r20\r%f\r40\r%f\r0\r',[x y r]');
fprintf(fid,'ENDSEC\r0\rEOF\r');
fid = fclose(fid);

%-------------------------------------------------------------------------
%% Calculate Laser Cutting Metrics
%-------------------------------------------------------------------------

totalCircleCirucumferenceMM = sum(2*pi*r);
totalCircleCirucumferenceIN = totalCircleCirucumferenceMM/25.4;

totalBorderMM =2*W+2*H;
totalBorderIN = totalBorderMM/25.4;

totalCutLengthsMM = totalCircleCirucumferenceMM + totalBorderMM;
totalCutLengthsIN = totalCutLengthsMM/25.4;

fprintf('Circle Density    - %0.1f%%\n',densityBorder * 100)
fprintf('Circle Number     - %d circles\n',length(x));
fprintf('Circle Cut Length - %0.3f inches\n',totalCircleCirucumferenceIN);
fprintf('Border Cut Length - %0.3f inches\n',totalBorderIN);
fprintf('\n');

%-------------------------------------------------------------------------
%% Functions
%-------------------------------------------------------------------------

% Size Test of One Circle to Boundaries
function sizeTest = tests(x_,y_,r_,xMin_,xMax_,yMin_,yMax_,maxRadius_)
    % Large or Test to Make sure circles to not overlap input boundaries or
    % Max Raidus
    if (x_ + r_ > xMax_ || x_ -  r_ < xMin_ || y_ + r_ > yMax_ || y_ -r_ < yMin_ || r_ > maxRadius_)
        sizeTest = 1;
    else
        sizeTest = 0; 
    end
end

% Test Overlap of new circle with all existing - ForLoop so Slow
function overlap = overLapTest(x_,y_,r_,xNew_,yNew_,rNew_,minGap_)
    % Test Overlap
    disBetweenCircles = hypot(x_-xNew_,y_-yNew_);
    combinedRadius = r_ + rNew_;

    if isempty(find(disBetweenCircles - combinedRadius <= minGap_))==0
        overlap = 1;
    else
        overlap = 0;
    end 
end

% Test Overlap and Boundary
function [test] = overlapAndBoundary(x_,y_,r_,xNew_,yNew_,rNew_,xMin_,xMax_,yMin_,yMax_,maxRadius_,minGap_)
    
    % Test Overlap
    disBetweenCircles = hypot(x_-xNew_,y_-yNew_);
    combinedRadius = r_ + rNew_;

        if isempty(find(disBetweenCircles - combinedRadius <= minGap_))==0
            overlap = 1;
        else
            overlap = 0;
        end       
    
    %Test Boundary
    
    if (xNew_ + rNew_ > xMax_ || xNew_ -  rNew_ < xMin_ || yNew_ + rNew_ > yMax_ || yNew_ -rNew_ < yMin_ || rNew_ > maxRadius_)
        b = 1;
    else
        b = 0; 
    end
    
    if (overlap == 1 || b == 1)
        test = 1;
    else 
        test = 0;
    end
end

function h = drawCircs(x_,y_,r_,W_,H_)
    circles(x_,y_,r_);
    axis equal;
    axis([0 W_ 0 H_]);
    grid on;
end

% Create a New Circle
function [xNew_,yNew_,rNew_]=newCircle(xMin_,xMax_,yMin_,yMax_,minRadius_)
    xNew_=randi([xMin_+minRadius_ xMax_-minRadius_],1,1);
    yNew_=randi([yMin_+minRadius_ yMax_-minRadius_],1,1);
    rNew_=minRadius_;
end