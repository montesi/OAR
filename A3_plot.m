function HA=A3_plot(xb,yb,zb,s,v,ifig,smax,col);
% HA=A3_plot(xb,yb,zb,s,v,ifig,smax,col);
% Makes 3D conical arrows at points {xb,yb,zb}, vector {vx,vy,vz}
% arrow length is s (a vector), maximum length on plot smax 
% color col, figure or axis handle ifig

if strcmp(get(ifig,'type'),'figure')
    figure(ifig);
    hold on;
    Hfig=gca;
else
    Hfig=ifig;
end
nq=20;
th=linspace(0,2*pi,nq);
x=[  0;0.75;0.6;1];
r=[0.1; 0.1;0.3;0]/2;
nz=length(x);

xr=repmat( x,[1,nq]);
tr=repmat(th,[nz,1]);
rr=repmat( r,[1,nq]);
yr=rr.*cos(tr);
zr=rr.*sin(tr);

ns=length(s);
%if ns>1;
    sc=1.*smax/max(s);
    %sc=0.2*sqrt((max(xb)-min(xb))*(max(zb)-min(zb))/length(s));
%else
%    sc=0.2;
%end

for is=1:ns;
    v1=v(is,:)/norm(v(is,:)); %norm(v1)
    % Find one perpendicular vector
    R=sqrt(v1(1).^2+v1(3).^2);
    if R~=0;
        v2=[-v1(3),0,v1(1)]/R;%v2=v2/norm(v2);
    else 
        v2=[1,0,0];
    end
    v3=cross(v1,v2); %v3=v3/norm(v3);
    x=xb(is)+s(is)*(xr*v1(1)+yr*v2(1)+zr*v3(1))*sc;
    y=yb(is)+s(is)*(xr*v1(2)+yr*v2(2)+zr*v3(2))*sc;
    z=zb(is)+s(is)*(xr*v1(3)+yr*v2(3)+zr*v3(3))*sc;

    HA(is,1)=surf(x,y,z,...
        'facecolor',col,'edgecolor','none',...
        'parent',Hfig);
end
%view(3);
%axis equal
lighting phong