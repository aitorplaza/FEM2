
function M_element=element_mass_matrix_wedge(node_submatrix)

M_element=zeros(18,18);


% using 2 points per dimension per integration
w=1/6;

%a=1/sqrt(3);

%ji =[-a;a];
%eta=[-a;a];
%mu =[-a;a];

[E_young,nu,rho]=material_properties;


ji= [1/6;2/3;1/6;1/6;2/3;1/6];
eta=[1/6;1/6;2/3;1/6;1/6;2/3];
mu= [-ones(3,1)/sqrt(3),ones(3,1)/sqrt(3)];
%  [ji,eta,mu];

for i=1:6
			jem=[ji(i);eta(i);mu(i)];
			Njem = shape_functions_wedge(jem);
			Jjem=element_jacobian_wedge(jem,node_submatrix);
			M_element = M_element+rho*Njem'*Njem*det(Jjem);
end


