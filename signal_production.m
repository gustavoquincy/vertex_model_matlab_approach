function r = signal_production(u)
a0=0.05;
a1=0.95;
r = u.*(a0+a1*3*u.^3./(1+u.^2));
end
