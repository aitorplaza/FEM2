%  main_create_nodes_matrix;
clear all
close all

addpath('./lib/');

%  --------------------------------------------------------------------------------------------------
%  --------------------------------------------------------------------------------------------------
%  --------------------------------------------------------------------------------------------------
%  --------------------------------------------------------------------------------------------------

%  for iii=1:6
%  for iii=2:2

%  length in the X direction (plate part)
Lx=2.4;

%  Radius of cylinder

%  Cone
r=0.060;
RR=0.550;
R=0.350;

%  %  Cylinder
%  r=0.060;
%  RR=0.45;
%  R= 0.45;


%  Element size
element_size=0.07;


%  number of elements in each dimension
nx=floor(Lx/element_size);
nt=floor(2*pi*R/element_size);
nr=floor((R-r)/element_size);

nx=nx+mod(nx,2);

nx=36;
nt=90;
nr=16;
[nx,nt,nr]

%  nx=9;
%  nt=16;
%  nr=5;
%  [nx,nt,nr]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Create Geometry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Creating Geometry ...\t\t'),pause(0.1),tic

[node_matrix,element_matrix]=create_geometry_CONE(nx,nr,nt,Lx,R,r,RR);

n_nodes=size(node_matrix,1);
n_elems=size(element_matrix,1);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  Create Tetrahedron matrix for representation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Creating Tetra Mesh ...\t\t'),pause(0.1),tic

tetra_matrix=hexa2tetra(element_matrix);

%  plot_elements(node_matrix,element_matrix,0)

%  figure,plot_scalar(node_matrix,tetra_matrix,0),		title('First Principal Component');

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Assemble K %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Assembling Stiffness matrix ...\t'),pause(0.1),tic

K=assemble_stiffness_matrix(node_matrix,element_matrix);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Apply Forces %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Applying forces ...\t\t'),pause(0.1),tic

force_nodes=1:(nt)*(nr+1);

%  for iii=1:6
for iii=2:2

switch iii
	case 1
		force=[1;0;0];	moment=[0;0;0];
	case 2
		force=[0;1;0];	moment=[0;0;Lx/2];
	case 3
		force=[0;0;1];	moment=[0;-Lx/2;0];
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
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Apply Constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
displacement_nodes1=nt*(nr+1)*nx+1:(nt)*(nr+1)*(nx+1);

dofs=nodes_to_dofs(displacement_nodes1);

K(dofs,:)=zeros(length(dofs),size(K,2));
K(:,dofs)=zeros(size(K,2),length(dofs));
K(dofs,dofs)=eye(length(dofs));

F(dofs)=zeros(length(dofs),1);

fprintf('%d',floor(toc)),fprintf(' seconds.\n')
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

displacement_matrix=write_displacement_matrix(U);
displacement_hypermatrix(:,:,iii)=displacement_matrix;

%  figure,plot_scalar(node_matrix+displacement_matrix,tetra_matrix,total_displacement);
%  figure,plot_vectorial(node_matrix+displacement_matrix,tetra_matrix,displacement_matrix,1);

%  figure,plot_vectorial(node_matrix+displacement_matrix,tetra_matrix,displacement_matrix,0),		title('Norm of Displacements');

fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Calculate Strains %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Calculating Strains ...\t\t'),pause(0.1),tic

node_strain_matrix=calculate_node_strain_matrix(node_matrix,element_matrix,displacement_matrix);

fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Calculate Stress  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Calculating Stress ...\t\t'),pause(0.1),tic
%  
node_stress_matrix=calculate_node_stress_matrix(node_strain_matrix);
%  
%  %  stress tensor components calculation
%  sigma_xx=calculate_node_tensor_component_stress_vector(node_stress_matrix,'xx');
%  sigma_yy=calculate_node_tensor_component_stress_vector(node_stress_matrix,'yy');
%  sigma_zz=calculate_node_tensor_component_stress_vector(node_stress_matrix,'zz');
%  tau_xy=calculate_node_tensor_component_stress_vector(node_stress_matrix,'xy');
%  tau_yz=calculate_node_tensor_component_stress_vector(node_stress_matrix,'yz');
%  tau_xz=calculate_node_tensor_component_stress_vector(node_stress_matrix,'xz');
%  
%  %  strain tensor components calculation
%  epsilon_xx=calculate_node_tensor_component_stress_vector(node_strain_matrix,'xx');
%  epsilon_yy=calculate_node_tensor_component_stress_vector(node_strain_matrix,'yy');
%  epsilon_zz=calculate_node_tensor_component_stress_vector(node_strain_matrix,'zz');
%  epsilon_xy=calculate_node_tensor_component_stress_vector(node_strain_matrix,'xy');
%  epsilon_yz=calculate_node_tensor_component_stress_vector(node_strain_matrix,'yz');
%  epsilon_xz=calculate_node_tensor_component_stress_vector(node_strain_matrix,'xz');


