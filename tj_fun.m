function [yt,te]=tj_fun(angles,xt,zt);
% function [yt,te]=tj_fun(angles,xt,zt);
% Integrate trajectory as a function of time
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% angles: structure containings the various angles in the flow solution
% xt, zt: starting point coordinates; assumes yt=0;
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dependencies: TH_fun, TH_ODE
%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% yt: positions at time te
% te: time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning('off');
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
thmid=fzero(@(x) TH_fun(x,A,B,C,D),0);

% initialize starting points
nt=numel(xt);
rt=(xt.^2+zt.^2).^(1/2);
tt=real(-sqrt(-1)*log((zt+sqrt(-1)*xt)./rt));
pb=rt.*TH_fun(tt,A,B,C,D);
yt=NaN(size(xt));te=yt;

ns=100;
for ib=1:nt;
    if (zt(ib)~=0)&(xt(ib)~=0)&(tt(ib)<a1)&(tt(ib)>-a2);
        zb(ib)=1;
        tb(ib)=fzero(@(x) TH_fun(x,A,B,C,D)*zb(ib)-pb(ib)*cos(x),thmid);
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
            vy=(2*ths-delta)*sin(gamma)/beta; 
            ys=(cumsum(vy,2))*dt;
            yt(ib)=ys(end);
            te(ib)=t(end);
        else
            te(ib)=0;
            yt(ib)=0;
        end
    end
end
warning('on');