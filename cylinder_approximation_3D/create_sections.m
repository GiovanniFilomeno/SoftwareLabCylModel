function [mesh_list, y_values] = create_sections(F,V,N,number_of_sections)

% mesh_list = [[F,V,N],[F,V,N],...] for each section
% y_values has length number_of_sections + 1 (each section bottom and top)

% read stl file
% [F,V,N] = stlread('simple_cube.stl');


[F,V,N] = stlread("simple_cube.stl");
TrGreen=0;
TrBlue=0;
TrYellow=0;
TrRed=0;

%Amount of triangles
AofT=length(F(:,1));

%Amount of vertices
AofP=length(V(:,2));
Xmin=min(V(:,1));
Xmax=max(V(:,1));

%Vector containing 9 rings 
Xcut=linspace(Xmin, Xmax, 9);
for icut=2:9

%PlanoX = [Xcut(icut);Xcut(icut); Xcut(icut); Xcut(icut)];
%PlanoY = [120; 120; -120; -120];
%PlanoZ = [-120; 120; 120; -120];
%fill3(PlanoX,PlanoY,PlanoZ,'c');
%hold on

%Print the rings separately

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
              hold on
              TrBlue=TrBlue+1;
              
 
              % At this point the intersection line betweeen the cutting
              % plane and the ith triangle is found
              
              
              
              Trconf=0;
              
              if ( (xt(1)>=Xcut(icut) && xt(2)>=Xcut(icut) && xt(3)<Xcut(icut))||(xt(1)<=Xcut(icut) && xt(2)<=Xcut(icut)&& xt(3)>Xcut(icut)))
                  
                  %Line 1
                  M11=Pnt1;
                  u11=(Pnt3-Pnt1);
                  %Line 2
                  M12=Pnt2;
                  u12=(Pnt3-Pnt2);
                  Trconf=1;
              elseif ( (xt(1)>=Xcut(icut) && xt(3)>=Xcut(icut)&& xt(2)<Xcut(icut))||(xt(1)<=Xcut(icut) && xt(3)<=Xcut(icut)&& xt(2)>Xcut(icut)))
                  
                  %Line 1
                  M11=Pnt1;
                  u11=(Pnt2-Pnt1);
                  %Line 2
                  M12=Pnt3;
                  u12=(Pnt2-Pnt3);
                  Trconf=2;
                  
              elseif ( (xt(2)>=Xcut(icut) && xt(3)>=Xcut(icut) && xt(1)<Xcut(icut))||(xt(2)<=Xcut(icut) && xt(3)<=Xcut(icut)&& xt(1)>Xcut(icut)))
                 %Line 1
                  M11=Pnt2;
                  u11=(Pnt1-Pnt2);
                  %Line 2
                  M12=Pnt3;
                  u12=(Pnt1-Pnt3);
                  Trconf=3;
              end
         
            
            
              alf=(Xcut(icut)-M11(1))/u11(1);
              bet=(Xcut(icut)-M12(1))/u12(1);
              
              I1=M11+alf*u11;
              I2=M12+bet*u12;
              
               
              plot3(I1(1),I1(2),I1(3),'*')
              hold on 


              plot3(I2(1),I2(2),I2(3),'o')
              hold on 
            
              
              
              
   
              
              
              %numberpnt=10;
              %for j=1:numberpnt
              %alfa=linspace(-60,60,numberpnt);
              %punto=PalgT+alfa(j)*NalgT;
              %plot3(punto(1),punto(2),punto(3),'*')
              %hold on
              %end
      end
             
    %Triangles that are above the plane  
    elseif condition3
        
      % fill3(xt,yt,zt,'r');
      % hold on
       TrRed=TrRed+1;
       
    end
    
end   % Loop triangles


end   % Loop cuts


end

