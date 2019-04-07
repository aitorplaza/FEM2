
function K_element=element_stiff_matrix_4point_integration(node_submatrix)

K_element=zeros(24,24);

% using 2 points per dimension per integration
w=[	0.347854845137454;
	0.652145154862546;
	0.652145154862546;
	0.347854845137454];

a=0.861136311594953;
b=0.339981043584856;


ji =[-a;-b;b;a];
eta=[-a;-b;b;a];
mu =[-a;-b;b;a];

[E_young,nu]=material_properties;


E=[	1-nu,	nu,	nu,	0,	0,	0;
	nu,	1-nu,	nu,	0,	0,	0;
	nu,	nu,	1-nu,	0,	0,	0;
	0,	0,	0,	1/2-nu,	0,	0;
	0,	0,	0,	0,	1/2-nu,	0;
	0,	0,	0,	0,	0,	1/2-nu];

E=E*E_young/((1+nu)*(1-2*nu));

	
for i=1:4
	for j=1:4
		for k=1:4
			jem=[ji(i);eta(j);mu(k)];
			Bjem=eval_B(jem,node_submatrix);
			Jjem=element_jacobian(jem,node_submatrix);
			K_element=K_element+w(i)*w(j)*w(k)*Bjem'*E*Bjem*det(Jjem);
		end
	end
end

v=[1:8:24,2:8:24,3:8:24,4:8:24,5:8:24,6:8:24,7:8:24,8:8:24];

K_element=K_element(v,v);
