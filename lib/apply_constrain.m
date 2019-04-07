function [K_constrained,F_constrained]=apply_constrain(K,F,node_vector,u)

n=size(K,1);

v=zeros(3*length(node_vector),1);
U=zeros(3*length(node_vector),1);

for i=1:length(node_vector)
	v(3*i-2)=3*node_vector(i)-2;
	v(3*i-1)=3*node_vector(i)-1;
	v(3*i-0)=3*node_vector(i)-0;
	
	U(3*i-2:3*i)=u;
end

K_constrained=K;

K_zeros=spalloc(n,length(v),length(v));
%  K_zeros=zeros(n,length(v));

for i=1:length(v)
	K_zeros(v(i),i)=1.0;
end

K_constrained(:,v)=-K_zeros;



F_constrained=F-K(:,v)*U;

