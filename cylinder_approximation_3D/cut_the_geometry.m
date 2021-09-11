function [VGR,NGR,FGR,VRD,NRD,FRD]=cut_the_geometry(Vinp,Ninp,Finp,cutvalue)

%Separating the triangles
TrGreen=0;  % Number of triangles under the cut
TrBlue=0;   % Cutted triangles
TrYellow=0; % Parallel to the cut
TrRed=0;    % Number of triangle above the cut 

TrNewGreen=0;
TrNewRed=0;

%STL new green triangles coming from blue triangles 
VNewGreen=zeros(1,3);
NNewGreen=zeros(1,3);

%STL new red triangles coming from blue triangles 
VNewRed=zeros(1,3);
NNewRed=zeros(1,3);

%Amount of triangles
AofT=length(Finp(:,1));

%Amount of vertices
AofP=length(Vinp(:,2));
Xmin=min(Vinp(:,1));
Xmax=max(Vinp(:,1));



%Vector containing (n-1) rings 
ncuts=7;
Xcut=[Xmin cutvalue];
%Xcut=[50 300];
Fgreen(1,1)=0;
Fblue(1,1)=0;
Fred(1,1)=0;

%for icut=2:(ncuts)
icut=2;
    for i=1:AofT

        % Three vertices of the ith triangle 
        xt=Vinp(i*3-2:i*3,1);
        yt=Vinp(i*3-2:i*3,2);
        zt=Vinp(i*3-2:i*3,3);

        % Find the min and max of the ith triangle 
        xmint=min(Vinp(i*3-2:i*3,1));
        xmaxt=max(Vinp(i*3-2:i*3,1));

        condition1= Xcut(1)<=xmint && xmint<=Xcut(icut)&& Xcut(1)<=xmaxt && xmaxt<=Xcut(icut);
        condition2=Xcut(1)<=xmint && xmint<=Xcut(icut) && xmaxt>Xcut(icut);
        condition3=xmint>Xcut(icut) && xmaxt>Xcut(icut);
        

        %Triangles under the cut 
        if condition1

           %fill3(xt,yt,zt,'g');
           %hold on    
           TrGreen=TrGreen+1;
        %Save which i 

           Fgreen(TrGreen,icut-1)=i;


        % Triangles that are cut by the plane 
        elseif condition2

          %Modifying the cut planes 
          % Normal vector of the ith triangle
          N1=[Ninp(i,1) Ninp(i,2) Ninp(i,3)];
          %Normal vector of the cutting plane 
          N2=[1 0 0];
          % A point the plane of the ith triangle
          % CALCULATE THE INCETRUM

          Pnt1=[xt(1) yt(1) zt(1)];
          Pnt2=[xt(2) yt(2) zt(2)];
          Pnt3=[xt(3) yt(3) zt(3)];


          A1=[xt(3) yt(3) zt(3)];
          % A point in the cutting plane 
          A2=[Xcut(icut) 1 1];
          %Parametric equation of a line in 3D = Nalg +alphA*Palg
          [Palg,Nalg,check]=plane_intersect(N1,A1,N2,A2);

          if (check==1||check==0)
                  %fill3(xt,yt,zt,'y');
                  %hold on  
                  TrYellow=TrYellow+1;
          elseif(check==2)
                  %fill3(xt,yt,zt,'b');
                  %hold on
                  TrBlue=TrBlue+1;
                  Fblue(TrBlue,icut-1)=i;


                  % At this point the intersection line betweeen the cutting
                  % plane and the ith triangle is found



                  Trconfiguration=0;
                  % Tupwards=1 means the triangles points upwards "^"
                  Tupwards=0; %initialize
                  
                  % Tdownwards=1 means the triangles points downwards "V"
                  Tdownwards=0; %initialize
                     
                  % if conditional to find the triangle configuration
                  if ( (xt(1)>=Xcut(icut) && xt(2)>=Xcut(icut) && xt(3)<Xcut(icut))||(xt(1)<=Xcut(icut) && xt(2)<=Xcut(icut)&& xt(3)>Xcut(icut)))

                      %Line 1
                      M11=Pnt1;
                      u11=(Pnt3-Pnt1);
                      %Line 2
                      M12=Pnt2;
                      u12=(Pnt3-Pnt2);
                      Trconfiguration=1;
                      
                      Tdownwards=(xt(1)>=Xcut(icut) && xt(2)>=Xcut(icut) && xt(3)<Xcut(icut));
                      Tupwards=(xt(1)<=Xcut(icut) && xt(2)<=Xcut(icut)&& xt(3)>Xcut(icut));
                      
                  elseif ( (xt(1)>=Xcut(icut) && xt(3)>=Xcut(icut)&& xt(2)<Xcut(icut))||(xt(1)<=Xcut(icut) && xt(3)<=Xcut(icut)&& xt(2)>Xcut(icut)))

                      %Line 1
                      M11=Pnt1;
                      u11=(Pnt2-Pnt1);
                      %Line 2
                      M12=Pnt3;
                      u12=(Pnt2-Pnt3);
                      Trconfiguration=2;
                      
                      Tdownwards=(xt(1)>=Xcut(icut) && xt(3)>=Xcut(icut)&& xt(2)<Xcut(icut));
                      Tupwards=(xt(1)<=Xcut(icut) && xt(3)<=Xcut(icut)&& xt(2)>Xcut(icut));

                  elseif ( (xt(2)>=Xcut(icut) && xt(3)>=Xcut(icut) && xt(1)<Xcut(icut))||(xt(2)<=Xcut(icut) && xt(3)<=Xcut(icut)&& xt(1)>Xcut(icut)))
                     %Line 1
                      M11=Pnt2;
                      u11=(Pnt1-Pnt2);
                      %Line 2
                      M12=Pnt3;
                      u12=(Pnt1-Pnt3);
                      Trconfiguration=3;
                      
                      Tdownwards=(xt(2)>=Xcut(icut) && xt(3)>=Xcut(icut) && xt(1)<Xcut(icut));
                      Tupwards=(xt(2)<=Xcut(icut) && xt(3)<=Xcut(icut)&& xt(1)>Xcut(icut));
                      
                      
                  end %End if conditional for the triangle configuration



                  alf=(Xcut(icut)-M11(1))/u11(1);
                  bet=(Xcut(icut)-M12(1))/u12(1);

                  I1=M11+alf*u11;
                  I2=M12+bet*u12;


                  %plot3(I1(1),I1(2),I1(3),'*')
                  %hold on 


                  %plot3(I2(1),I2(2),I2(3),'o')
                  %hold on 
                  
                  
                  % REMESHING 
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

                  end % END of REMESHING from a cut triangle appear 3 new triagles
                      
                  if(Tdownwards)
                      
                      %If the triangle is pointing DOWNWARDS
                      %Tr1 is NEW GREEN
                      xtnewgr=[Tr1Pnt1(1) Tr1Pnt2(1) Tr1Pnt3(1)];
                      ytnewgr=[Tr1Pnt1(2) Tr1Pnt2(2) Tr1Pnt3(2)];
                      ztnewgr=[Tr1Pnt1(3) Tr1Pnt2(3) Tr1Pnt3(3)];
                      
                      %fill3(xtnewgr,ytnewgr,ztnewgr,'c');
                      %hold on
                      
                      %Tr2 and Tr3 are NEW RED
                      
                      xtnewred1=[Tr2Pnt1(1) Tr2Pnt2(1) Tr2Pnt3(1)];
                      ytnewred1=[Tr2Pnt1(2) Tr2Pnt2(2) Tr2Pnt3(2)];
                      ztnewred1=[Tr2Pnt1(3) Tr2Pnt2(3) Tr2Pnt3(3)];
                      
                      xtnewred2=[Tr3Pnt1(1) Tr3Pnt2(1) Tr3Pnt3(1)];
                      ytnewred2=[Tr3Pnt1(2) Tr3Pnt2(2) Tr3Pnt3(2)];
                      ztnewred2=[Tr3Pnt1(3) Tr3Pnt2(3) Tr3Pnt3(3)];
                      
                      %fill3(xtnewred1,ytnewred1,ztnewred1,'m');
                      %hold on
                      %fill3(xtnewred2,ytnewred2,ztnewred2,'m');
                      %hold on
                      
                      TrNewGreen=TrNewGreen+1;
                      
                      VNewGreen(TrNewGreen*3-2:TrNewGreen*3,1:3)=[Tr1Pnt1;Tr1Pnt2;Tr1Pnt3];
                      NNewGreen(TrNewGreen,1:3)=Ninp(i,1:3);
                      
                      TrNewRed=TrNewRed+1;
                      
                      VNewRed(TrNewRed*3-2:TrNewRed*3,1:3)=[Tr2Pnt1;Tr2Pnt2;Tr2Pnt3];
                      NNewRed(TrNewRed,1:3)=Ninp(i,1:3);
                      
                      TrNewRed=TrNewRed+1;
                      
                      VNewRed(TrNewRed*3-2:TrNewRed*3,1:3)=[Tr3Pnt1;Tr3Pnt2;Tr3Pnt3];
                      NNewRed(TrNewRed,1:3)=Ninp(i,1:3);

                  elseif(Tupwards)
                      
                      %If the triangle is pointing UPWARDS
                      %Tr1 is NEW RED
                      xtnewred=[Tr1Pnt1(1) Tr1Pnt2(1) Tr1Pnt3(1)];
                      ytnewred=[Tr1Pnt1(2) Tr1Pnt2(2) Tr1Pnt3(2)];
                      ztnewred=[Tr1Pnt1(3) Tr1Pnt2(3) Tr1Pnt3(3)];
                      
                      %fill3(xtnewred,ytnewred,ztnewred,'m');
                      %hold on
                      
                      %Tr2 and Tr3 are NEW GREEN
                      xtnewgr1=[Tr2Pnt1(1) Tr2Pnt2(1) Tr2Pnt3(1)];
                      ytnewgr1=[Tr2Pnt1(2) Tr2Pnt2(2) Tr2Pnt3(2)];
                      ztnewgr1=[Tr2Pnt1(3) Tr2Pnt2(3) Tr2Pnt3(3)];
                      
                      xtnewgr2=[Tr3Pnt1(1) Tr3Pnt2(1) Tr3Pnt3(1)];
                      ytnewgr2=[Tr3Pnt1(2) Tr3Pnt2(2) Tr3Pnt3(2)];
                      ztnewgr2=[Tr3Pnt1(3) Tr3Pnt2(3) Tr3Pnt3(3)];
                      
                      %fill3(xtnewgr1,ytnewgr1,ztnewgr1,'c');
                      %hold on
                      
                      %fill3(xtnewgr2,ytnewgr2,ztnewgr2,'c');
                      %hold on
                      
                      
                      TrNewRed=TrNewRed+1;
                      
                      VNewRed(TrNewRed*3-2:TrNewRed*3,1:3)=[Tr1Pnt1;Tr1Pnt2;Tr1Pnt3];
                      NNewRed(TrNewRed,1:3)=Ninp(i,1:3);
                      
                      TrNewGreen=TrNewGreen+1;
                      
                      VNewGreen(TrNewGreen*3-2:TrNewGreen*3,1:3)=[Tr2Pnt1;Tr2Pnt2;Tr2Pnt3];
                      NNewGreen(TrNewGreen,1:3)=Ninp(i,1:3);
                      
                      TrNewGreen=TrNewGreen+1;
                      
                      VNewGreen(TrNewGreen*3-2:TrNewGreen*3,1:3)=[Tr3Pnt1;Tr3Pnt2;Tr3Pnt3];
                      NNewGreen(TrNewGreen,1:3)=Ninp(i,1:3);
                      
                  end % end triangle DOWNWARDS OR UPWARDS
                  

          end % if conditional blue triangles 

        %Triangles that are above the plane  
        elseif condition3

           %fill3(xt,yt,zt,'r');
           %hold on
           TrRed=TrRed+1;
           Fred(TrRed,icut-1)=i;
        
        end %if conditional

    end   % Loop triangles
    
    %TrGreen=0;
    %TrBlue=0;
    %TrRed=0;
    %TrYellow=0;

