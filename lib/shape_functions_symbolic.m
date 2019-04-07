syms ji eta mu real;

syms x1 x2 x3 x4 x5 x6 x7 x8 real;
syms y1 y2 y3 y4 y5 y6 y7 y8 real;
syms z1 z2 z3 z4 z5 z6 z7 z8 real;


N1e=(1/8)*(1-ji)*(1-eta)*(1-mu);
N2e=(1/8)*(1+ji)*(1-eta)*(1-mu);
N3e=(1/8)*(1+ji)*(1+eta)*(1-mu);
N4e=(1/8)*(1-ji)*(1+eta)*(1-mu);

N5e=(1/8)*(1-ji)*(1-eta)*(1+mu);
N6e=(1/8)*(1+ji)*(1-eta)*(1+mu);
N7e=(1/8)*(1+ji)*(1+eta)*(1+mu);
N8e=(1/8)*(1-ji)*(1+eta)*(1+mu);


A=[	x1 x2 x3 x4 x5 x6 x7 x8;
	y1 y2 y3 y4 y5 y6 y7 y8;
	z1 z2 z3 z4 z5 z6 z7 z8];

N=[N1e;N2e;N3e;N4e;N5e;N6e;N7e;N8e];


r=A*N;

%  xyz=[x;y;z];
jem=[ji;eta;mu];

J=jacobian(r,jem)';

%  J

node_submatrix=A';

matlabFunction(J,'file','element_jacobian','vars',{jem,node_submatrix})

N_jem=jacobian(N,jem)';

matlabFunction(N_jem,'file','shape_jacobian','vars',{jem})

size(N_jem)
