%  node_submatrix are the coordinates of the nodes of the element
%  displacement_submatrix are the displacements of the nodes of the element
%  node are the natural coordinates (in the element) of the point whose strain is calculated

function node_strain=calculate_surface_point_strain(node_submatrix,displacement_submatrix,node)

node=node(:);
node=node';

JEM=node;

u=[displacement_submatrix(:,1);displacement_submatrix(:,2);displacement_submatrix(:,3)];

%  node_strain=zeros(1,6);
%  node_submatrix
	jem=JEM;
	Bjem=eval_B(jem',node_submatrix);
	node_strain=(Bjem*u)';

