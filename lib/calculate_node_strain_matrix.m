%  function node_strain_matrix=calculate_node_strain_matrix(node_matrix,element_matrix,displacement_matrix)
%  
%  node_strain_mean_index=zeros(size(node_matrix,1),1);
%  node_strain_matrix    =zeros(size(node_matrix,1),6);
%  
%  for i=1:size(element_matrix,1)
%  	v=element_matrix(i,:);
%  	node_submatrix=node_matrix(v,:);
%  	displacement_submatrix=displacement_matrix(v,:);
%  	element_strain_i=calculate_element_strain(node_submatrix,displacement_submatrix);
%  	
%  	for j=1:8
%  		node_strain_matrix(v(j),:)=(node_strain_matrix(v(j),:)*node_strain_mean_index(v(j))+element_strain_i(j,:))/(node_strain_mean_index(v(j))+1);
%  	end
%  	node_strain_mean_index(v)=node_strain_mean_index(v)+1;
%  end
%  

function node_strain_matrix=calculate_node_strain_matrix(node_matrix,element_matrix,element_matrix_wedge,displacement_matrix)

if nargin==3
	displacement_matrix=element_matrix_wedge;
	clear element_matrix_wedge;
end

node_strain_mean_index=zeros(size(node_matrix,1),1);
node_strain_matrix    =zeros(size(node_matrix,1),6);

for i=1:size(element_matrix,1)
	v=element_matrix(i,:);
	node_submatrix=node_matrix(v,:);
	displacement_submatrix=displacement_matrix(v,:);
	element_strain_i=calculate_element_strain(node_submatrix,displacement_submatrix);
	
	for j=1:8
		node_strain_matrix(v(j),:)=(node_strain_matrix(v(j),:)*node_strain_mean_index(v(j))+element_strain_i(j,:))/(node_strain_mean_index(v(j))+1);
	end
	node_strain_mean_index(v)=node_strain_mean_index(v)+1;
end

if nargin==4
	for i=1:size(element_matrix_wedge,1)
		v=element_matrix_wedge(i,:);
		node_submatrix=node_matrix(v,:);
		displacement_submatrix=displacement_matrix(v,:);
		element_strain_i=calculate_element_strain_wedge(node_submatrix,displacement_submatrix);
		
		for j=1:6
			node_strain_matrix(v(j),:)=(node_strain_matrix(v(j),:)*node_strain_mean_index(v(j))+element_strain_i(j,:))/(node_strain_mean_index(v(j))+1);
		end
		node_strain_mean_index(v)=node_strain_mean_index(v)+1;
	end
end

