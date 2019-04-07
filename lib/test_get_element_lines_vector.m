
node_matrix_1=[	0,0,0;
		1,0,0;
		1,1,0;
		0,1,0;
		0,0,1;
		1,0,1;
		1,1,1;
		0,1,1];

node_matrix_2=[	0,0,1;
		1,0,1;
		1,1,1;
		0,1,1;
		0,0,2;
		1,0,2;
		1,1,2;
		0,1,2];

[lines_x,lines_y lines_z]=get_element_lines_vector(node_matrix_1);
plot3(lines_x,lines_y,lines_z)
hold on
[lines_x,lines_y lines_z]=get_element_lines_vector(node_matrix_2);
plot3(lines_x,lines_y,lines_z)

axis equal
