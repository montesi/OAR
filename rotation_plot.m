function HF=rotation_plot(H,angles,xs,zs);
% function HF=rotation_plot(H,angles,xs,zs);
% plot rotation vectors on regular grid
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H: descriptor of axes (to help superpose plots)
% angles: structure containings the various angles in the flow solution
% xs, zs: sampling point coordinates
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dependencies: tj_fun, A3_plot
%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HF: handles of flow lines plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initializes graph
HF=NaN;
axes(H);
% Parse angles and prepare for tj function
%A=angles.A;
%B=angles.B;
C=angles.C;
D=angles.D;
beta=angles.beta;
delta=angles.delta;
gamma=angles.gamma;
a1=(beta+delta)/2;
a2=(beta-delta)/2;
%VR=0;

% process starting points
rs=(xs.^2+zs).^(1/2);
ts=real(-sqrt(-1)*log((zs+sqrt(-1)*xs)./rs));

%Rotation vector
wr=2*sin(gamma)./(beta.*rs);
wt=wr*0;
wy=2*(D*sin(ts)-C*sin(ts))./rs;
wx=sin(ts).*wr+cos(ts).*wt;
wz=cos(ts).*wr-sin(ts).*wt;
w=sqrt(wx.^2+wy.^2+wz.^2);


[ys,te]=tj_fun(angles,xs,zs);

% Actual plotting (if not in lithosphere)
ip=find((ts>(-a2))&(ts<a1));
HF=A3_plot(xs(ip),ys(ip),zs(ip),...
    w(ip),...
    -[wx(ip),wy(ip),wz(ip)],...
    H,0.2,[1,0,0]);
