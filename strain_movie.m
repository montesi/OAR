function strain_movie(ifig,angles,xb,zb,rat,Fname,issymm);
% function strain_movie(ifig,angles,xb,zb,rat,Fname,issymm)
% Drives the generation of a movie with evolving strain elipses
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ifig: figure number
% angles: structure containings the various angles in the flow solution
% xt, zt: starting point coordinates; assumes yt=0;
% rat: initial size of strain "sphere"
% Fname: file names (automatically generated by OAR_GUI)
% is_symm: flag for symmetry
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Primary: flow_plot, BB_plot, A3_plot, stress_fun
% Secondary: tj_fun, TH_plot, TH_ODE
%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphical output only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
thmid=fzero(@(x) TH_fun(x,A,B,C,D),0);

% initialize figure
figure(ifig);
clf;
hold on;

%cross section
subplot(121); 
Hx=gca;
view(0,0);
hold on
set(gca,'ydir','reverse',...
    'zdir','reverse',...
    'dataaspectratio',[1,1,1],...
    'box','on');
lighting phong
HLx=camlight(-40,60);
set(gca,'visible','off')
        colormap('jet');
        set(gca,'Clim',[0,2]);
        lighting phong
warning('on')

% top view
subplot(122);
Hm=gca;
view(0,90)
hold on
set(gca,'ydir','reverse',...
    'zdir','reverse',...
    'dataaspectratio',[1,1,1],...
    'box','on',...
    'ylim',[-0.3,0.50],...
    'xlim',[-1,1]*0.2);
text(-0.05,-0.3,'Map view')
lighting phong
HLm=camlight(-30,-10);
        colormap('jet');
        set(gca,'Clim',[0,2]);
        lighting phong
set(gca,'visible','off')

% call various plots
if issymm
    Hflow=flow_plot(Hx,...
        angles,...
        [0.1:0.1:1],[0.1:0.1:1]*0+1);
    HG1=plot3([0,1,1,0,0],[0,0,0,0,0]-1,[0,0,1,1,0],'k');
    if a1>pi/4;
        HG2=fill3([0,1,1,0],[0,0,0,0]-1,[0,0,1/tan(a1),0],...
            [0.5,1,0.75]);
    else
        HG2=fill3([0,1,1,tan(a1),0],[0,0,0,0,0]-1,[0,0,1,1,0],...
            [0.5,1,0.75]);
    end
    HT=text(0.2,0,-0.1,'Cross section t=0');
    axis([-0.1,1.1,-0.1,2.1,-0.1,1.1]);
    set(Hx,'position',[0.05,0.1,0.6,0.8])
    set(Hm,'position',[0.7,0.1,0.25,0.8])
    set(ifig,'position',[50,50,650,450],'color','w')
else
    Hflow=flow_plot(Hx,...
        angles,...
        [-1:0.1:1],[-1:0.1:1]*0+1);
    HT=text(-0.2,0,-0.2,'Cross section t=0'); 
    HG1=plot3([-1,1,1,-1,-1],[0,0,0,0,0]-1,[0,0,1,1,0],'k');
    if a1>pi/4;
        if a2>pi/4
            HG2=fill3([-1,1,1,0,-1,-1],...
                [0,0,0,0,0,0]-1,...
                [0,0,1/tan(a1),0,1/tan(a2),0],...
                [0.5,1,0.75]);
        else
            HG2=fill3([-1,1,1,0,-tan(a2),-1,-1],...
                [0,0,0,0,0,0,0]-1,...
                [0,0,1/tan(a1),0,1,1,0],...
                [0.5,1,0.75]);
        end
    else
        if a2>pi/4
            HG2=fill3([-1,1,1,tan(a1),0,-1,-1],...
                [0,0,0,0,0,0,0]-1,...
                [0,0,1,1,0,1/tan(a2),0],...
                [0.5,1,0.75]);
        else
            HG2=fill3([-1,1,1,tan(a1),0,-tan(a2),-1,-1],...
                [0,0,0,0,0,0,0,0]-1,...
                [0,0,1,1,0,1,1,0],...
                [0.5,1,0.75]);
        end
    end
    axis([-1.1,1.1,-2.1,2.1,-0.1,1.1])
    set(Hx,'position',[0.05,0.1,0.7,0.8])
    set(Hm,'position',[0.75,0.1,0.2,0.8])
    set(ifig,'position',[50,50,900,450],'color','w')
end

%initialize sphere
nsp=100;
[xsp,ysp,zsp]=sphere(nsp);
xsp=xsp*rat;ysp=ysp*rat;zsp=zsp*rat;