%end   % Loop cuts


%NEW STL's

%PUT THE GREEN TRIANGLES IN THE NEW MATRICES
%f2= figure;

%Read which face in the matrix Fgreen

if (Fgreen~=0)
    kgreen=length(Fgreen(:,1));

    for k=1:kgreen 
    %Read in the original F matrix which vertices V

        Vt1=Finp(Fgreen(k,1),1);
        Vt2=Finp(Fgreen(k,1),2);
        Vt3=Finp(Fgreen(k,1),3);

        %Read the 3 vertices from the original V vector 

        xtgreen=[Vinp(Vt1,1) Vinp(Vt2,1) Vinp(Vt3,1)];
        ytgreen=[Vinp(Vt1,2) Vinp(Vt2,2) Vinp(Vt3,2)];
        ztgreen=[Vinp(Vt1,3) Vinp(Vt2,3) Vinp(Vt3,3)];

        %Plot the triangle 
        %fill3(xtgreen,ytgreen,ztgreen,'g');
        %hold on
        % Add green triangles to the new Vector
        VNewGreen(TrNewGreen*3+k*3-2:TrNewGreen*3+k*3,1:3)=[xtgreen(1) ytgreen(1) ztgreen(1);xtgreen(2) ytgreen(2) ztgreen(2);xtgreen(3) ytgreen(3) ztgreen(3)];
        NNewGreen(TrNewGreen+k,1:3)=[Ninp(Fgreen(k,1),1) Ninp(Fgreen(k,1),2) Ninp(Fgreen(k,1),3)];
    end