%  figure,plot_scalar(node_matrix,tetra_matrix(end/2+1:end,:),epsilon_xx);
%  view(-90,0);
%  figure,plot_scalar(node_matrix,tetra_matrix(end/2+1:end,:),epsilon_yy);
%  view(-90,0);
%  figure,plot_scalar(node_matrix,tetra_matrix(end/2+1:end,:),epsilon_zz);
%  view(-90,0);
%  figure,plot_scalar(node_matrix,tetra_matrix(end/2+1:end,:),epsilon_xy);
%  view(-90,0);
%  figure,plot_scalar(node_matrix,tetra_matrix(end/2+1:end,:),epsilon_yz);
%  view(-90,0);
%  figure,plot_scalar(node_matrix,tetra_matrix(end/2+1:end,:),epsilon_xz);
%  view(-90,0);
%  
%  
%  nmin=(nx/2)*(nt*(nr+1))+1;                                                            
%  nmax=(nx/2)*(nt*(nr+1))+nt;
%  
%  nmin2=(nx/2+1)*(nt*(nr+1))+1;                                                            
%  nmax2=(nx/2+1)*(nt*(nr+1))+nt;
%  
%  dT=2*pi/nt;
%  for k=0:nt-1
%  	theta(k+1)=k*dT;
%  end
%  theta=theta(:);

%  %  strain tensor components calculation in peripheria
%  node_epsilon_xx=epsilon_xx(nmin:nmax);
%  node_epsilon_yy=epsilon_yy(nmin:nmax);
%  node_epsilon_zz=epsilon_zz(nmin:nmax);
%  node_epsilon_xy=epsilon_xy(nmin:nmax);
%  node_epsilon_yz=epsilon_yz(nmin:nmax);
%  node_epsilon_xz=epsilon_xz(nmin:nmax);
%  
%  %  stress tensor components calculation in peripheria
%  node_sigma_xx=sigma_xx(nmin:nmax);
%  node_sigma_yy=sigma_yy(nmin:nmax);
%  node_sigma_zz=sigma_zz(nmin:nmax);
%  node_tau_xy=tau_xy(nmin:nmax);
%  node_tau_yz=tau_yz(nmin:nmax);
%  node_tau_xz=tau_xz(nmin:nmax);
%  
%  node_epsilon_xy2=epsilon_xy(nmin2:nmax2);

%  figure,hold on
%  plot(theta,node_epsilon_xx,'r')
%  plot(theta,node_epsilon_yy,'g')
%  plot(theta,node_epsilon_zz,'b')
%  plot(theta,node_epsilon_xy,'r--')
%  plot(theta,node_epsilon_yz,'g--')
%  plot(theta,node_epsilon_xz,'b--')
%  legend('\epsilon_{xx}','\epsilon_{yy}','\epsilon_{zz}','\gamma_{xy}','\gamma_{yz}','\gamma_{xz}')
%  
%  figure,hold on
%  plot(theta,node_sigma_xx,'r')
%  plot(theta,node_sigma_yy,'g')
%  plot(theta,node_sigma_zz,'b')
%  plot(theta,node_tau_xy,'r--')
%  plot(theta,node_tau_yz,'g--')
%  plot(theta,node_tau_xz,'b--')
%  legend('\sigma_{xx}','\sigma_{yy}','\sigma_{zz}','\tau_{xy}','\tau_{yz}','\tau_{xz}')
%  
%  pause

%  min_sigma=min(min([node_sigma_xx,node_sigma_yy,node_sigma_zz,node_tau_xy,node_tau_yz,node_tau_xz]));
%  max_sigma=max(max([node_sigma_xx,node_sigma_yy,node_sigma_zz,node_tau_xy,node_tau_yz,node_tau_xz]));
%  axis([0,2*pi,min_sigma,max_sigma])

