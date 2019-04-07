%  F is the applied force vector
%  B is the point w.r.t. which the moment is applied
%  node_vector: the moment is applied exerting forces in the nodes in node_vector
%  moment: is the vectorial moment
function F_loaded=apply_moment(F,B,node_vector,node_matrix,moment)

F_loaded=zeros(size(F));

n=length(node_vector);

if norm(moment)==0
	F_loaded=F;
	return
end

norm_MB2=moment'*moment;
sum_norm_BPi2=0;
sum_norm_MB_BPi4=0;
for i=1:n
	Pi=node_matrix(node_vector(i),:);
	Pi=Pi(:);
	BPi=Pi-B;
	sum_norm_BPi2=sum_norm_BPi2 + BPi'*BPi;
	sum_norm_MB_BPi4 = sum_norm_MB_BPi4 + (moment'*BPi)^2;
end

K= norm_MB2 / (norm_MB2*sum_norm_BPi2 - sum_norm_MB_BPi4);

%  check_sum
f_sum=[0;0;0];
m_sum=[0;0;0];

for i=1:n
	Pi=node_matrix(node_vector(i),:);
	Pi=Pi(:);
	BPi=Pi-B;
	FPi=K*cross(moment,BPi);
	F_loaded(3*node_vector(i)-2:3*node_vector(i))=FPi;
	
%  	f_sum= f_sum + FPi;
%  	m_sum= m_sum + cross(BPi,FPi);
end

%  f_sum
%  m_sum

F_loaded=F_loaded+F;