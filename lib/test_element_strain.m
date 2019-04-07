function test_element_strain;

node_submatrix=[
     0     0     0;
     1     0     0;
     1     1     0;
     0     1     0;
     0     0     1;
     1     0     1;
     1     1     1;
     0     1     1];
     
displacement_submatrix=[
       0.0         0         0;
       0.0         0         0;
       0.1         0         0;
       0.1         0         0;
       0.0         0         0;
       0.0         0         0;
       0.1         0         0;
       0.1         0         0];


e_element=calculate_element_strain(node_submatrix,displacement_submatrix);

e_element

