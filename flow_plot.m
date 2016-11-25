function HF=flow_plot(H,angles,xb,zb);
% function HF=flow_plot(H,angles,xb,zb);
% Generates flow lines and plot them.
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H: descriptor of axes (to help superpose plots)
% angles: structure containings the various angles in the flow solution
% xb, zb: starting point coordinates (assumes yb=0)
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dependencies: TH_fun, TH_ODE
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

% find the line separating the right and left flow lines
thmid=fzero(@(x) TH_fun(x,A,B,C,D),0);

% Find starting points
nb=length(xb);
rb=(xb.^2+zb.^2).^(1/2);
tb=real(-sqrt(-1)*log((zb+sqrt(-1)*xb)./rb));
pb=rb.*(A*cos(tb)+B*sin(tb)+C*tb.*cos(tb)+D*tb.*sin(tb));

% Initialize integration
ns=1000;
ts=linspace(0,10,ns);

for ib=1:nb; %for each starting point
    % initialize
    HF(ib)=NaN; 
    ths=nan(1,ns);
    if tb(ib)~=thmid; %integrate
        warning('off');
        if tb(ib)>thmid
            %disp('right side');
            [th,t]=ode45(@TH_ODE,[tb(ib),a1-eps],0,[],A,B,C,D);
        elseif tb(ib)<thmid
            %disp('left side');
            [th,t]=ode45(@TH_ODE,[tb(ib),-a2+eps],0,[],A,B,C,D);
        end
        warning('on');
        t=t*pb(ib);
        ths=interp1(t,th,ts);
    end
    % Find x-y-z coordinates of points to plot. 
    rs=pb(ib)./TH_fun(ths,A,B,C,D); %change from 
    xs=rs.*sin(ths);
    zs=rs.*cos(ths);
    vy=(2*ths-delta)*sin(gamma)/beta; %assume Vry=0;
    ys=(cumsum(vy,2))*(ts(2)-ts(1));
    ys=ys-ys(1);
    
    % Actual plotting
    ip1=find((xs<=1)&(xs>=-1)&(zs<=1)&(zs>=0));
    if ~isempty(ip1)
        HF(ib)=plot3(xs(ip1),ys(ip1),zs(ip1),'b-');
        %disp(sprintf('ib=%d: ths(end)=%g',ib,ths(end)));
        ip2=find(~isnan(xs));
        if tb(ib)>thmid
            rl=pb(ib)./TH_fun(a1,A,B,C,D);
            xl=rl.*sin(a1);
            zl=rl.*cos(a1);
            yl=spline(xs(ip2),ys(ip2),xl);
            ye=yl+(1-xl)*tan(gamma);
        elseif tb(ib)<thmid
            rl=pb(ib)./TH_fun(-a2,A,B,C,D);
            xl=rl.*sin(-a2);
            zl=rl.*cos(-a2);
            yl=spline(xs(ip2),ys(ip2),xl);
            ye=yl+(-1-xl)*tan(gamma);
        end
        %disp(sprintf('ib=%d: [zl,yl,yr]=[%g,%g,%g]',ib,zl,yl,ye));
        if abs(xl)<1;
            HF2(ib)=plot3([xl,sign(xl)],[yl,ye],[1,1]*zl,...
                'b--','linewidth',1);
        end
    else
        HF(ib)=NaN;
    end
    
end