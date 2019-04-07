function w=evalW_col_FEM(phidelta,node_matrix,displacement_matrix,element_matrix,nx,nt,nr)

%  WE TAKE THE MIDDLE SECTION OF THE SHAFT
n_e_min=floor(nx/2)*nt*nr+1;
n_e_max=floor(nx/2)*nt*nr+nt;

v_elements=n_e_min:n_e_max;

dT=2*pi/nt;

for i=1:size(phidelta,1)/2

	phi=phidelta(2*i-1);
	delta=phidelta(2*i);
	
	phi=mod(phi,2*pi);

	%  ne is the index of element of the element_submatrix in which phi falls
	ne=floor(phi/dT)+1;

	v=element_matrix(ne+n_e_min-1,:);
	node_submatrix=node_matrix(v,:);
	displacement_submatrix=displacement_matrix(v,:);

	%  Dphi is the angle inside the element
	Dphi= phi-(ne-1)*dT;

	ji=Dphi/pi*nt - 1;
	
	node=[0,ji,-1];

	node_strain=calculate_surface_point_strain(node_submatrix,displacement_submatrix,node);
	sv=node_strain;

	st=[	sv(1),		sv(4)/2,		sv(6)/2;
		sv(4)/2,		sv(2),		sv(5)/2;
		sv(6)/2,		sv(5)/2,		sv(3)];
	
	A_123p_to_123pp=[	cos(delta),0,-sin(delta);
				0	  ,1,	0;
				sin(delta),0,cos(delta)];
	
	A_xyz_to_123p=[	1,	0,	0;
			0,	cos(phi),sin(phi);
			0,	-sin(phi),cos(phi)];
	
	
	A_xyz_to_123pp=A_123p_to_123pp*A_xyz_to_123p;

	st_123pp_gauge=A_xyz_to_123pp*st*A_xyz_to_123pp';
	w(i,1)=st_123pp_gauge(1,1);
end
