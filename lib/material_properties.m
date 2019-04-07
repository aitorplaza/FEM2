function [E_young,nu,rho]=material_properties;

% titanium steel alluminum iron copper
mat = 'steel';

% [E_young] = Pascal= N/m^2
% [nu]      = non-dimensional
% [rho]     = kg/m^3

switch mat
	case ['titanium']
		%  structural steel
		E_young = 103e9;
		nu      = 0.34;
		rho     = 4506;

	case ['steel']
		%  structural steel
		E_young = 200e9;
		nu      = 0.3;
		rho     = 7850;

	case ['alluminum']
		%  alluminium alloy
		E_young = 71e9;
		nu      = 0.3;
		rho     = 2770;

	case ['iron']
		%  Gray cast iron
		E_young = 110e9;
		nu      = 0.3;
		rho     = 7200;

	case ['copper']
		% Copper alloy
		E_young = 100e9;
		nu      = 0.3;
		rho     = 8300;

	otherwise
		disp('error selecting material.')
end

