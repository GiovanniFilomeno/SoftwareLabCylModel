clc,clear,close all

%% CREATE THE POLYGON 
states = shaperead('usastatehi.shp');
 st = states(5); %creates a polgon in the shape of the state 43 TEXAS 
   stBB = st.BoundingBox;
   st_minlat = min(stBB(:,2));
   st_maxlat = max(stBB(:,2));
   st_latspan = st_maxlat - st_minlat;
   st_minlong = min(stBB(:,1));
   st_maxlong = max(stBB(:,1));
   st_longspan = st_maxlong - st_minlong;
   stX = st.X;
   stY = st.Y;
   
%% SOME OLD VARIABLES

W=st_longspan; 
H=st_latspan;  

minRadius = 0.1;
Grow = 0.05;  
minGap=0;


%% CREATE THE SEED INSIDE THE POLYGON
 numPointsIn = 1;
   for i = 1:numPointsIn
        flagIsIn = 0;
        while ~flagIsIn
            x(i) = st_minlong + rand(1) * st_longspan;
            y(i) = st_minlat + rand(1) * st_latspan;
            r(i)=0.01;
            flagIsIn = inpolygon(x(i), y(i), stX, stY);
        end
   end
    
   
%% INITIAL CIRCLE

i=1;
totalCheck1=1;

while totalCheck1
r(i)=r(i)+Grow;

%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck1=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck1==0)
        r(i)=r(i)-Grow;
    end
    

end

%% TO THE RIGHT GROWING 
totalCheck2=1;
while totalCheck2
x(i)=x(i)+Grow;   
r(i)=r(i)+Grow;

%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck2=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck2==0)
        r(i)=r(i)-Grow;
        x(i)=x(i)-Grow;  
    end

end
%% TO THE RIGHT WITHOUT GROWING 
totalCheck3=1;
while totalCheck3
x(i)=x(i)+Grow;   

%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck3=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck3==0)
        x(i)=x(i)-Grow;  
    end

end

%% UPWARDS GROWING 
totalCheck4=1;
while totalCheck4
y(i)=y(i)+Grow; 
x(i)=x(i)-Grow;  
r(i)=r(i)+Grow;

%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck4=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck4==0)
        y(i)=y(i)-Grow; 
        x(i)=x(i)+Grow;  
        r(i)=r(i)-Grow;

    end

end
%% UPWARDS WITHOUT GROWING
totalCheck5=1;
while totalCheck5
y(i)=y(i)+Grow; 
x(i)=x(i)-Grow;  

%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck5=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck5==0)
        y(i)=y(i)-Grow; 
        x(i)=x(i)+Grow;  
    end

end
%% TO THE LEFT GROWING 
totalCheck6=1;
while totalCheck6
x(i)=x(i)-Grow;  
y(i)=y(i)-Grow; 
r(i)=r(i)+Grow;

%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck6=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck6==0)
      x(i)=x(i)+Grow;  
      y(i)=y(i)+Grow; 
      r(i)=r(i)-Grow;

    end

end
%% TO THE LEFT WITHOUT GROWING 
totalCheck7=1;
while totalCheck7
x(i)=x(i)-Grow;  
y(i)=y(i)-Grow; 


%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck7=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck7==0)
      x(i)=x(i)+Grow;  
      y(i)=y(i)+Grow; 
    end

end

%% DOWNWARDS 
totalCheck8=1;
while totalCheck8
x(i)=x(i)+Grow;  
y(i)=y(i)-Grow; 
r(i)=r(i)+Grow;

%check if the circle is inside
CheckCenter=inpolygon(x(i), y(i), stX, stY);
CheckRight=inpolygon(x(i)+r(i), y(i), stX, stY);
CheckUp=inpolygon(x(i), y(i)+r(i), stX, stY);
CheckLeft=inpolygon(x(i)-r(i), y(i), stX, stY);
CheckDown=inpolygon(x(i), y(i)-r(i), stX, stY);
totalCheck8=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;

    if (totalCheck8==0)
      x(i)=x(i)-Grow;  
      y(i)=y(i)+Grow; 
      r(i)=r(i)-Grow;

    end

end

