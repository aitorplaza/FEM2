function plot_trisurf(node_matrix,tetra_matrix,color)

%  trep = triangulation(tetra_matrix, node_matrix);
trep = TriRep(tetra_matrix, node_matrix);
tri = freeBoundary(trep);


if color == 0
	trisurf(tri, node_matrix(:,1),node_matrix(:,2),node_matrix(:,3),'FaceColor','cyan', 'FaceAlpha', 0.8);
elseif color == 1
	trisurf(tri, node_matrix(:,1),node_matrix(:,2),node_matrix(:,3),'FaceColor','m', 'FaceAlpha', 0.8);
else
	trisurf(tri, node_matrix(:,1),node_matrix(:,2),node_matrix(:,3),'FaceColor','k', 'FaceAlpha', 0.8);
end

axis equal
