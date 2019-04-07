function J = element_jacobian(in1,in2)
%ELEMENT_JACOBIAN
%    J = ELEMENT_JACOBIAN(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 5.8.
%    12-Nov-2016 18:08:04

eta = in1(2,:);
ji = in1(1,:);
mu = in1(3,:);
x1 = in2(1);
x2 = in2(2);
x3 = in2(3);
x4 = in2(4);
x5 = in2(5);
x6 = in2(6);
x7 = in2(7);
x8 = in2(8);
y1 = in2(9);
y2 = in2(10);
y3 = in2(11);
y4 = in2(12);
y5 = in2(13);
y6 = in2(14);
y7 = in2(15);
y8 = in2(16);
z1 = in2(17);
z2 = in2(18);
z3 = in2(19);
z4 = in2(20);
z5 = in2(21);
z6 = in2(22);
z7 = in2(23);
z8 = in2(24);
t2 = eta-1.0;
t3 = mu-1.0;
t4 = eta+1.0;
t5 = mu+1.0;
t6 = ji.*(1.0./8.0);
t7 = t6+1.0./8.0;
t8 = t6-1.0./8.0;
J = reshape([t2.*t3.*x1.*(-1.0./8.0)+t2.*t3.*x2.*(1.0./8.0)-t3.*t4.*x3.*(1.0./8.0)+t3.*t4.*x4.*(1.0./8.0)+t2.*t5.*x5.*(1.0./8.0)-t2.*t5.*x6.*(1.0./8.0)+t4.*t5.*x7.*(1.0./8.0)-t4.*t5.*x8.*(1.0./8.0),t3.*t7.*x2-t3.*t8.*x1-t3.*t7.*x3+t3.*t8.*x4-t5.*t7.*x6+t5.*t8.*x5+t5.*t7.*x7-t5.*t8.*x8,t2.*t7.*x2-t2.*t8.*x1-t4.*t7.*x3-t2.*t7.*x6+t2.*t8.*x5+t4.*t8.*x4+t4.*t7.*x7-t4.*t8.*x8,t2.*t3.*y1.*(-1.0./8.0)+t2.*t3.*y2.*(1.0./8.0)-t3.*t4.*y3.*(1.0./8.0)+t3.*t4.*y4.*(1.0./8.0)+t2.*t5.*y5.*(1.0./8.0)-t2.*t5.*y6.*(1.0./8.0)+t4.*t5.*y7.*(1.0./8.0)-t4.*t5.*y8.*(1.0./8.0),t3.*t7.*y2-t3.*t8.*y1-t3.*t7.*y3+t3.*t8.*y4-t5.*t7.*y6+t5.*t8.*y5+t5.*t7.*y7-t5.*t8.*y8,t2.*t7.*y2-t2.*t8.*y1-t4.*t7.*y3-t2.*t7.*y6+t2.*t8.*y5+t4.*t8.*y4+t4.*t7.*y7-t4.*t8.*y8,t2.*t3.*z1.*(-1.0./8.0)+t2.*t3.*z2.*(1.0./8.0)-t3.*t4.*z3.*(1.0./8.0)+t3.*t4.*z4.*(1.0./8.0)+t2.*t5.*z5.*(1.0./8.0)-t2.*t5.*z6.*(1.0./8.0)+t4.*t5.*z7.*(1.0./8.0)-t4.*t5.*z8.*(1.0./8.0),t3.*t7.*z2-t3.*t8.*z1-t3.*t7.*z3+t3.*t8.*z4-t5.*t7.*z6+t5.*t8.*z5+t5.*t7.*z7-t5.*t8.*z8,t2.*t7.*z2-t2.*t8.*z1-t4.*t7.*z3-t2.*t7.*z6+t2.*t8.*z5+t4.*t8.*z4+t4.*t7.*z7-t4.*t8.*z8],[3, 3]);