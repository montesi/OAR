function dt = TH_ODE(th,t,A,B,C,D)
% evaluate derivative of t at angle th
dt=(A*cos(th)+B*sin(th)+C*th.*cos(th)+D*th.*sin(th)).^(-2);
