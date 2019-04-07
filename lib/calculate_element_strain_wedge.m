function element_strain=calculate_element_strain_wedge(node_submatrix,displacement_submatrix)

JEM=[   0,  0,  -1;
        1,  0,  -1;
        0,  1,  -1;
        0,  0,   1;
        1,  0,   1;
        0,  1,   1];

u=[displacement_submatrix(:,1);displacement_submatrix(:,2);displacement_submatrix(:,3)];

% element_strain=zeros(number_of_nodes,number_of_tensor_components);
% element_strain=zeros(8,6);
element_strain=zeros(6,6);

for i=1:6 % number_of_nodes
	jem=JEM(i,:);
	Bjem=eval_B_wedge(jem',node_submatrix);
	element_strain(i,:)=(Bjem*u)';
end

