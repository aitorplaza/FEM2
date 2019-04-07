function valor=f_objetivo(phidelta,node_matrix,displacement_hypermatrix,element_matrix,nx,nt,nr)

for i=1:6
	displacement_matrix=displacement_hypermatrix(:,:,i);
	W(:,i)=evalW_col_FEM(phidelta,node_matrix,displacement_matrix,element_matrix,nx,nt,nr);
end

%  Optimization with temperature compensation
A=calculate_A(W);
At=A';
valor=-log( (det(A*At))^-1 );

%  %  Optimization without temperature compensation
%  valor=-log(det(W'*W));