%  for i=1:4
%  	sv(i,:) =node_strain_matrix(nmin-1+10*i,:); % phi=90*i
%  end
%  
%  v=[2,3,4,1];
%  
%  for i=1:4
%  	st(:,:,v(i))=[	sv(i,1),	sv(i,4)/2,	sv(i,6)/2;
%  			sv(i,4)/2,	sv(i,2),	sv(i,5)/2;
%  			sv(i,6)/2,	sv(i,5)/2,	sv(i,3)];
%  end
%  
%  
%  syms phi delta real
%  
%  A_123p_to_123pp=[	cos(delta),0,-sin(delta);
%  			0	  ,1,	0;
%  			sin(delta),0,cos(delta)];
%  
%  A_xyz_to_123p=[	1,	0,	0;
%  		0,	cos(phi),sin(phi);
%  		0,	-sin(phi),cos(phi)];
%  
%  
%  A_xyz_to_123pp=A_123p_to_123pp*A_xyz_to_123p;
%  
%  
%  matlabFunction(A_xyz_to_123pp,'File','eval_A_xyz_to_123pp','vars',{phi,delta});
%  %  matlabFunction(Eq,'File','evalEq','vars',{q,rho,param})
%  clear phi delta;
%  
%  position=[  1;   1;   2;   2;   3;   3;   4;   4];
%  phi=     [  0;   0;  90;  90; 180; 180; 270; 270]*pi/180;
%  delta=   [ 30; 120;  60; 150;  30; 120;  60; 150]*pi/180;
%  
%  %  phidelta=[0;30;0;120;90;60;90;150;180;30;180;120;270;60;270;150]*pi/180;
%  
%  for i=1:8
%  	st_123pp_gauge=eval_A_xyz_to_123pp(phi(i),delta(i))*st(:,:,position(i))*eval_A_xyz_to_123pp(phi(i),delta(i))';
%  	e(i,1)=st_123pp_gauge(1,1);
%  end
%  
%  %  gauge 1: phi = 0;	delta = 30;
%  %  gauge 2: phi = 0;	delta = 120;
%  %  gauge 3: phi = 90;	delta = 60;
%  %  gauge 4: phi = 90;	delta = 150;
%  %  gauge 5: phi = 180;	delta = 30;
%  %  gauge 6: phi = 180;	delta = 120;
%  %  gauge 7: phi = 270;	delta = 60;
%  %  gauge 8: phi = 270;	delta = 150;
%  
%  
%  W_FEM(:,iii)=e;

end

save displacement_hypermatrix displacement_hypermatrix
save element_matrix element_matrix
save node_matrix node_matrix
save nx nx
save nt nt
save nr nr


%  save W_FEM W_FEM

%  
node_vonmisses_stress_vector=calculate_node_vonmisses_stress_vector(node_stress_matrix);
%  
%  principal_components=calculate_principal_components(node_stress_matrix);
%  first_principal_component=principal_components(:,1);
%  second_principal_component=principal_components(:,2);
%  third_principal_component=principal_components(:,3);
%  
fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%  %  return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Plotting Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Plotting results ...\t'),pause(0.1),tic
%  
figure,plot_scalar(node_matrix+displacement_matrix,tetra_matrix,node_vonmisses_stress_vector),	title('von Mises Stress');
%  %  figure,plot_tensorial(node_matrix+displacement_matrix,tetra_matrix,node_stress_matrix,1,10^-2)
%  
%  figure,plot_scalar(node_matrix+displacement_matrix,tetra_matrix,first_principal_component),		title('First Principal Component');
%  figure,plot_scalar(node_matrix+displacement_matrix,tetra_matrix,second_principal_component),	title('Second Principal Component');
%  figure,plot_scalar(node_matrix+displacement_matrix,tetra_matrix,third_principal_component),		title('Third Principal Component');
%  
%  fprintf('%d',floor(toc)),fprintf(' seconds.\n');
%  
%  
%  fprintf('\n');
%  fprintf('Maximum displacement in Z:\t%4.4f mm.\n',min(displacement_matrix(:,3)));
%  fprintf('Maximum von Mises stress:\t%d MPa.\n\n',floor(max(node_vonmisses_stress_vector)));


%  save node_matrix node_matrix
%  save displacement_matrix displacement_matrix
%  save node_strain_matrix node_strain_matrix
%  save node_stress_matrix node_stress_matrix
%  
%  save total_fprintflacement total_fprintflacement
%  save node_vonmisses_stress_vector node_vonmisses_stress_vector




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Strain interpolation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  fprintf('Strain interpolation ...\t'),pause(0.1),tic
%  
%  
%  n_e_min=floor(nx/2)*nt*nr+1;
%  n_e_max=floor(nx/2)*nt*nr+nt;
%  
%  v_elements=n_e_min:n_e_max;
%  
%  %  plot_elements(node_matrix,element_submatrix,0)
%  
%  dT=2*pi/nt;
%  
%  
%  for i=0:1:359
%  %  for i=1:1
%  	phi=i*pi/180;
%  
%  	phi=mod(phi,2*pi);
%  
%  	%  ne is the index of element of the element_submatrix in which phi falls
%  	ne=floor(phi/dT)+1;
%  
%  	v=element_matrix(ne+n_e_min-1,:);
%  	node_submatrix=node_matrix(v,:);
%  	displacement_submatrix=displacement_matrix(v,:);
%  
%  	%  Dphi is the angle inside the element
%  	Dphi= phi-(ne-1)*dT;
%  
%  	ji=Dphi/pi*nt - 1;
%  	
%  	node=[0,ji,-1];
%  
%  	node_strain=calculate_surface_point_strain(node_submatrix,displacement_submatrix,node);
%  	tau_xy_inerp(i+1)=node_strain(1,4);
%  end
%  
%  figure
%  hold on
%  t=(0:1:359)*pi/180;
%  plot(theta,node_epsilon_xy,'r--')
%  plot(theta,node_epsilon_xy2,'g--')
%  plot(t,tau_xy_inerp,'b')
%  
%  fprintf('%d',floor(toc)),fprintf(' seconds.\n');
