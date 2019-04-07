function [lines_x,lines_y,lines_z]=get_element_lines_vector(nodes_submatrix)

if size(nodes_submatrix,1)==8
    % en filas de 1 a 8 nudos
    % en columnas x, y ,z

    v=[1;2;6;2;3;7;3;4;8;4;1;5;6;7;8;5];

    lines_x=nodes_submatrix(v,1);
    lines_y=nodes_submatrix(v,2);
    lines_z=nodes_submatrix(v,3);

elseif size(nodes_submatrix,1)==6
    % en filas de 1 a 6 nudos
    % en columnas x, y, z
    
    v=[1;2;3;1;4;5;2;5;6;3;6;4];

    lines_x=nodes_submatrix(v,1);
    lines_y=nodes_submatrix(v,2);
    lines_z=nodes_submatrix(v,3);
end
