function K=assemble_stiffness_matrix(node_matrix,element_matrix)

n_nodes=size(node_matrix,1);

K=spalloc(3*n_nodes,3*n_nodes,3*n_nodes*81);

for i=1:size(element_matrix,1)
	K_element=element_stiff_matrix(node_matrix(element_matrix(i,:),:));
%  	K_element=element_stiff_matrix_4point_integration(node_matrix(element_matrix(i,:),:));
	row_indices=3*(element_matrix(i,:)-ones(1,8))+ones(1,8);
	
	v=zeros(1,24);
	for j=1:8
		v(3*j-2:3*j)=row_indices(j):row_indices(j)+2;
	end

	K(v,v)=K(v,v)+K_element;
end
