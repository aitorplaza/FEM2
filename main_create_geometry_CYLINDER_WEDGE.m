%  main_create_nodes_matrix;
clear all
close all

addpath('./lib/');

%  --------------------------------------------------------------------------------------------------
%  --------------------------------------------------------------------------------------------------
%  --------------------------------------------------------------------------------------------------
%  --------------------------------------------------------------------------------------------------


%  length in the X direction (plate part)
Lx=2;

%  Radius of cylinder
R=0.450;
r=0.060;
r=0.1;


%  Element size
element_size=0.07;



%  number of elements in each dimension
nx=floor(Lx/element_size);
nt=floor(2*pi*R/element_size);
nr=floor(R/element_size)-1;

nx=nx+mod(nx,2);
nt=nt+mod(nt,2);

%  %  nx=20;
%  %  nt=20;
%  %  nr=10;
[nx,nt,nr]

r=R/(nr+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Create Geometry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Creating Geometry ...\t\t'),pause(0.1),tic

[node_matrix,element_matrix,element_matrix_wedge]=create_geometry_CYLINDER_WEDGE(nx,nr,nt,Lx,R,r);

n_nodes=size(node_matrix,1);
n_elems=size(element_matrix,1);
n_wedge_elems=size(element_matrix_wedge,1);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  Create Tetrahedron matrix for representation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Creating Tetra Mesh ...\t\t'),pause(0.1),tic

tetra_matrix_hexa=hexa2tetra(element_matrix);
tetra_matrix_wedge=wedge2tetra(element_matrix_wedge);
tetra_matrix_all=[tetra_matrix_hexa;tetra_matrix_wedge];

%  plot_elements(node_matrix,element_matrix,0)
%  plot_elements(node_matrix,element_matrix_wedge,0)
%  pause
%  figure,plot_scalar(node_matrix,tetra_matrix_all,0),		title('First Principal Component');
%  figure,plot_scalar(node_matrix,tetra_matrix_all,node_matrix(:,1).^2+node_matrix(:,2).^2+node_matrix(:,3).^2),
%  title('First Principal Component');


%  pause

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Assemble K %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Assembling Stiffness matrix ...\t'),pause(0.1),tic

K1=assemble_stiffness_matrix(node_matrix,element_matrix);
K2=assemble_stiffness_matrix_wedge(node_matrix,element_matrix_wedge);
K=K1+K2;
ldofs=size(K,2);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Apply Forces %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Applying forces ...\t\t'),pause(0.1),tic

force_nodes=1:(nt)*(nr+1)+1;


for iii=3

switch iii
	case 1
		force=[1;0;0];	moment=[0;0;0];
	case 2
		force=[0;1;0];	moment=[0;0;0];
	case 3
		force=[0;0;1];	moment=[0;0;0];
	case 4
		force=[0;0;0];	moment=[1;0;0];
	case 5
		force=[0;0;0];	moment=[0;1;0];
	case 6
		force=[0;0;0];	moment=[0;0;1];
	otherwise
		disp('error')
		return
end

F=zeros(3*n_nodes,1);
F=apply_force(F,force_nodes,force);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Apply Moments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Applying moments ...\t\t'),pause(0.1),tic

force_nodes=1:(nt)*(nr+1);

B=[-Lx;0;0];
F=apply_moment(F,B,force_nodes,node_matrix,moment);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Apply Constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  fprintf('Applying Constraints ...\t'),pause(0.1),tic
%  
%  K_constrained=K;
%  F_constrained=F;
%  
%  %  %  Constrain the bottom Z face
%  %  fprintflacement_nodes0=(nz+1)*(ny+1)*(nx1+nx2)+nz+1:nz+1:(nz+1)*(ny+1)*(nx1+nx2+nx1+1);
%  %  u0=zeros(3,1);
%  %  [K_constrained,F_constrained]=apply_constrain(K_constrained,F_constrained,fprintflacement_nodes0,u0);
%  
%  
%  %  Constrain the lower X face
%  fprintflacement_nodes1=(nz+1)*(ny+1)*(nx1+nx2+nx1)+1:(nz+1)*(ny+1)*(nx1+nx2+nx1+1);
%  %  applied fprintflacement
%  u1=zeros(3,1);
%  [K_constrained,F_constrained]=apply_constrain(K_constrained,F_constrained,fprintflacement_nodes1,u1);
%  
%  
%  %  %  Constrain the upper X face
%  %  fprintflacement_nodes2=1:(nz+1)*(ny+1);
%  %  %  applied fprintflacement
%  %  u2=[0;0;5];
%  %  [K_constrained,F_constrained]=apply_constrain(K_constrained,F_constrained,fprintflacement_nodes2,u2);
%  
%  fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Apply Constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Applying Constraints ...\t'),pause(0.1),tic

%  Constrain the lower X face
displacement_nodes1=(nt*(nr+1)+1)*nx+1:(nt*(nr+1)+1)*(nx+1);

dofs=nodes_to_dofs(displacement_nodes1);

K(dofs,:)=zeros(length(dofs),size(K,2));
K(:,dofs)=zeros(size(K,2),length(dofs));
K(dofs,dofs)=eye(length(dofs));

F(dofs)=zeros(length(dofs),1);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Apply LAGRANGIAN Constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  fprintf('Applying L Constraints ...\t'),pause(0.1),tic
%  
%  %  %  Constrain in radial direction in the middle face in the lower z part
%  %  displacement_nodes2=nt*(nr+1)*nx/2+nt/2+1 : (nt)*(nr+1)*nx/2+nt;
%  
%  %  Constrain in radial direction in the middle face in the upper z part
%  displacement_nodes2=nt*(nr+1)*nx/2+1 : (nt)*(nr+1)*nx/2+nt/2;
%  
%  %  %  Constrain in radial direction in the middle face  in the whole peripheria
%  %  displacement_nodes2=nt*(nr+1)*nx/2+1 : (nt)*(nr+1)*nx/2+nt;
%  
%  ldn=length(displacement_nodes2);
%  
%  JAC_LAG=zeros(ldn,size(K,2));
%  
%  dT=2*pi/nt;
%  
%  for i=1:ldn
%  	k=nt/2+i;
%  	JAC_LAG(i,3*(displacement_nodes2(i)-1)+1:3*displacement_nodes2(i))=[0,cos((k-1)*dT),sin((k-1)*dT)];
%  end
%  
%  
%  K(ldofs+1:ldofs+ldn,1:ldofs)=JAC_LAG;
%  K(1:ldofs,ldofs+1:ldofs+ldn)=JAC_LAG';
%  K(ldofs+1:ldofs+ldn,ldofs+1:ldofs+ldn)=zeros(ldn,ldn);
%  
%  F(ldofs+1:ldofs+ldn)=zeros(ldn,1);
%  
%  fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Solve the Equations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Solving equations ...\t\t'),pause(0.1),tic

U=K\F;

fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Write Displacement Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Write Displacement Matrix ...\t'),pause(0.1),tic

displacement_matrix=write_displacement_matrix(U(1:ldofs));

%  figure,plot_scalar(node_matrix+displacement_matrix,tetra_matrix,total_displacement);
%  figure,plot_vectorial(node_matrix+displacement_matrix,tetra_matrix,displacement_matrix,1);

figure,plot_vectorial(node_matrix+300*displacement_matrix,tetra_matrix_all,displacement_matrix,0),		title('Norm of Displacements');

%  pause

fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Calculate Strains %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Calculating Strains ...\t\t'),pause(0.1),tic

node_strain_matrix=calculate_node_strain_matrix(node_matrix,element_matrix,element_matrix_wedge,displacement_matrix);

fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Calculate Stress  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Calculating Stress ...\t\t'),pause(0.1),tic

node_stress_matrix=calculate_node_stress_matrix(node_strain_matrix);

%  stress tensor components calculation
sigma_xx=calculate_node_tensor_component_stress_vector(node_stress_matrix,'xx');
sigma_yy=calculate_node_tensor_component_stress_vector(node_stress_matrix,'yy');
sigma_zz=calculate_node_tensor_component_stress_vector(node_stress_matrix,'zz');
tau_xy=calculate_node_tensor_component_stress_vector(node_stress_matrix,'xy');
tau_yz=calculate_node_tensor_component_stress_vector(node_stress_matrix,'yz');
tau_xz=calculate_node_tensor_component_stress_vector(node_stress_matrix,'xz');

%  strain tensor components calculation
epsilon_xx=calculate_node_tensor_component_stress_vector(node_strain_matrix,'xx');
epsilon_yy=calculate_node_tensor_component_stress_vector(node_strain_matrix,'yy');
epsilon_zz=calculate_node_tensor_component_stress_vector(node_strain_matrix,'zz');
epsilon_xy=calculate_node_tensor_component_stress_vector(node_strain_matrix,'xy');
epsilon_yz=calculate_node_tensor_component_stress_vector(node_strain_matrix,'yz');
epsilon_xz=calculate_node_tensor_component_stress_vector(node_strain_matrix,'xz');

end




fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Plotting Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Plotting results ...\t\t'),pause(0.1),tic

node_vonmisses_stress_vector=calculate_node_vonmisses_stress_vector(node_stress_matrix);
figure,plot_scalar(node_matrix+300*displacement_matrix,tetra_matrix_all,node_vonmisses_stress_vector),	title('von Mises Stress');

%  principal_components=calculate_principal_components(node_stress_matrix);
%  first_principal_component=principal_components(:,1);
%  second_principal_component=principal_components(:,2);
%  third_principal_component=principal_components(:,3);
%  figure,plot_scalar(node_matrix+300*displacement_matrix,tetra_matrix,first_principal_component),		title('First Principal Component');
%  figure,plot_scalar(node_matrix+300*displacement_matrix,tetra_matrix,second_principal_component),	title('Second Principal Component');
%  figure,plot_scalar(node_matrix+300*displacement_matrix,tetra_matrix,third_principal_component),		title('Third Principal Component');


fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