end

clear Vt1 Vt2 Vt3
%PUT THE RED TRIANGLES IN THE NEW MATRICES
%f4= figure;

%Read which face in the matrix Fgreen

if(Fred~=0)
    kred=length(Fred(:,1));

    for k=1:kred 
    %Read in the original F matrix which vertices V

        Vt1=Finp(Fred(k,1),1);
        Vt2=Finp(Fred(k,1),2);
        Vt3=Finp(Fred(k,1),3);

        %Read the 3 vertices from the original V vector 

        xtred=[Vinp(Vt1,1) Vinp(Vt2,1) Vinp(Vt3,1)];
        ytred=[Vinp(Vt1,2) Vinp(Vt2,2) Vinp(Vt3,2)];
        ztred=[Vinp(Vt1,3) Vinp(Vt2,3) Vinp(Vt3,3)];

        %Plot the triangle 
        %fill3(xtred,ytred,ztred,'r');
        %hold on

        %ADD THE RED TRIANGLES TO THE NEW MATRICES
        VNewRed(TrNewRed*3+k*3-2:TrNewRed*3+k*3,1:3)=[xtred(1) ytred(1) ztred(1);xtred(2) ytred(2) ztred(2);xtred(3) ytred(3) ztred(3)];
        NNewRed(TrNewRed+k,1:3)=[Ninp(Fred(k,1),1) Ninp(Fred(k,1),2) Ninp(Fred(k,1),3)];


    end
