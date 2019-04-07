function tetra_matrix=hexa2tetra(element_matrix)

v1=[1,2,4,5];
v2=[2,7,5,6];
v3=[2,3,4,7];
v4=[4,5,7,8];
v5=[2,5,7,4];

n=size(element_matrix,1);

tetra_matrix=zeros(5*n,4);

for i=1:size(element_matrix,1)
	tetra_matrix(5*(i-1)+1,:)=element_matrix(i,v1);
	tetra_matrix(5*(i-1)+2,:)=element_matrix(i,v2);
	tetra_matrix(5*(i-1)+3,:)=element_matrix(i,v3);
	tetra_matrix(5*(i-1)+4,:)=element_matrix(i,v4);
	tetra_matrix(5*(i-1)+5,:)=element_matrix(i,v5);
end