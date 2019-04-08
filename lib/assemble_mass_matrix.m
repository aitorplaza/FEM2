function M=assemble_mass_matrix(node_matrix,element_matrix)

n_nodes=size(node_matrix,1);

M=spalloc(3*n_nodes,3*n_nodes,3*n_nodes*81);

for i=1:size(element_matrix,1)
	M_element=element_mass_matrix(node_matrix(element_matrix(i,:),:));

	row_indices=3*(element_matrix(i,:)-ones(1,8))+ones(1,8);
	
	v=zeros(1,24);
	for j=1:8
		v(3*j-2:3*j)=row_indices(j):row_indices(j)+2;
	end

	M(v,v)=M(v,v)+M_element;
end
