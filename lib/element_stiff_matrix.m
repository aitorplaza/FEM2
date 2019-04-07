
function K_element=element_stiff_matrix(node_submatrix)

K_element=zeros(24,24);

% using 2 points per dimension per integration
w=1;

a=1/sqrt(3);

ji =[-a;a];
eta=[-a;a];
mu =[-a;a];

[E_young,nu]=material_properties;


E=[	1-nu,	nu,	nu,	0,	0,	0;
	nu,	1-nu,	nu,	0,	0,	0;
	nu,	nu,	1-nu,	0,	0,	0;
	0,	0,	0,	1/2-nu,	0,	0;
	0,	0,	0,	0,	1/2-nu,	0;
	0,	0,	0,	0,	0,	1/2-nu];

E=E*E_young/((1+nu)*(1-2*nu));

	
for i=1:2
	for j=1:2
		for k=1:2
			jem=[ji(i);eta(j);mu(k)];
			Bjem=eval_B(jem,node_submatrix);
			Jjem=element_jacobian(jem,node_submatrix);
			K_element=K_element+w*Bjem'*E*Bjem*det(Jjem);
		end
	end
end

v=[1:8:24,2:8:24,3:8:24,4:8:24,5:8:24,6:8:24,7:8:24,8:8:24];

K_element=K_element(v,v);
