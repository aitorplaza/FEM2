function plot_elements(node_matrix,element_matrix,color)

for i=1:size(element_matrix,1)
	v=element_matrix(i,:);
%  	v
	node_submatrix=node_matrix(element_matrix(i,:),:);
	[lines_x,lines_y lines_z]=get_element_lines_vector(node_submatrix);
	if color == 0
		plot3(lines_x,lines_y,lines_z,'b'),hold on
	elseif color == 1
		plot3(lines_x,lines_y,lines_z,'r'),hold on
	else
		plot3(lines_x,lines_y,lines_z,'k'),hold on
	end

end

