function tetra_matrix=wedge2tetra(element_matrix)

v1=[1,2,3,4];
v2=[2,3,4,5];
v3=[3,4,5,6];


n=size(element_matrix,1);

tetra_matrix=zeros(3*n,4);

for i=1:size(element_matrix,1)
	tetra_matrix(3*(i-1)+1,:)=element_matrix(i,v1);
	tetra_matrix(3*(i-1)+2,:)=element_matrix(i,v2);
	tetra_matrix(3*(i-1)+3,:)=element_matrix(i,v3);
end
