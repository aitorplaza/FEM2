function C=calculate_total_displacement(displacement_matrix)

C=sqrt(displacement_matrix(:,1).^2+displacement_matrix(:,2).^2+displacement_matrix(:,3).^2);