end
clear Vt1 Vt2 Vt3
%CREATE THE NEW FACE VECTORS FNewGreen & FNewRed 

FNewGreen=zeros(length(NNewGreen(:,1)),3);
FNewRed=zeros(length(NNewRed(:,1)),3);

% Fill the matrices in order

ig=1;
ir=1;

for i=1:length(NNewGreen(:,1))
    for j=1:3
        FNewGreen(i,j)=ig;
        ig=ig+1;
    end
end


for i=1:length(NNewRed(:,1))
    for j=1:3
        FNewRed(i,j)=ir;
        ir=ir+1;
    end
end


VGR=VNewGreen;
NGR=NNewGreen;
FGR=FNewGreen;
VRD=VNewRed;
NRD=NNewRed;
FRD=FNewRed;

%CLEANING VARIABLES
%Separating the triangles
TrGreen=0;  % Number of triangles under the cut
TrBlue=0;   % Cutted triangles
TrYellow=0; % Parallel to the cut
TrRed=0;    % Number of triangle above the cut 

TrNewGreen=0;
TrNewRed=0;

%STL new green triangles coming from blue triangles 
VNewGreen=zeros(1,3);
NNewGreen=zeros(1,3);

%STL new red triangles coming from blue triangles 
VNewRed=zeros(1,3);
NNewRed=zeros(1,3);

end