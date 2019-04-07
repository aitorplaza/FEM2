function F_loaded=apply_force(F,node_vector,force)

F_loaded=zeros(size(F));

n=length(node_vector);

for i=1:n
	F_loaded(3*node_vector(i)-2:3*node_vector(i))=force/n;
end

F_loaded=F_loaded+F;