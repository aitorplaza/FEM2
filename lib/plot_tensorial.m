function plot_tensorial(node_matrix,tetra_matrix,T,bool_show_tensor,scale)

C=zeros(size(T,1),1);

for i=1:size(T,1)
	stress_tensor_i=[	T(i,1),	T(i,4),	T(i,6);
				T(i,4),	T(i,2),	T(i,5);
				T(i,6),	T(i,5),	T(i,3)];
				
	[V,S]=eigs(stress_tensor_i);
	
	C(i)=sqrt((S(1)-S(2))^2+(S(2)-S(3))^2+(S(3)-S(1))^2)/sqrt(2);

end

disp('The maximum von Mises stress is:')
max(C)

trep = TriRep(tetra_matrix, node_matrix);
%  trep = triangulation(tetra_matrix, node_matrix);

tri = freeBoundary(trep);
trisurf(tri, node_matrix(:,1),node_matrix(:,2),node_matrix(:,3),C,'FaceColor','interp');

if bool_show_tensor
	U=node_matrix;

	hold on
	for i=1:size(T,1)
		stress_tensor_i=[	T(i,1),	T(i,4),	T(i,6);
					T(i,4),	T(i,2),	T(i,5);
					T(i,6),	T(i,5),	T(i,3)];
					
		[V,S]=eigs(stress_tensor_i);
		
		C(i)=sqrt((S(1)-S(2))^2+(S(2)-S(3))^2+(S(3)-S(1))^2)/sqrt(2);

		for j=1:3
			Vmin=(U(i,:))'-scale*S(j)*V(:,j);
			Vmax=(U(i,:))'+scale*S(j)*V(:,j);
			if S(j)>0
				plot3([Vmin(1),Vmax(1)],[Vmin(2),Vmax(2)],[Vmin(3),Vmax(3)],'r');
			else
				plot3([Vmin(1),Vmax(1)],[Vmin(2),Vmax(2)],[Vmin(3),Vmax(3)],'b');
			end
		end
	end
end

colormap(jet)
colorbar

axis equal
