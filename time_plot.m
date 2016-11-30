function HF=time_plot(H,angles,xb,zb,ts);
% function HF=time_plot(H,angles,xb,zb);
% plot time contours, fro particles starting at the base of the box at t=0
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H: descriptor of axes (to help superpose plots)
% angles: structure containings the various angles in the flow solution
% xb, zb: initial point coordinates; assumes yb=0
% ts: sampling time vector
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
VR=angles.VR;
a1=(beta+delta)/2;
a2=(beta-delta)/2;
%VR=0;
thmid=fzero(@(x) TH_fun(x,A,B,C,D),0);

% initialize flow lines
ns=length(ts);
nb=length(xb);
rb=(xb.^2+zb.^2).^(1/2);
tb=real(-sqrt(-1)*log((zb+sqrt(-1)*xb)./rb));
pb=rb.*(A*cos(tb)+B*sin(tb)+C*tb.*cos(tb)+D*tb.*sin(tb));

te=nan(1,nb);ye=te; ze=te;
% integrate
for ib=1:nb;
    ths(ib,1:ns)=nan(1,ns);
%     if (xb(ib)~=0)&(tb(ib)~=thmid)
    if tb(ib)~=thmid
        warning('off');
        if tb(ib)>thmid
            %disp('right side');
            [th,t]=ode23(@TH_ODE,[tb(ib),a1-eps],0,...
                odeset('RelTol', 1e-4),A,B,C,D);
        elseif tb(ib)<thmid
            %disp('left side');
            [th,t]=ode23(@TH_ODE,[tb(ib),-a2+eps],0,...
                odeset('RelTol', 1e-6),A,B,C,D);
        end
        warning('on');
        t=t*pb(ib);
        te(ib)=t(end,1);
        ths(ib,1:ns)=interp1(t,th,ts);
    end
    rs(ib,1:ns)=pb(ib)./TH_fun(ths(ib,:),A,B,C,D);
end
vy=(2*ths-delta)*sin(gamma)/beta; 
ys=(cumsum(vy,2))*(ts(2)-ts(1));
ys=ys-repmat(ys(:,1),[1,ns]);
xs=rs.*sin(ths);
zs=rs.*cos(ths);
warning ('off')


for ib=1:nb %correct for entry in the lithosphere
    if (te(ib)<max(ts))&(te(ib)~=0)&~isnan(te(ib))
        ye=spline(ts,ys(ib,:),te(ib));
        xe=spline(ts,xs(ib,:),te(ib));
        ze=spline(ts,zs(ib,:),te(ib));
        il=find(ts>te(ib));
        zs(ib,il)=ze;
        if tb(ib)>thmid
            xs(ib,il)=(ts(il)-te(ib))*cos(gamma)*(1-VR)+xe;
            ys(ib,il)=(ts(il)-te(ib))*sin(gamma)*(1-VR)+ye;
        else
            xs(ib,il)=-(ts(il)-te(ib))*cos(gamma)*(1+VR)+xe;
            ys(ib,il)=-(ts(il)-te(ib))*sin(gamma)*(1+VR)+ye;
        end
    end
end

% plot lines
sc=25;
nc=floor(ns/sc);
for ic=1:nc;
    is=(ic-1)*sc+1;
    ip1=find((xs(:,is)<=1)&(xs(:,is)>=-1)&(zs(:,is)<=1)&(zs(:,is)>=0));
    if ~isempty(ip1)
        HF(is,1)=plot3(xs(ip1,is),ys(ip1,is),zs(ip1,is),'k-');
    else
        HF(is,1)=NaN;
    end
    ip2=find((xs(:,is)<=1)&(xs(:,is)>=-1)&(zs(:,is)<=1)&(zs(:,is)>=0)&(ths(:,is)<thmid));
     if ~isempty(ip2)
         HF(is,2)=plot3(xs(ip2,is),ys(ip2,is),zs(ip2,is),'k-');
     else
         HF(is,2)=NaN;
     end
end