function N_jem = shape_jacobian(in1)
%SHAPE_JACOBIAN
%    N_JEM = SHAPE_JACOBIAN(IN1)

%    This function was generated by the Symbolic Math Toolbox version 5.8.
%    12-Nov-2016 18:08:05

eta = in1(2,:);
ji = in1(1,:);
mu = in1(3,:);
t2 = eta-1.0;
t3 = mu-1.0;
t4 = eta+1.0;
t5 = mu+1.0;
t6 = t2.*t5.*(1.0./8.0);
t7 = t4.*t5.*(1.0./8.0);
t8 = ji.*(1.0./8.0);
t9 = t8+1.0./8.0;
t10 = t3.*t9;
t11 = t8-1.0./8.0;
t12 = t5.*t11;
t13 = t2.*t9;
t14 = t4.*t11;
N_jem = reshape([t2.*t3.*(-1.0./8.0),-t3.*t11,-t2.*t11,t2.*t3.*(1.0./8.0),t10,t13,t3.*t4.*(-1.0./8.0),-t10,-t4.*t9,t3.*t4.*(1.0./8.0),t3.*t11,t14,t6,t12,t2.*t11,-t6,-t5.*t9,-t13,t7,t5.*t9,t4.*t9,-t7,-t12,-t14],[3, 8]);
