function main_numeric_gauges_FEM

n_galgas=8;

load nx;
load nt;
load nr;

load node_matrix;
load displacement_hypermatrix;
load element_matrix;

minimo=Inf;

for i=1:10

	n=n_galgas;

	phidelta=pi*rand(2*n,1);
	phidelta(1:2:end)=phidelta(1:2:end)*2;


	% Options for the optimization algorithm
	options = optimset('MaxFunEvals',inf,'MaxIter',inf,'Display','iter');

	% Optimization	
	lb=zeros(2*n,1);
	ub=pi*ones(2*n,1);
	ub(1:2:end)=ub(1:2:end)*2;


	if n_galgas==8
	%  	Linear constraint equations for 8 gauges when size(phidelta)=2*n
		Aeq=[	zeros(1,1),-1,0,1,zeros(1,12);
			zeros(1,5),-1,0,1,zeros(1,8);
			zeros(1,9),-1,0,1,zeros(1,4);
			zeros(1,13),-1,0,1,zeros(1,0);
	%  	     
			zeros(1,0),1,0,-1,0,zeros(1,12);
			zeros(1,4),1,0,-1,zeros(1,9);
			zeros(1,8),1,0,-1,zeros(1,5);
			zeros(1,12),1,0,-1,zeros(1,1);
			
			zeros(1,0),1,0, 0,0,zeros(1,12)];
		
		beq=[	pi/2;	pi/2;	pi/2;	pi/2;
			0;	0;	0;	0;
			0];
	end


	     
%  %  	Without nonlinear constraints
%  	[x,fval]=fminunc(@(phidelta1)f_objetivo(phidelta1,param_num),phidelta,options);
%  	[x,fval]=fmincon(@(phidelta1)f_objetivo(phidelta1,param_num),phidelta,[],[],[],[],lb,ub,[],options);
%  	[x,fval]=fminunc(@(phidelta1)f_objetivo(phidelta1,param_num),phidelta,options);
%  	[x,fval]=fmincon(@(phidelta1)f_objetivo(phidelta1,param_num),phidelta,[],[],[],[],lb,ub,@(phidelta1)f_constraints(phidelta1,param_num),options);
	[x,fval]=fmincon(@(phidelta1)f_objetivo_FEM(phidelta1,node_matrix,displacement_hypermatrix,element_matrix,nx,nt,nr),phidelta,[],[],Aeq,beq,[],[],[],options);

%  	With nonlinear constraints for eliminating side effects
%  	[x,fval]=fmincon(@(phidelta1)f_objetivo(phidelta1,param_num),phidelta,[],[],[],[],lb,ub,@(phidelta1)f_constraints(phidelta1,param_num),options);

%  	xgrad=x*180/pi;

	if fval<minimo
	      minimo=fval;
	      x_minimo=x;
	end
end


for i=1:6
	displacement_matrix=displacement_hypermatrix(:,:,i);
	W(:,i)=evalW_col_FEM(phidelta,node_matrix,displacement_matrix,element_matrix,nx,nt,nr);
end

%  vamos aqui

%  W=evalW(x_minimo,param_num_new);

H=pinv(W);
H;

xgrad_minimo=x_minimo*180/pi;

%  fprintf('gauge 1: phi = 0;\t')
%  fprintf('delta = %d;\n',round(xgrad_minimo(1)));

for i=1:n
	fprintf('gauge %d: phi = %d;\t',  i,mod(round(xgrad_minimo(2*i-1)),360) );
	fprintf('delta = %d;\n', mod( round(xgrad_minimo(2*i)),180) );
end

save x_minimo x_minimo

%  SOLUTION
%  --------
%  gauge 1: phi = 0;	delta = 119;
%  gauge 2: phi = 0;	delta = 29;
%  gauge 3: phi = 88;	delta = 151;
%  gauge 4: phi = 88;	delta = 61;
%  gauge 5: phi = 180;	delta = 121;
%  gauge 6: phi = 180;	delta = 31;
%  gauge 7: phi = 272;	delta = 150;
%  gauge 8: phi = 272;	delta = 60;
