function node_tau_xz_stress_vector=calculate_node_tau_xz_stress_vector(nsm)

node_tau_xz_stress_vector=zeros(size(nsm,1),1);

for i=1:size(nsm,1)
	node_tau_xz_stress_vector(i)=nsm(i,6);
end
