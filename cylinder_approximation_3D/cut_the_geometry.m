function [FGR,VGR,NGR,FRD,VRD,NRD]=cut_the_geometry(Finput,Vinput,Ninput,cutvalue)
%
% cut_the_geometry divides a geometry from STL format into two parts at a 
% value in the Y axis
% 
%Inputs:
% :[Finput],[Vinput],[Ninput]: 3 matrices from a STL file  
% 
%Outputs: 
% 2 geometries in STL-like matrix format:
%
% :[FGR],[VGR],[NGR]: The green part "GR" is the geometry before the cutvalue 
% :[FRD],[VRD],[NRD]: Red part "RD" is the geometry after the cutvalue 
% 
% STL MATRICES
% [F...]= Faces matrix
% [V...]= Vertices matrix
% [N...]= Normal vectors matrix 

% INITIALIZING VARIABLES

% Classification of triangles
TrGreen=0;      % # triangles under the cut
TrBlue=0;       % # cutted triangles 
TrRed=0;        % # triangles above the cut 

% The blue (cutted) triangles are modifed. 
% The part before the cutvalue is NewGreen and after it is NewRed

TrNewGreen=0;   % # New green triangles
TrNewRed=0;     % # New red triangles

% STL new green triangles coming from blue triangles 
VNewGreen=zeros(1,3);
NNewGreen=zeros(1,3);

% STL new red triangles coming from blue triangles 
VNewRed=zeros(1,3);
NNewRed=zeros(1,3);

% Amount of triangles in the input STL file
AofT=length(Finput(:,1));

% Minimun Value of the gemetry in the Y axis
Ymin=min(Vinput(:,2));
Ycut=[Ymin cutvalue];

% These vectors help to identify the color (green, blue or red) of the ith tringle from the original STL 
Fgreen(1,1)=0;
Fblue(1,1)=0;
Fred(1,1)=0;

icut=2;

