function [B,Q]=eval_B(jem,node_submatrix)

%  Q=inv(element_jacobian(jem,node_submatrix))*shape_jacobian(jem);
Q=(element_jacobian(jem,node_submatrix))\shape_jacobian(jem);

Z=zeros(1,8);

B=[	Q(1,:),	Z,	Z;
	Z,	Q(2,:),	Z;
	Z,	Z,	Q(3,:);
	Q(2,:),	Q(1,:),	Z;
	Z,	Q(3,:),	Q(2,:);
	Q(3,:),	Z,	Q(1,:)];
	

