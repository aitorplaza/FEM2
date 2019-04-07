function displacement_matrix=write_displacement_matrix(U)

displacement_matrix=zeros(length(U)/3,3);
displacement_matrix=[U(1:3:end),U(2:3:end),U(3:3:end)];