%% CREATE OTHER CIRCLES 
counter=0;
while (counter<1000)
[xNew,yNew,rNew]=newCircle(st_minlong,st_longspan,st_minlat,st_latspan,stX,stY);

%GROW THE RADIOUS

    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        rNew=rNew+Grow;
    end
    rNew=rNew-Grow;
    
     %TO THE RIGHT GROWING
    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        xNew=xNew+Grow;
        rNew=rNew+Grow;
    end
    xNew=xNew-Grow;
    rNew=rNew-Grow;
    %TO THE RIGHT WITHOUT GROWING
    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        xNew=xNew+Grow;
    end
    xNew=xNew-Grow;
    %UPWARDS GROWING
    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        yNew=yNew+Grow;
        xNew=xNew-Grow;
        rNew=rNew+Grow;
    end
    yNew=yNew-Grow;
    xNew=xNew+Grow;
    rNew=rNew-Grow;
    %UPWARDS WITHOUT GROWING
    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        yNew=yNew+Grow;
    end
    yNew=yNew-Grow;
    %TO THE LEFT GROWING
    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        xNew=xNew-Grow;
        yNew=yNew-Grow;
        rNew=rNew+Grow;
    end
    yNew=yNew+Grow;
    xNew=xNew+Grow;
    rNew=rNew-Grow;
    %TO THE LEFT WITHOUT GROWING
    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        xNew=xNew-Grow;
    end
    xNew=xNew+Grow;
    %DOWNWARDS GROWING 
    while (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        
        yNew=yNew-Grow;
        xNew=xNew+Grow;
        rNew=rNew+Grow;
    end
    yNew=yNew+Grow;
    xNew=xNew-Grow;
    rNew=rNew-Grow;

% Append New Circle to List
  if (overlapCircles(x,y,r,xNew,yNew,rNew,minGap)==0&&metBoundary(xNew,yNew,rNew,stX,stY)==0)
        
        x = [x; xNew];
        y = [y; yNew];
        r = [r; rNew];
  end
  counter=counter+1;
end    
  
  
  
  
    %% FIGURE
    % Polygon
    mapshow(st, 'edgecolor', 'r', 'facecolor', 'none')
    %grid on
    hold on
    circles(x,y,r)
    %grid on 
    hold off
    
function [xNew_,yNew_,rNew_]=newCircle(st_minlong_,st_longspan_,st_minlat_,st_latspan_,stX_,stY_)
     flagIsIn = 0;
        while ~flagIsIn
            xNew_ = st_minlong_ + rand(1) * st_longspan_;
            yNew_ = st_minlat_ + rand(1) * st_latspan_;
            rNew_=0.01;
            flagIsIn = inpolygon(xNew_, yNew_, stX_, stY_);
        end
end

    
 function [test1] = overlapCircles(x_,y_,r_,xNew_,yNew_,rNew_,minGap_)
    
    % Test Overlap
    disBetweenCircles = hypot(x_-xNew_,y_-yNew_);
    combinedRadius = r_ + rNew_;

        if isempty(find(disBetweenCircles - combinedRadius <= minGap_))==0
            overlap = 1;
        else
            overlap = 0;
        end
        
       if (overlap == 1)
        test1 = 1;
       else 
        test1 = 0;
    end
 end 

 
 function [test2] =metBoundary(xNew_,yNew_,rNew_,stX_,stY_)
    %Test Boundary
    
    CheckCenter=inpolygon(xNew_, yNew_, stX_, stY_);
    CheckRight=inpolygon(xNew_+rNew_,yNew_, stX_, stY_);
    CheckUp=inpolygon(xNew_, yNew_+rNew_, stX_, stY_);
    CheckLeft=inpolygon(xNew_-rNew_, yNew_, stX_, stY_);
    CheckDown=inpolygon(xNew_, yNew_-rNew_, stX_, stY_);
    totalCheck=CheckCenter&&CheckRight&&CheckUp&&CheckLeft&&CheckDown;
    
    if (totalCheck==0)
        cuts = 1;
    else
        cuts = 0; 
    end
    
    if ( cuts == 1)
        test2 = 1;
    else 
        test2 = 0;
    end
 end


