function node_tensor_component_stress_vector=calculate_node_tensor_component_stress_vector(nsm,str)

node_tensor_component_stress_vector=zeros(size(nsm,1),1);

switch str
	case 'xx'
		c=1;
	case 'yy'
		c=2;
	case 'zz'
		c=3;
	case 'xy'
		c=4;
	case 'yz'
		c=5;
	case 'xz'
		c=6;
	otherwise
		disp('Error selecting the tensor component');
		c=0;
end

for i=1:size(nsm,1)
	node_tensor_component_stress_vector(i)=nsm(i,c);
end
