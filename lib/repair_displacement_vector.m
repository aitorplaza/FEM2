function U_repaired=repair_displacement_vector(U,node_vector,u)

U_repaired=U;

for i=1:length(node_vector)
	U_repaired(3*node_vector(i)-2:3*node_vector(i))=u;
end

