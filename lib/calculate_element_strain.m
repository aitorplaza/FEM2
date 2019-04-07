function element_strain=calculate_element_strain(node_submatrix,displacement_submatrix)

JEM=[	-1,	-1,	-1;
	 1,	-1,	-1;
	 1,	 1,	-1;
	-1,	 1,	-1;
	-1,	-1,	 1;
	 1,	-1,	 1;
	 1,	 1,	 1;
	-1,	 1,	 1];

u=[displacement_submatrix(:,1);displacement_submatrix(:,2);displacement_submatrix(:,3)];

element_strain=zeros(8,6);

for i=1:8
	jem=JEM(i,:);
	Bjem=eval_B(jem',node_submatrix);
	element_strain(i,:)=(Bjem*u)';
end

