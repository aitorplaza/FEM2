function dofs=nodes_to_dofs(nodes)

n=length(nodes);

dofs=zeros(3*n,1);

for i=1:n
	dofs(3*i-2)=3*nodes(i)-2;
	dofs(3*i-1)=3*nodes(i)-1;
	dofs(3*i-0)=3*nodes(i)-0;
end
