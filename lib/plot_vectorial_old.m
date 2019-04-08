function plot_vectorial(node_matrix,tetra_matrix,V,bool_show_vectors)

C=sqrt(V(:,1).^2+V(:,2).^2+V(:,3).^2);

trep = TriRep(tetra_matrix, node_matrix);
%  trep = triangulation(tetra_matrix, node_matrix);

tri = freeBoundary(trep);
trisurf(tri, node_matrix(:,1),node_matrix(:,2),node_matrix(:,3),C,'FaceColor','interp');

if bool_show_vectors
	U=node_matrix;

	hold on
	for i=1:size(node_matrix,1)
		plot3([U(i,1),U(i,1)+V(i,1)],[U(i,2),U(i,2)+V(i,2)],[U(i,3),U(i,3)+V(i,3)],'r');
	end
end

colormap(jet)
colorbar

axis equal