%initialize flow line
rb=(xb.^2+zb.^2).^(1/2);
tb=real(-sqrt(-1)*log((zb+sqrt(-1)*xb)./rb));
pb=rb.*TH_fun(tb,A,B,C,D);

%define time sampling
dt=0.02; tmax=3;
ts=0:dt:tmax;
ns=length(ts);

%solve trajectory to lithosphere
if tb>thmid; %determine final angle
    tf=a1;
else
    tf=-a2;
end
warning('off'); %solve time(angle)
[th,t]=ode45(@TH_ODE,[tb,tf],0,[],A,B,C,D);
t=t*pb;
te=t(end);

%resample at short time inteval
ths=interp1(t,th,ts);
rs=pb./TH_fun(ths,A,B,C,D);
xs=rs.*sin(ths);
zs=rs.*cos(ths);
vy=(2*ths-delta)*sin(gamma)/beta; 
ys=(cumsum(vy,2))*dt;

if te<tmax %flow line enters lithosphere
    ye=spline(ts,ys,te);
    xe=spline(ts,xs,te);
    ze=spline(ts,zs,te);
    il=find(ts>te);
    zs(il)=ze;
    if tb>thmid
        xs(il)=(1-angles.VR)*(ts(il)-te)*cos(gamma)+xe;
        ys(il)=(1-angles.VR)*(ts(il)-te)*sin(gamma)+ye;
    else
        xs(il)=-(1+angles.VR)*(ts(il)-te)*cos(gamma)+xe;
        ys(il)=-(1+angles.VR)*(ts(il)-te)*sin(gamma)+ye;
    end
end

% Plot flow line
axes(Hx);Hf=plot3(xs(1),ys(1),zs(1),'k','linewidth',2);
% Plot first strain ellipse
F=eye(3);
xf=(xsp*F(1,1)+ysp*F(2,1)+zsp*F(3,1));
zf=(xsp*F(1,3)+ysp*F(2,3)+zsp*F(3,3));
yf=(xsp*F(1,2)+ysp*F(2,2)+zsp*F(3,2));
ST=((xf-0).^2+(yf-0).^2+(zf-0).^2).^(1/2);
axes(Hx);HSB=surf(xs(1)+xf,ys(1)+yf,zs(1)+zf,ST/(rat),...
    'edgecolor','none','parent',Hx);
axes(Hm);HS=surf(xf,yf,zf,ST/(rat),...
    'edgecolor','none','parent',Hm);
HA=A3_plot(0,0,-0.5,1,[cos(gamma),sin(gamma),0],...
    Hm,0.2,[0,0,0]);

%stress beach ball
[tau,V1,V2,V3]=stress_fun(xb,zb,angles);
HB=BB_plot(0,0.3,0,0.1,V1,V2,V3,Hm);

% mov=avifile(Fname);
mov = VideoWriter(Fname,'MPEG-4');
open(mov);
writeVideo(mov,getframe(ifig));

% iterate over time
for is=1:ns
    %calculate new strain matrix
    tn=ths(is);
    if ~isnan(ths(is)) %position not in lithosphere
        rn=rs(is);
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
        xf=(xsp*F(1,1)+ysp*F(2,1)+zsp*F(3,1));
        zf=(xsp*F(1,3)+ysp*F(2,3)+zsp*F(3,3));
        yf=(xsp*F(1,2)+ysp*F(2,2)+zsp*F(3,2));
        ST=((xf-0).^2+(yf-0).^2+(zf-0).^2).^(1/2);
    end %otherwise in lithosphere, keep the same

    %update plot
    axes(Hx)
    delete(Hf);delete(HSB)
    ip=find(xs(1:is)<1);
    Hf=plot3(xs(ip),ys(ip),zs(ip),'k','linewidth',2);
    HSB=surf(xs(is)+xf,ys(is)+yf,zs(is)+zf,ST/(rat),...
        'edgecolor','none','parent',Hx);
    set(HT,'string',sprintf('cross section, t=%g',ts(is)))

    axes(Hm)
    delete(HB); delete(HS)
    [tau,V1,V2,V3]=stress_fun(xs(is),zs(is),angles);
    if tau~=0
        sz=0.1;
    else
        sz=0;
    end
    HB=BB_plot(0,0.3,0,sz,V1,V2,V3,Hm);
    HS=surf(xf,yf,zf,ST/(rat),...
        'edgecolor','none','parent',Hm);
    lighting phong
    % plot and add frame
    drawnow
    writeVideo(mov,getframe(ifig));
end
close(mov);

disp('Movie_done')