function A=calculate_A(W)

%  A is a matrix that satisfies the following two conditions:
%  
%  W'*A'=eye
%  1'*A'=0'

[r,c]=size(W);



B=[W';ones(1,r)];
C=[eye(c);zeros(1,c)];

At=pinv(B)*C;
A=At';
