function node_stress_matrix=calculate_node_stress_matrix(node_strain_matrix)

[E_young,nu]=material_properties;

%  D matrix relates sigma=D*epsilon where:
%  	sigma=[sigma_xx,sigma_yy,sigma_zz,tau_xy,tau_yz,tau_xz]
%  	epsilon=[epsilon_xx,epsilon_yy,epsilon_zz,gamma_xy,gamma_yz,gamma_xz]

D=E_young/(1+nu)/(1-2*nu)*[	1-nu,	nu,	nu,	0,	0,	0;
				nu,	1-nu,	nu,	0,	0,	0;
				nu,	nu,	1-nu,	0,	0,	0;
				0,	0,	0,	1/2-nu,	0,	0;
				0,	0,	0,	0,	1/2-nu,	0;
				0,	0,	0,	0,	0,	1/2-nu];

%  node_stress_matrix=zeros(size(node_strain_matrix));

node_stress_matrix=node_strain_matrix*D;





