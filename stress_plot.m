function HF=stress_plot(H,angles,xs,zs,xf,zf,is_symm);
% function HF=stress_plot(H,angles,xs,zs,xf,zf,is_symm);
% plot stress tensor (as beach ball) on regular grid
% Stress intensity as background
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H: descriptor of axes (to help superpose plots)
% angles: structure containings the various angles in the flow solution
% xs, zs: sampling point coordinates; y-coordinate from flow
% xt, zt: sampling point for background grid
% is_symm: flag for symmetry (where to plot background (yt))
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dependencies: tj_fun, BB_plot
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

rs=(xs.^2+zs).^(1/2);
ts=real(-sqrt(-1)*log((zs+sqrt(-1)*xs)./rs));
ip=find((ts>=(-a2))&(ts<=a1));

%Rotation vector
wr=2*sin(gamma)./(beta.*rs);
wy=2*(D*sin(ts)-C*sin(ts))./rs;
tau=(wy.^2+wr.^2).^(1/2);

%eigenvalues;
s1=-tau;
s2=0;
s3=tau;

%eigenvectors in cylindrical coordinates
R1=-wy./(sqrt(2).*tau);
T1=-1/sqrt(2);
Y1=wr./(sqrt(2).*tau);
R2=wr./tau;
T2=0;
Y2=wy./tau;
R3=-wy./(sqrt(2).*tau);
T3=1/sqrt(2);
Y3=wr./(sqrt(2).*tau);

%Rotate eigenvectors into carthesian referential
X1=sin(ts).*R1+cos(ts).*T1;
X2=sin(ts).*R2+cos(ts).*T2;
X3=sin(ts).*R3+cos(ts).*T3;
Z1=cos(ts).*R1-sin(ts).*T1;
Z2=cos(ts).*R2-sin(ts).*T2;
Z3=cos(ts).*R3-sin(ts).*T3;

[ys,ts]=tj_fun(angles,xs,zs);

rsize=[prod(size(X1(ip))),1];
HF=BB_plot(...
    reshape(xs(ip),rsize),...
    reshape(ys(ip),rsize),...
    reshape(zs(ip),rsize),...
    ones(rsize)*0.05,...
    [reshape(X1(ip),rsize),reshape(Y1(ip),rsize),reshape(Z1(ip),rsize)],...
    [reshape(X2(ip),rsize),reshape(Y2(ip),rsize),reshape(Z2(ip),rsize)],...
    [reshape(X3(ip),rsize),reshape(Y3(ip),rsize),reshape(Z3(ip),rsize)],...
    H);

% stress intensity in background
rf=(xf.^2+zf).^(1/2);
tf=real(-sqrt(-1)*log((zf+sqrt(-1)*xf)./rf));
wr=2*sin(gamma)./(beta.*rf);
wy=2*(D*sin(tf)-C*sin(tf))./rf;
tau=(wy.^2+wr.^2).^(1/2);
ip=find((tf<(-a2))|(tf>a1));
tau(ip)=NaN;

if is_symm
    HS=surf(xf,xf*0,zf,tau);
else
    HS=surf(xf,xf*0-2,zf,tau);
end

set(HS,'edgecolor','none','ambientstrength',1);
set(gca,'Clim',[0,10]);

colormap(flipud(hot))

warning('on');