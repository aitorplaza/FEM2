function M=assemble_mass_matrix_wedge(node_matrix,element_matrix)

n_nodes=size(node_matrix,1);

M=spalloc(3*n_nodes,3*n_nodes,3*n_nodes*81);

for i=1:size(element_matrix,1)
	M_element=element_mass_matrix_wedge(node_matrix(element_matrix(i,:),:));

	row_indices=3*(element_matrix(i,:)-ones(1,6))+ones(1,6);
	
	v=zeros(1,18);
	for j=1:6
		v(3*j-2:3*j)=row_indices(j):row_indices(j)+2;
	end

	M(v,v)=M(v,v)+M_element;
end
