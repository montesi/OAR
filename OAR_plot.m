function Hall=OAR_plot(fig,angles,is_symm);
% function Hall=OAR_plot(fig,angles,is_symm);
% utility controlling all plotting
%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fig: figure structure
% angles: structure containings the various angles in the flow solution
% is_symm: flag for symmetry
%%% Dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Primary: geom3D_plot, flow_plot, velocity_plot, rotation_plot
%   time_plot, strain_plot, stress_plot
% Secondary: tj_fun, TH_plot, TH_ODE
%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hall: structure with all the plot handles 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize
warning('off');
Hall=[];%fig.handles;
ifig=fig.ifig;
figure(ifig);
clf;
hold on;
H=gca;

% Go through all the tags in fig. stucture and call associated plotting
% routine
if fig.tag.geom
    Hall.geom=geom3D_plot(angles,is_symm);
end
if fig.tag.flow
    Hall.Hflow=flow_plot(H,...
        angles,...
        fig.xb,fig.zb);
end
if fig.tag.velocity
    Hall.Hvel=velocity_plot(H,...
        angles,...
        fig.xs,fig.zs);
end
if fig.tag.rotation
    Hall.Hrot=rotation_plot(H,...
        angles,...
        fig.xs,fig.zs);
end
if fig.tag.time
    Hall.Htime=time_plot(H,...
        angles,...
        fig.xbt,fig.zbt,...
        fig.tsamp);
end
if fig.tag.strain
    Hall.Hstrain=strain_plot(H,...
        angles,...
        fig.xs,fig.zs,...
        0.05);
end
if fig.tag.stress
    Hall.Hstress=stress_plot(H,...
        angles,...
        fig.xs,fig.zs,fig.xst,fig.zst,...
        is_symm);
end
if is_symm
    axis([-0.1,1.1,-0.1,2.1,-0.1,1.1])
    else
  
    axis([-1.1,1.1,-2.1,2.1,-0.1,1.1])
end

% set viewpoint and light
set(gca,'ydir','reverse',...
    'zdir','reverse',...
    'dataaspectratio',[1,1,1],...
    'box','on');
switch(fig.Vtag)
    case 0
        view(0,0);
    case 1
        view(-20,15);
    case 2 
        view(-90,90);
    case 3
        view(90,0);
end

lighting phong
HL=camlight(-40,60);
set(gca,'visible','off')
warning('on')