% FOR:It loops in every triangle of the input STL file
for i=1:AofT

    % Three vertices of the ith triangle 
    xt=Vinput(i*3-2:i*3,1);
    yt=Vinput(i*3-2:i*3,2);
    zt=Vinput(i*3-2:i*3,3);

    % Find the min and max value in y axis of the ith triangle 
    ymint=min(Vinput(i*3-2:i*3,2));
    ymaxt=max(Vinput(i*3-2:i*3,2));

    % GREEN triangle = before the cutvalue
    condition1= Ycut(1)<=ymint && ymint<=Ycut(icut)&& Ycut(1)<=ymaxt && ymaxt<=Ycut(icut);
    % BlUE triangle = cutted triangle
    condition2=Ycut(1)<=ymint && ymint<Ycut(icut) && ymaxt>Ycut(icut);
    % RED triangle = after the cutvalue
    condition3=ymint>=Ycut(icut) && ymaxt>Ycut(icut);


    % IF: it clasifies the triangle into GREEN, BLUE or RED 
    % and save the ith-value in a vector
    if condition1

       TrGreen=TrGreen+1;
       Fgreen(TrGreen,1)=i;

    elseif condition2
    
      TrBlue=TrBlue+1;
      Fblue(TrBlue,1)=i;
      
      % Vertices of the triangle
      Pnt1=[xt(1) yt(1) zt(1)];
      Pnt2=[xt(2) yt(2) zt(2)];
      Pnt3=[xt(3) yt(3) zt(3)];

      Trconfiguration=0; %initialize
      % Tupwards=1 means the triangles points upwards "^"
      Tupwards=0; %initialize

      % Tdownwards=1 means the triangles points downwards "V"
      Tdownwards=0; %initialize

      % IF conditional to find the triangle configuration
      if ( (yt(1)>=Ycut(icut) && yt(2)>=Ycut(icut) && yt(3)<Ycut(icut))||(yt(1)<=Ycut(icut) && yt(2)<=Ycut(icut)&& yt(3)>Ycut(icut)))

          %Line 1
          M11=Pnt1;
          u11=(Pnt3-Pnt1);
          %Line 2
          M12=Pnt2;
          u12=(Pnt3-Pnt2);
          Trconfiguration=1;

          Tdownwards=(yt(1)>=Ycut(icut) && yt(2)>=Ycut(icut) && yt(3)<Ycut(icut));
          Tupwards=(yt(1)<=Ycut(icut) && yt(2)<=Ycut(icut)&& yt(3)>Ycut(icut));

      elseif ( (yt(1)>=Ycut(icut) && yt(3)>=Ycut(icut)&& yt(2)<Ycut(icut))||(yt(1)<=Ycut(icut) && yt(3)<=Ycut(icut)&& yt(2)>Ycut(icut)))

          %Line 1
          M11=Pnt1;
          u11=(Pnt2-Pnt1);
          %Line 2
          M12=Pnt3;
          u12=(Pnt2-Pnt3);
          Trconfiguration=2;

          Tdownwards=(yt(1)>=Ycut(icut) && yt(3)>=Ycut(icut)&& yt(2)<Ycut(icut));
          Tupwards=(yt(1)<=Ycut(icut) && yt(3)<=Ycut(icut)&& yt(2)>Ycut(icut));

      elseif ( (yt(2)>=Ycut(icut) && yt(3)>=Ycut(icut) && yt(1)<Ycut(icut))||(yt(2)<=Ycut(icut) && yt(3)<=Ycut(icut)&& yt(1)>Ycut(icut)))
         %Line 1
          M11=Pnt2;
          u11=(Pnt1-Pnt2);
          %Line 2
          M12=Pnt3;
          u12=(Pnt1-Pnt3);
          Trconfiguration=3;

          Tdownwards=(yt(2)>=Ycut(icut) && yt(3)>=Ycut(icut) && yt(1)<Ycut(icut));
          Tupwards=(yt(2)<=Ycut(icut) && yt(3)<=Ycut(icut)&& yt(1)>Ycut(icut));


      end %End if conditional for the triangle configuration

      % 3D_line_1= M11 +alf*u11
      % 3D_line_2= M12 +bet*u12

      % Solve for alf and bet in the y-component == cut value  
      alf=(Ycut(icut)-M11(2))/u11(2);
      bet=(Ycut(icut)-M12(2))/u12(2);

      % Intersection points
      I1=M11+alf*u11;
      I2=M12+bet*u12;


      % REMESHING: from a cut triangle appear 3 new triagles
     if (Trconfiguration==1)

          % Triangle after cut
          Tr1Pnt1=[xt(3) yt(3) zt(3)];
          Tr1Pnt2=I1;
          Tr1Pnt3=I2;

          % Quadrilateral has to be divided into 2 triangles 
          Tr2Pnt1=[xt(1) yt(1) zt(1)];
          Tr2Pnt2=I1;
          Tr2Pnt3=I2;

          Tr3Pnt1=[xt(1) yt(1) zt(1)];
          Tr3Pnt2=[xt(2) yt(2) zt(2)];
          Tr3Pnt3=I2;

      elseif(Trconfiguration==2)

          % Triangle after cut
          Tr1Pnt1=[xt(2) yt(2) zt(2)];
          Tr1Pnt2=I1;
          Tr1Pnt3=I2;

          % Quadrilateral has to be divided into 2 triangles 
          Tr2Pnt1=[xt(1) yt(1) zt(1)];
          Tr2Pnt2=I1;
          Tr2Pnt3=I2;

          Tr3Pnt1=[xt(1) yt(1) zt(1)];
          Tr3Pnt2=[xt(3) yt(3) zt(3)];
          Tr3Pnt3=I2;

      elseif(Trconfiguration==3)

          % Triangle after the cut
          Tr1Pnt1=[xt(1) yt(1) zt(1)];
          Tr1Pnt2=I1;
          Tr1Pnt3=I2;

          % Quadrilateral has to be divided into 2 triangles
          Tr2Pnt1=[xt(2) yt(2) zt(2)];
          Tr2Pnt2=I1;
          Tr2Pnt3=I2;

          Tr3Pnt1=[xt(2) yt(2) zt(2)];
          Tr3Pnt2=[xt(3) yt(3) zt(3)];
          Tr3Pnt3=I2;

      end % END of REMESHING 

      %IF: to save the new triangles in the new STL files 
      if(Tdownwards)

          %If the triangle is pointing DOWNWARDS

          TrNewGreen=TrNewGreen+1;

          % Save the NEW GREEN triangle in the NEW GREEN STL file
          VNewGreen(TrNewGreen*3-2:TrNewGreen*3,1:3)=[Tr1Pnt1;Tr1Pnt2;Tr1Pnt3];
          NNewGreen(TrNewGreen,1:3)=Ninput(i,1:3);

          TrNewRed=TrNewRed+1;

          % Save the NEW 2 GREEN triangles in the NEW GREEN STL file
          VNewRed(TrNewRed*3-2:TrNewRed*3,1:3)=[Tr2Pnt1;Tr2Pnt2;Tr2Pnt3];
          NNewRed(TrNewRed,1:3)=Ninput(i,1:3);

          TrNewRed=TrNewRed+1;

          VNewRed(TrNewRed*3-2:TrNewRed*3,1:3)=[Tr3Pnt1;Tr3Pnt2;Tr3Pnt3];
          NNewRed(TrNewRed,1:3)=Ninput(i,1:3);

      elseif(Tupwards)

          % If the triangle is pointing UPWARDS

          TrNewRed=TrNewRed+1;

          % Save the NEW RED triangle in the NEW RED STL file
          VNewRed(TrNewRed*3-2:TrNewRed*3,1:3)=[Tr1Pnt1;Tr1Pnt2;Tr1Pnt3];
          NNewRed(TrNewRed,1:3)=Ninput(i,1:3);

          TrNewGreen=TrNewGreen+1;

          % Save the NEW 2 GREEN triangles in the NEW GREEN STL file
          VNewGreen(TrNewGreen*3-2:TrNewGreen*3,1:3)=[Tr2Pnt1;Tr2Pnt2;Tr2Pnt3];
          NNewGreen(TrNewGreen,1:3)=Ninput(i,1:3);

          TrNewGreen=TrNewGreen+1;

          VNewGreen(TrNewGreen*3-2:TrNewGreen*3,1:3)=[Tr3Pnt1;Tr3Pnt2;Tr3Pnt3];
          NNewGreen(TrNewGreen,1:3)=Ninput(i,1:3);

      end % end triangle DOWNWARDS OR UPWARDS
     

    % Condition 3 = RED triangle
    elseif condition3

       TrRed=TrRed+1;
       Fred(TrRed,1)=i;

    end %if conditional

