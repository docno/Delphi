function NEW8_ode()
tspan=[0:0.5:500];
x0=[620;10;70];
[t

koef,x]=ode45(@NEW8_funsys,tspan,x0);
f = figure('Visible','off');
plot (t

koef,x(:,[1,2,3]),'lineWidth',3);
grid on;
legend('x`1','x`2','x`3');
print('-dbmp','-r80','graf.bmp');

