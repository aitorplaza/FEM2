syms ji eta mu real;

syms x1 x2 x3 x4 x5 x6 real;
syms y1 y2 y3 y4 y5 y6 real;
syms z1 z2 z3 z4 z5 z6 real;


N1e=(1/2)*(1-mu)*(1-ji-eta);
N2e=(1/2)*(1-mu)*ji;
N3e=(1/2)*(1-mu)*eta;

N4e=(1/2)*(1+mu)*(1-ji-eta);
N5e=(1/2)*(1+mu)*ji;
N6e=(1/2)*(1+mu)*eta;

A=[	x1 x2 x3 x4 x5 x6;
	y1 y2 y3 y4 y5 y6;
	z1 z2 z3 z4 z5 z6];

N=[N1e;N2e;N3e;N4e;N5e;N6e];


r=A*N;

%  xyz=[x;y;z];
jem=[ji;eta;mu];

J=jacobian(r,jem)';

%  J

node_submatrix=A';

matlabFunction(J,'file','element_jacobian_wedge','vars',{jem,node_submatrix})

N_jem=jacobian(N,jem)';

matlabFunction(N_jem,'file','shape_jacobian_wedge','vars',{jem})

size(N_jem)
