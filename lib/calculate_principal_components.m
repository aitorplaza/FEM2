function principal_components=calculate_principal_components(T)

principal_components=zeros(size(T,1),3);

for i=1:size(T,1)
	stress_tensor_i=[	T(i,1),	T(i,4),	T(i,6);
				T(i,4),	T(i,2),	T(i,5);
				T(i,6),	T(i,5),	T(i,3)];
				
	[S]=eigs(stress_tensor_i);
	principal_components(i,:)=S(1:3);

end
