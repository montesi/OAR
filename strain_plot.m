function HF=strain_plot(H,angles,xt,zt,rat);
% function HF=strain_plot(H,angles,xt,zt,rat);
% plot strain ellipses along flow lines
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H: descriptor of axes (to help superpose plots)
% angles: structure containings the various angles in the flow solution
% xt, zt: starting point coordinates; assumes yt=0;
% rat: initial size of strain "sphere"
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dependencies: TH_fun, TH_ODE
%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HF: handles of flow lines plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning('off');
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
%VR=0;
% find the line separating the right and left flow lines
thmid=fzero(@(x) TH_fun(x,A,B,C,D),0);

% ftag: if 0, plot at y=0, otherwise take y(0)=0;
ftag=1;

% process initial points
nt=prod(size(xt));
rt=(xt.^2+zt.^2).^(1/2);
tt=real(-sqrt(-1)*log((zt+sqrt(-1)*xt)./rt));
pb=rt.*TH_fun(tt,A,B,C,D);

%initialize sphere
ns=100;
[xsp,ysp,zsp]=sphere(100);
xsp=xsp*rat;ysp=ysp*rat;zsp=zsp*rat;

for ib=1:nt; % for each flow line
    HF(ib)=NaN;
    if (zt(ib)~=0)&(xt(ib)~=0)&(tt(ib)<a1)&(tt(ib)>-a2);
        zb(ib)=1;
        tb(ib)=fzero(@(x) TH_fun(x,A,B,C,D)*zb(ib)-pb(ib)*cos(x),thmid);
        rb(ib)=pb(ib)/TH_fun(tb(ib),A,B,C,D);
        xb(ib)=rb(ib)*sin(tb(ib));
        %disp(sprintf('ib=%d of %d: |tb-tt|<10*eps:%g',ib,nt,abs(tb(ib)-tt(ib))<(10*eps)))
        %disp(sprintf('Working on ib=%d of %d: xb,zb=%g,%g, xt,zt=%g,%g',ib,nt,xb(ib),zb(ib),xt(ib),zt(ib)))
        if abs(tb(ib)-tt(ib))>(10*eps)
            %disp(sprintf('Working on ib=%d of %d: tb=%g, tt=%g',ib,nt,tb(ib),tt(ib)))
            %Find trajectory
            warning('off');
            [th,t]=ode45(@TH_ODE,[tb(ib),tt(ib)],0,[],A,B,C,D);
            warning('on');
            %resample at short time inteval
            t=t*pb(ib);
            ts=linspace(t(1),t(end),ns);
            dt=ts(2)-ts(1);
            ths=interp1(t,th,ts);
            rs=pb(ib)./TH_fun(ths,A,B,C,D);
            xs=rs.*sin(ths);
            zs=rs.*cos(ths);
            % strain in the y-direction
            vy=(2*ths-delta)*sin(gamma)/beta; %assume Vr=0;
            ys=(cumsum(vy,2))*dt;

            %integrate strain
            F=eye(3);yn(1)=0;
            for is=1:ns-1
                tn=ths(is);rn=rs(is);
                s=sin(tn);c=cos(tn);
                %rotation rates
                wr=2*sin(gamma)./(beta*rn);
                wy=2*(D*c-C*s)/rn;
                %Velocity gradient matrix
                L=wy*[-s.*c,0,-c.^2;...
                    0,0,    0;...
                    s.^2,0,s.*c]+...
                    wr*[0,c,0;...
                    0,0,0;...
                    0,-s,0];
                LA=eye(3)-L*dt/2;
                LB=eye(3)+L*dt/2;
                F=inv(LA)*LB*F;
            end
        else
            F=eye(3);
            ys=0;
        end
        % plotting
        xf=xt(ib)+(xsp*F(1,1)+ysp*F(2,1)+zsp*F(3,1));
        zf=zt(ib)+(xsp*F(1,3)+ysp*F(2,3)+zsp*F(3,3));
        if ftag
            ypl=ys(end);
        else
            ypl=0;
        end
        yf=ypl+(xsp*F(1,2)+ysp*F(2,2)+zsp*F(3,2));
        
        ST=((xf-xt(ib)).^2+(yf-ypl).^2+(zf-zt(ib)).^2).^(1/2);

        colormap('jet');
        HF(ib)=surf(xf,yf,zf,ST*10/(2*rat),'edgecolor','none','parent',H);
        set(gca,'Clim',[0,10]);
        lighting phong
    end
end
warning('on');