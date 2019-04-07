function element_strain=calculate_tetra_element_strain(node_submatrix,displacement_submatrix)

U=displacement_submatrix';

u=[U(:,1);U(:,2);U(:,3);U(:,4)];

B_tetra_element=calculate_tetra_B(node_submatrix);
element_strain_i=(B_tetra_element*u)';


for i=1:4
	element_strain(i,:)=element_strain_i;
end
