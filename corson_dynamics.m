function [f,v] = corson_dynamics(f,v,width,height,dt)
l = 1.25/sqrt(length(f)/(width*height)); %1.25 1.75
D = 5e-5;
tau = 0.5; %0.5 0.1
rng('shuffle');
s = zeros(length(f),1);
eta = zeros(length(f),1);
for i = 1:length(f)
    c = abs(f(i).Centroid.*ones(length(f),2)-cen(f));
    c(c(:,1)>width/2,1)=width-c(c(:,1)>width/2,1);
    c(c(:,2)>height/2,2)=height-c(c(:,2)>height/2,2);
    d_square = c(:,1).^2+c(:,2).^2;
    C = exp(-d_square/(2*l^2));
    C(i) = 0;
    s(i) = sum(C.*signal_production(stateu(f)));
    eta(i) = normrnd(0,sqrt(2*D)*tau);
end
du = (ff(stateu(f),s)-stateu(f)+eta).*dt./tau;
for i = 1:length(f)
    f(i).CorsonCellState=f(i).CorsonCellState+du(i);
    f(i).K = (u2K(stateu(f(i))))*f(i).K;
end
end

function r = sigma(x)
r = (1+tanh(x))./2;
end

function r = signal_production(u)
a0=0.05;
a1=0.95;
r = u.*(a0+a1*3*u.^3./(1+u.^2));
end

function r = ff(u,s)
r = sigma(2.*(u-s));
end

function r = u2K(x)
%u\in[0,1], the hair cell shall have larger 
k = -0.5;
r = k.*sign(tan(x-0.5).*pi)+1+abs(k);
end

function r = u2Gamma(x)
k = 1;
r = k.*heaviside(tan((x-0.5).*pi))+1;
end



