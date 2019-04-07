function [node_matrix,element_matrix]=create_geometry_CYLINDER(nx,nr,nt,Lx,Rini,r,RRini)

dLx=Lx/nx;
%  dLy=Ly/ny;


dT=2*pi/nt;

%  node_matrix=zeros((nx+1)*(nr*nt),3);

for i=1:nx+1
	RR=RRini;
	R=Rini;
	if i<=nx/3+1
		dR=(RR-r)/nr;
		R=RR;
	elseif i<=2*nx/3+1
		Rr=(2*nx/3+1-i)*(RR-R)/(nx/3)+R;
		dR=(Rr-r)/nr;
		R=Rr;
	else
		dR=(R-r)/nr;
		R=R;
	end

	i_init=(i-1)*nt*(nr+1);
	for j=1:nr+1
		j_init=(j-1)*nt;
		for k=1:nt
			k_init=i_init+j_init+k;
%  			node_matrix(k_init,:)=[	-Lx+(i-1)*dLx;	(R-(j-1)*dR)*cos(k*dT);		(R-(j-1)*dR)*sin(k*dT)];
			node_matrix(k_init,:)=[	-Lx+(i-1)*dLx;	(R-(j-1)*dR)*cos((k-1)*dT);		(R-(j-1)*dR)*sin((k-1)*dT)];
		end
	end
end

%  for i=1:length(node_matrix(:,1))
%  	v=node_matrix(i,:);
%  	plot3(v(1),v(2),v(3),'ro'),hold on
%  end


%  nmin=(nx/2)*(nt*(nr+1))+1;                                                            
%  nmax=(nx/2)*(nt*(nr+1))+nt;
%  
%  for i=nmin:nmax
%  	v=node_matrix(i,:);
%  	plot3(v(1),v(2),v(3),'ro'),hold on
%  	pause
%  end


for i=1:nx
	i_init_element=(i-1)*nt*nr;
	i_init_node=(i-1)*nt*(nr+1);
	for j=1:nr
		j_init_element=(j-1)*nt;
		j_init_node=(j-1)*nt;
		for k=1:nt-1
			k_init_element=i_init_element+j_init_element+k;
			k_init_node=i_init_node+j_init_node+k;
			%  					1		2				3				4
			element_matrix(k_init_element,1:4)=[	k_init_node,	k_init_node+nt*(nr+1),		k_init_node+nt*(nr+1)+1,	k_init_node+1];
%  							   [	k_init_node,	k_init_node+nt*(nr),		k_init_node+nt*(nr)+1,		k_init_node+1]
			%  					5		6				7				8	
			element_matrix(k_init_element,5:8)=[	k_init_node+nt,	k_init_node+nt*(nr+1)+nt,	k_init_node+nt*(nr+1)+1+nt,	k_init_node+1+nt];
%  							   [	k_init_node+nt,	k_init_node+nt*(nr)+nt,		k_init_node+nt*(nr)+1+nt,	k_init_node+1+nt]
%  							   pause
		end
		k_init_element=i_init_element+j_init_element+nt;
		k_init_node=i_init_node+j_init_node+nt;
		%  					1		2				3					4
		element_matrix(k_init_element,1:4)=[	k_init_node,	k_init_node+nt*(nr+1),		k_init_node+nt*(nr+1)+1-nt,		k_init_node+1-nt];

		%  					5		6				7					8	
		element_matrix(k_init_element,5:8)=[	k_init_node+nt,	k_init_node+nt*(nr+1)+nt,	k_init_node+nt*(nr+1)+1+nt-nt,		k_init_node+1+nt-nt];
	end
end

