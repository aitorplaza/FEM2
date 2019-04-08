function [B,Q]=eval_B_wedge(jem,node_submatrix)

Q=(element_jacobian_wedge(jem,node_submatrix))\shape_jacobian_wedge(jem);

Z=zeros(1,6);

%B=[	Q(1,:),	Z,	Z;
%	Z,	Q(2,:),	Z;
%	Z,	Z,	Q(3,:);
%	Q(2,:),	Q(1,:),	Z;
%	Z,	Q(3,:),	Q(2,:);
%	Q(3,:),	Z,	Q(1,:)];

B=[	Q(1,:),	Z,	Z;
	Z,	Q(2,:),	Z;
	Z,	Z,	Q(3,:);
	Z,	Q(3,:),	Q(2,:);
	Q(3,:),	Z,	Q(1,:);
	Q(2,:),	Q(1,:),	Z;
    ];