end   % Loop triangles
    

% The original GREEN and RED trianlges have to be saved in the NEW STLs

% IF there are GREEN triangles THEN save them into the new GREEN STL file 
if (Fgreen~=0)
    
    kgreen=length(Fgreen(:,1));
    for k=1:kgreen 
        
        %Read which vertices V has the triangle in the input [F] matrix 
        Vt1=Finput(Fgreen(k,1),1);
        Vt2=Finput(Fgreen(k,1),2);
        Vt3=Finput(Fgreen(k,1),3);

        % Read the 3 vertices from the input [V] matrix
        xtgreen=[Vinput(Vt1,1) Vinput(Vt2,1) Vinput(Vt3,1)];
        ytgreen=[Vinput(Vt1,2) Vinput(Vt2,2) Vinput(Vt3,2)];
        ztgreen=[Vinput(Vt1,3) Vinput(Vt2,3) Vinput(Vt3,3)];

        % Add GREEN triangles to the NEW GREEN STL file
        VNewGreen(TrNewGreen*3+k*3-2:TrNewGreen*3+k*3,1:3)=[xtgreen(1) ytgreen(1) ztgreen(1);xtgreen(2) ytgreen(2) ztgreen(2);xtgreen(3) ytgreen(3) ztgreen(3)];
        NNewGreen(TrNewGreen+k,1:3)=[Ninput(Fgreen(k,1),1) Ninput(Fgreen(k,1),2) Ninput(Fgreen(k,1),3)];
        
    end
    
end

clear Vt1 Vt2 Vt3

% IF there are RED triangles THEN save them into the NEW RED STL file 
if(Fred~=0)
    
    kred=length(Fred(:,1));
    for k=1:kred 
        
        % Read which vertices V has the triangle in the input [F] matrix 
        Vt1=Finput(Fred(k,1),1);
        Vt2=Finput(Fred(k,1),2);
        Vt3=Finput(Fred(k,1),3);

        % Read the 3 vertices from the input [V] matrix
        xtred=[Vinput(Vt1,1) Vinput(Vt2,1) Vinput(Vt3,1)];
        ytred=[Vinput(Vt1,2) Vinput(Vt2,2) Vinput(Vt3,2)];
        ztred=[Vinput(Vt1,3) Vinput(Vt2,3) Vinput(Vt3,3)];
        
        % Add RED triangles to the NEW RED STL file
        VNewRed(TrNewRed*3+k*3-2:TrNewRed*3+k*3,1:3)=[xtred(1) ytred(1) ztred(1);xtred(2) ytred(2) ztred(2);xtred(3) ytred(3) ztred(3)];
        NNewRed(TrNewRed+k,1:3)=[Ninput(Fred(k,1),1) Ninput(Fred(k,1),2) Ninput(Fred(k,1),3)];
        
    end
    
end
clear Vt1 Vt2 Vt3

% Generate [F] matrices of the NEW STL files 
% Initialize the NEW [F] matrices "FNewGreen and FNewRed"
FNewGreen=zeros(length(NNewGreen(:,1)),3);
FNewRed=zeros(length(NNewRed(:,1)),3);

ig=1;
ir=1;

% Fill the NEW GREEN [F] matrix
for i=1:length(NNewGreen(:,1))
    for j=1:3
        FNewGreen(i,j)=ig;
        ig=ig+1;
    end
end


% Fill the NEW RED [F] matrix
for i=1:length(NNewRed(:,1))
    for j=1:3
        FNewRed(i,j)=ir;
        ir=ir+1;
    end
end

% Return the NEW STL files


% NEW GREEN STL file
FGR=FNewGreen;
VGR=VNewGreen;
NGR=NNewGreen;

% NEW RED STL file
FRD=FNewRed;
VRD=VNewRed;
NRD=NNewRed;


%CLEANING VARIABLES

TrGreen=0;  
TrBlue=0;   
TrRed=0;   
TrNewGreen=0;
TrNewRed=0;
FNewGreen=zeros(1,3);
VNewGreen=zeros(1,3);
NNewGreen=zeros(1,3); 
FNewRed=zeros(1,3);
VNewRed=zeros(1,3);
NNewRed=zeros(1,3);

end
