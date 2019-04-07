function plot_scalar(node_matrix,tetra_matrix,C)

trep = TriRep(tetra_matrix, node_matrix);
%  trep = triangulation(tetra_matrix, node_matrix);
[tri] = freeBoundary(trep);

%  M=max(C);
%  m=min(C);
%  
%  n=5;
%  
%  Cnorm=m+1/n*(M-m)*floor((C-m)./(M-m)*n);

Cnorm=C;

G=trisurf(tri, node_matrix(:,1),node_matrix(:,2),node_matrix(:,3),Cnorm,'FaceColor','interp','CDataMapping','scaled');
%  G=trisurf(tri, node_matrix(:,1),node_matrix(:,2),node_matrix(:,3),Cnorm,'CDataMapping','scaled');
%  [newFaces, newVertices] = reducepatch(G, 0.8);
%  newG = patch('Faces', newFaces, 'Vertices', newVertices);

colormap(jet)
colorbar

axis equal
