function [mesh_list, y_values] = create_sections(F,V,N,number_of_sections)

% mesh_list = [[F,V,N],[F,V,N],...] for each section
% y_values has length number_of_sections + 1 (each section bottom and top)

% read stl file
% [F,V,N] = stlread('simple_cube.stl');

% Read the original geometry
[F,V,N] = stlread("Example.stl");


%Separating the triangles
TrGreen=0;  % Number of triangles under the cut
TrBlue=0;   % Cutted triangles
TrYellow=0; % Parallel to the cut
TrRed=0;    % Number of triangle above the cut 

%Amount of triangles
AofT=length(F(:,1));

%Amount of vertices
AofP=length(V(:,2));
Xmin=min(V(:,1));
Xmax=max(V(:,1));



%Vector containing (n-1) rings 
ncuts=7;
Xcut=linspace(Xmin, Xmax, ncuts);
%Xcut=[50 300];
Fgreen(1,1:ncuts-1)=77777;
Fblue(1,1:ncuts-1)=88888;
Fred(1,1:ncuts-1)=99999;

%for icut=2:(ncuts)
icut=2;
    for i=1:AofT

        % Three vertices of the ith triangle 
        xt=V(i*3-2:i*3,1);
        yt=V(i*3-2:i*3,2);
        zt=V(i*3-2:i*3,3);

        % Find the min and max of the ith triangle 
        xmint=min(V(i*3-2:i*3,1));
        xmaxt=max(V(i*3-2:i*3,1));

        condition1= Xcut(1)<=xmint && xmint<=Xcut(icut)&& Xcut(1)<=xmaxt && xmaxt<=Xcut(icut);
        condition2=Xcut(1)<=xmint && xmint<=Xcut(icut) && xmaxt>Xcut(icut);
        condition3=xmint>Xcut(icut) && xmaxt>Xcut(icut);
        

        %Triangles under the cut 
        if condition1

           fill3(xt,yt,zt,'g');
           hold on    
           TrGreen=TrGreen+1;
        %Save which i 

           Fgreen(TrGreen,icut-1)=i;


        % Triangles that are cut by the plane 
        elseif condition2

          %Modifying the cut planes 
          % Normal vector of the ith triangle
          N1=[N(i,1) N(i,2) N(i,3)];
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
                  fill3(xt,yt,zt,'y');
                  hold on  
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


                  plot3(I1(1),I1(2),I1(3),'*')
                  hold on 


                  plot3(I2(1),I2(2),I2(3),'o')
                  hold on 
                  
                  
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
                      
                      fill3(xtnewgr,ytnewgr,ztnewgr,'c');
                      hold on
                      
                      %Tr2 and Tr3 are NEW RED
                      
                      xtnewred1=[Tr2Pnt1(1) Tr2Pnt2(1) Tr2Pnt3(1)];
                      ytnewred1=[Tr2Pnt1(2) Tr2Pnt2(2) Tr2Pnt3(2)];
                      ztnewred1=[Tr2Pnt1(3) Tr2Pnt2(3) Tr2Pnt3(3)];
                      
                      xtnewred2=[Tr3Pnt1(1) Tr3Pnt2(1) Tr3Pnt3(1)];
                      ytnewred2=[Tr3Pnt1(2) Tr3Pnt2(2) Tr3Pnt3(2)];
                      ztnewred2=[Tr3Pnt1(3) Tr3Pnt2(3) Tr3Pnt3(3)];
                      
                      fill3(xtnewred1,ytnewred1,ztnewred1,'m');
                      hold on
                      fill3(xtnewred2,ytnewred2,ztnewred2,'m');
                      hold on
                      
                  elseif(Tupwards)
                      
                      %If the triangle is pointing UPWARDS
                      %Tr1 is NEW RED
                      xtnewred=[Tr1Pnt1(1) Tr1Pnt2(1) Tr1Pnt3(1)];
                      ytnewred=[Tr1Pnt1(2) Tr1Pnt2(2) Tr1Pnt3(2)];
                      ztnewred=[Tr1Pnt1(3) Tr1Pnt2(3) Tr1Pnt3(3)];
                      
                      fill3(xtnewred,ytnewred,ztnewred,'m');
                      hold on
                      
                      %Tr2 and Tr3 are NEW GREEN
                      xtnewgr1=[Tr2Pnt1(1) Tr2Pnt2(1) Tr2Pnt3(1)];
                      ytnewgr1=[Tr2Pnt1(2) Tr2Pnt2(2) Tr2Pnt3(2)];
                      ztnewgr1=[Tr2Pnt1(3) Tr2Pnt2(3) Tr2Pnt3(3)];
                      
                      xtnewgr2=[Tr3Pnt1(1) Tr3Pnt2(1) Tr3Pnt3(1)];
                      ytnewgr2=[Tr3Pnt1(2) Tr3Pnt2(2) Tr3Pnt3(2)];
                      ztnewgr2=[Tr3Pnt1(3) Tr3Pnt2(3) Tr3Pnt3(3)];
                      
                      fill3(xtnewgr1,ytnewgr1,ztnewgr1,'c');
                      hold on
                      
                      fill3(xtnewgr2,ytnewgr2,ztnewgr2,'c');
                      hold on
                      
                  end % end triangle DOWNWARDS OR UPWARDS
                  

          end % if conditional blue triangles 

        %Triangles that are above the plane  
        elseif condition3

           fill3(xt,yt,zt,'r');
           hold on
           TrRed=TrRed+1;
           Fred(TrRed,icut-1)=i;
        
        end %if conditional

    end   % Loop triangles
    
    %TrGreen=0;
    %TrBlue=0;
    %TrRed=0;
    %TrYellow=0;

