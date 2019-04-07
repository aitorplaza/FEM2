
function K_element=element_stiff_matrix_wedge(node_submatrix)

K_element=zeros(18,18);


% using 2 points per dimension per integration
w=1/6;

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

ji= [1/6;2/3;1/6;1/6;2/3;1/6];
eta=[1/6;1/6;2/3;1/6;1/6;2/3];
mu= [-ones(3,1)/sqrt(3),ones(3,1)/sqrt(3)];
%  [ji,eta,mu];

for i=1:6
			jem=[ji(i);eta(i);mu(i)];
			Bjem=eval_B_wedge(jem,node_submatrix);
			Jjem=element_jacobian_wedge(jem,node_submatrix);
			K_element=K_element+w*Bjem'*E*Bjem*det(Jjem);
end

v=[1:6:18,2:6:18,3:6:18,4:6:18,5:6:18,6:6:18];

K_element=K_element(v,v);
