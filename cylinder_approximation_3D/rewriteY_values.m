function [new_y_values] = rewriteY_values(polygone_list, y_values)

counter1=1;
areas_polygone=zeros(length(polygone_list),1);

matrix_from_to(1,1)=0;
matrix_range(1,1)=0;

for i=1:length(polygone_list)
    areas_polygone(i) = area(polygone_list{i});
end


% This For Loop compares 3 contiguous polygones. If the 3 polygones dont
% change more than 5%, then the first polygone number is saved in
% matrix_from_to(i,1) and third polygone number is saved in  matrix_from_to(i,2)

for i=1:(length(polygone_list)-2)
    area1=areas_polygone(i);
    area2=areas_polygone(i+1);
    area3=areas_polygone(i+2);
   
    ratio1=abs((area1/area2)-1);
    ratio2=abs((area2/area3)-1);
    ratio3=abs((area1/area3)-1);
   
    if ( ratio1<0.05 && ratio2<0.05 && ratio3<0.05 )
       
        matrix_from_to(counter1,1)=i;
        matrix_from_to(counter1,2)=i+2;
       
        counter1=counter1+1;
    end
end
 %disp("matrix_from_to done");

% matrix_range means that the polygone number "matrix_range(i,1)" does not change
% more than 5% until  polygone number "matrix_range(i,2)"
if (matrix_from_to~=0)
    counter2=1;
    i=1;
    j=2;
    while(i<length(matrix_from_to(:,1))&&j<=length(matrix_from_to(:,1)))
        while(matrix_from_to(j,1)-matrix_from_to(i,1)==(j-i))
            if(j==length(matrix_from_to(:,1)))
                break
            else
                j=j+1;
            end
        end
        if (j==length(matrix_from_to(:,1)))
            matrix_range(counter2,1)=matrix_from_to(i,1);
            matrix_range(counter2,2)=matrix_from_to(j,2);
        else
            matrix_range(counter2,1)=matrix_from_to(i,1);
            matrix_range(counter2,2)=matrix_from_to(j-1,2);
        end
        i=j;
        j=i+1;
        counter2=counter2+1;
    end
end
 %disp("matrix_range done");
if (matrix_range~=0)
    % For loop to fill the new_y_values vector

    counter3=1; % Loops in the matrix_range
    counter4=2; % Loops in the new_y_values vector
    k=2;        % Loops in the y_values vector
    new_y_values(1,1)=y_values(1);

    while(k<=(length(y_values)) && counter4<=1000)
        %If the polygones are considered equal
        if(counter3<=length(matrix_range(:,1)))
            if(k>=(matrix_range(counter3,1)+1)&&k<=(matrix_range(counter3,2)+1))

                new_y_values(counter4,1)=y_values(matrix_range(counter3,1)+1);
                new_y_values(counter4+1,1)=y_values(matrix_range(counter3,2)+1);
                if((matrix_range(counter3,2)+1)<length(y_values))
                    k=matrix_range(counter3,2)+2;
                end
                if(counter3<length(matrix_range(:,1)))
                    counter3=counter3+1;
                end
                counter4=counter4+2;
             else
            % If the polygones are different
                new_y_values(counter4,1)=y_values(k);
                counter4=counter4+1;
                k=k+1;
            end
        end
        %disp("It will check now K: "+string(k));
    end
else
    new_y_values=y_values;
end
end
