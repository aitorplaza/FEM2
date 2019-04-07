function node_sigma_xx_stress_vector=calculate_node_sigma_xx_stress_vector(nsm)

node_sigma_xx_stress_vector=zeros(size(nsm,1),1);

for i=1:size(nsm,1)
	node_sigma_xx_stress_vector(i)=nsm(i,1);
end
