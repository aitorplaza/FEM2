function node_vonmisses_stress_vector=calculate_node_vonmisses_stress_vector(nsm)

node_vonmisses_stress_vector=zeros(size(nsm,1),1);

for i=1:size(nsm,1)
	stress_tensor_i=[	nsm(i,1),	nsm(i,4),	nsm(i,6);
				nsm(i,4),	nsm(i,2),	nsm(i,5);
				nsm(i,6),	nsm(i,5),	nsm(i,3)];

	S=eigs(stress_tensor_i);

	node_vonmisses_stress_vector(i)=sqrt((S(1)-S(2))^2+(S(2)-S(3))^2+(S(3)-S(1))^2)/sqrt(2);
end
