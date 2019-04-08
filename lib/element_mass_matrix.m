
function M_element=element_mass_matrix(node_submatrix)

M_element=zeros(24,24);

% using 2 points per dimension per integration
w=1;

a=1/sqrt(3);

ji =[-a;a];
eta=[-a;a];
mu =[-a;a];

[E_young,nu,rho]=material_properties;

for i=1:2
	for j=1:2
		for k=1:2
			jem = [ji(i);eta(j);mu(k)];
			Njem = shape_functions(jem);
			Jjem = element_jacobian(jem,node_submatrix);
			M_element = M_element+rho*Njem'*Njem*det(Jjem);
		end
	end
end

