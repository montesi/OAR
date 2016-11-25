function Hb=BB_plot(xb,yb,zb,s,v1,v2,v3,ifig);
% Hb=BB_plot(xb,yb,zb,s,v1,v2,v3,ifig);
% Makes 3D "beach ball" representation of stress tensor
% Beach balls at points {xb,yb,zb}, principal axes vectors {vx,vy,vz}
% Beach ball size is s (a vector), maximum length on plot smax 
% figure or axis handle ifig

dq=20;nq=4*dq;
[x,y,z]=sphere(nq);
xr=(x+y)/sqrt(2);
yr=(-x+y)/sqrt(2);
zr=z;
%sc=0.8*sqrt((max(xb(:))-min(xb(:)))*(max(zb(:))-min(zb(:)))/length(s(:)))/max(s(:));
sc=1;%*sqrt((max(xb(:))-min(xb(:)))*(max(zb(:))-min(zb(:)))/length(s(:)));

if strcmp(get(ifig,'type'),'figure')
    figure(ifig);
    hold on;
    Hfig=gca;
else
    Hfig=ifig;
end;

ns=length(s(:));
for is=1:ns;
    % Rotate and scale beach ball
     x=xb(is)+s(is)*(xr*v1(is,1)+yr*v3(is,1)+zr*v2(is,1))*sc;
     y=yb(is)+s(is)*(xr*v1(is,2)+yr*v3(is,2)+zr*v2(is,2))*sc;
     z=zb(is)+s(is)*(xr*v1(is,3)+yr*v3(is,3)+zr*v2(is,3))*sc;

    iq=1:dq+1;% iq=[iq,iq+2*dq];
    % tensile quadrants
    Hb(is,1)=surf(x(:,iq),y(:,iq),z(:,iq),...
        'facecolor',[1,1,1]*0.8,'edgecolor','none',...
        'parent',Hfig);
    iq=mod(iq+2*dq-1,nq)+1;
    Hb(is,2)=surf(x(:,iq),y(:,iq),z(:,iq),...
        'facecolor',[1,1,1]*0.8,'edgecolor','none',...
        'parent',Hfig);
    % Compressive quadrant
    iq=mod(iq-dq-1,nq)+1;
    Hb(is,3)=surf(x(:,iq),y(:,iq),z(:,iq),...
        'facecolor',[1,1,1]*0.2,'edgecolor','none',...
        'parent',Hfig);
    iq=mod(iq+2*dq-1,nq)+1;
    Hb(is,4)=surf(x(:,iq),y(:,iq),z(:,iq),...
        'facecolor',[1,1,1]*0.2,'edgecolor','none',...
        'parent',Hfig);
end
%view(3);
%axis equal
lighting phong