%end   % Loop cuts


% NOW PRINT THE INTERESTING PARTS READING THE Fmatrices

% GREEN TRIANGLES
f2= figure;

%Read which face in the matrix Fgreen
kgreen=length(Fgreen(:,1));

for k=1:kgreen 
%Read in the original F matrix which vertices V

    Vt1=F(Fgreen(k,1),1);
    Vt2=F(Fgreen(k,1),2);
    Vt3=F(Fgreen(k,1),3);

    %Read the 3 vertices from the original V vector 

    xtgreen=[V(Vt1,1) V(Vt2,1) V(Vt3,1)];
    ytgreen=[V(Vt1,2) V(Vt2,2) V(Vt3,2)];
    ztgreen=[V(Vt1,3) V(Vt2,3) V(Vt3,3)];

    %Plot the triangle 
    fill3(xtgreen,ytgreen,ztgreen,'g');
    hold on
end


% BLUE TRIANGLES
f3= figure;

%Read which face in the matrix Fgreen
kblue=length(Fblue(:,1));

for k=1:kblue 
%Read in the original F matrix which vertices V

    Vt1=F(Fblue(k,1),1);
    Vt2=F(Fblue(k,1),2);
    Vt3=F(Fblue(k,1),3);

    %Read the 3 vertices from the original V vector 

    xtblue=[V(Vt1,1) V(Vt2,1) V(Vt3,1)];
    ytblue=[V(Vt1,2) V(Vt2,2) V(Vt3,2)];
    ztblue=[V(Vt1,3) V(Vt2,3) V(Vt3,3)];

    %Plot the triangle 
    fill3(xtblue,ytblue,ztblue,'b');
    hold on
end


% RED TRIANGLES
f4= figure;

%Read which face in the matrix Fgreen
kred=length(Fred(:,1));

for k=1:kred 
%Read in the original F matrix which vertices V

    Vt1=F(Fred(k,1),1);
    Vt2=F(Fred(k,1),2);
    Vt3=F(Fred(k,1),3);

    %Read the 3 vertices from the original V vector 

    xtred=[V(Vt1,1) V(Vt2,1) V(Vt3,1)];
    ytred=[V(Vt1,2) V(Vt2,2) V(Vt3,2)];
    ztred=[V(Vt1,3) V(Vt2,3) V(Vt3,3)];

    %Plot the triangle 
    fill3(xtred,ytred,ztred,'r');
    hold on
    
end



end

