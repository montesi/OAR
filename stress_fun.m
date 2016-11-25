function [tau,V1,V2,V3]=stress_fun(xs,zs,angles)
if length(xs(:))>1
    disp('Sorry, stress_fun is only for single points');
    return
end

C=angles.C;
D=angles.D;
beta=angles.beta;
delta=angles.delta;
gamma=angles.gamma;
a1=(beta+delta)/2;
a2=(beta-delta)/2;

rs=(xs.^2+zs).^(1/2);
ts=real(-sqrt(-1)*log((zs+sqrt(-1)*xs)./rs));
if (ts>=(-a2))&(ts<=a1);
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

    V1=[X1 Y1 Z1];
    V2=[X2 Y2 Z2];
    V3=[X3 Y3 Z3];
else
    tau=0;
    V1=[1 0 0];
    V2=[0 1 0];
    V3=[0 0 1];
end