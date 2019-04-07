% tetra_shape_functions_symbolic.m

syms x1 x2 x3 x4 real;
syms y1 y2 y3 y4 real;
syms z1 z2 z3 z4 real;


A=[	1,x1,y1,z1;
	1,x2,y2,z2;
	1,x3,y3,z3;
	1,x4,y4,z4];

V6=det(A);
	
a1= det(A(2:4,[2,3,4]));
b1=-det(A(2:4,[1,3,4]));
c1=-det(A(2:4,[2,1,4]));
d1=-det(A(2:4,[2,3,1]));



B=A([2,3,4,1],:);

a2=-det(B(2:4,[2,3,4]));
b2= det(B(2:4,[1,3,4]));
c2= det(B(2:4,[2,1,4]));
d2= det(B(2:4,[2,3,1]));


C=B([2,3,4,1],:);

a3= det(C(2:4,[2,3,4]));
b3=-det(C(2:4,[1,3,4]));
c3=-det(C(2:4,[2,1,4]));
d3=-det(C(2:4,[2,3,1]));

D=C([2,3,4,1],:);

a4=-det(D(2:4,[2,3,4]));
b4= det(D(2:4,[1,3,4]));
c4= det(D(2:4,[2,1,4]));
d4= det(D(2:4,[2,3,1]));


tetra_B1=1/V6*[b1,	0,	0;
		0	c1,	0;
		0,	0,	d1;
		c1,	b1,	0;
		0,	d1,	c1;
		d1,	0,	b1];

tetra_B2=1/V6*[b2,	0,	0;
		0	c2,	0;
		0,	0,	d2;
		c2,	b2,	0;
		0,	d2,	c2;
		d2,	0,	b2];

tetra_B3=1/V6*[b3,	0,	0;
		0	c3,	0;
		0,	0,	d3;
		c3,	b3,	0;
		0,	d3,	c3;
		d3,	0,	b3];

tetra_B4=1/V6*[b4,	0,	0;
		0	c4,	0;
		0,	0,	d4;
		c4,	b4,	0;
		0,	d4,	c4;
		d4,	0,	b4];


tetra_B=[tetra_B1,tetra_B2,tetra_B3,tetra_B4];

node_submatrix=[	x1 x2 x3 x4;
			y1 y2 y3 y4;
			z1 z2 z3 z4]';


matlabFunction(tetra_B,'file','calculate_tetra_B','vars',{node_submatrix})


