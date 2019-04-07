function A_xyz_to_123pp = eval_A_xyz_to_123pp(phi,delta)
%EVAL_A_XYZ_TO_123PP
%    A_XYZ_TO_123PP = EVAL_A_XYZ_TO_123PP(PHI,DELTA)

%    This function was generated by the Symbolic Math Toolbox version 6.2.
%    09-Apr-2018 20:18:49

t2 = sin(delta);
t3 = cos(phi);
t4 = sin(phi);
t5 = cos(delta);
A_xyz_to_123pp = reshape([t5,0.0,t2,t2.*t4,t3,-t4.*t5,-t2.*t3,t4,t3.*t5],[3, 3]);
