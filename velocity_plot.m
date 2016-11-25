function HF=velocity_plot(H,angles,xs,zs);
% function HF=velocity_plot(H,angles,xb,zb);
% plot velocity vectors on regular grid
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H: descriptor of axes (to help superpose plots)
% angles: structure containings the various angles in the flow solution
% xs, zs: sampling point coordinates; yt from flow
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dependencies: tj_fun
%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HF: handles of flow lines plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initializes graph
HF=NaN;
axes(H);
% Parse angles and prepare for theta function
A=angles.A;
B=angles.B;
C=angles.C;
D=angles.D;
beta=angles.beta;
delta=angles.delta;
gamma=angles.gamma;
a1=(beta+delta)/2;
a2=(beta-delta)/2;
VR=0;

% process starting points
rs=(xs.^2+zs.^2).^(1/2);
ts=real(-sqrt(-1)*log((zs+sqrt(-1)*xs)./rs));
% get velocity
vx=A+C*(ts-sin(ts).*cos(ts))-D*(sin(ts)).^2;
vz=-B-C*(cos(ts)).^2-D*(ts+sin(ts).*cos(ts));
vy=(2*ts-delta)*sin(gamma)/beta-VR*tan(gamma);

[yt,te]=tj_fun(angles,xs,zs);

% Actual plotting (if not in lithosphere)
ip=find((ts>(-a2))&(ts<a1));
HF=A3_plot(xs(ip),yt(ip),zs(ip),...
    (vx(ip).^2+vy(ip).^2+vz(ip).^2).^(1/2),...
    [vx(ip),vy(ip),vz(ip)],...
    H,0.2,[0,0,1]);
