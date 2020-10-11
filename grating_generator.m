clear all
clc
tipo_frange=1;%1 sinusoidali, 2 rettangolari
distanza_proiezione=290;%mm
[sx,sy,angolo_ap_x,angolo_apertura_z,angolo_i]=trova_scala_pixel(distanza_proiezione,0)
A=0.5;
dimesion_x_sensore_pixels=1980;
dimesion_y_sensore_pixels=1080;
angolo_per_pixel_x=angolo_ap_x/dimesion_x_sensore_pixels;
angolo_per_pixel_y=angolo_apertura_z/dimesion_y_sensore_pixels;
dimensioni_finestra_proiezione_x=420;
dimensioni_finestra_proiezione_y=420;
offset_finestra_y=100;
angolo_i=angolo_i+offset_finestra_y*angolo_per_pixel_y
angolo_apertura_x_eff=angolo_per_pixel_x*dimensioni_finestra_proiezione_x
angolo_apertura_z_eff=angolo_per_pixel_y*(dimensioni_finestra_proiezione_y)
T=60;%frange/periodo
pii(1)=0;
pii(2)=pi/2;
pii(3)=pi;
pii(4)=(3/2)*pi;
phase=pii(1);
angolo_proi=35;
angolo_i=20;
ang_finale=angolo_i+angolo_apertura_z_eff;
numero_sin=12;
numero_frange=numero_sin*T;
xb=linspace(-distanza_proiezione*sind(angolo_apertura_x_eff/2),distanza_proiezione*sind(angolo_apertura_x_eff/2),(numero_frange)+1);
213
zb_alto=linspace(distanza_proiezione*tand(ang_finale),distanza_proiezione*tand(ang_finale),numero_frange+1);
zb_basso=linspace(distanza_proiezione*tand(angolo_i),distanza_proiezione*tand(angolo_i),numero_frange+1);
yb=linspace(distanza_proiezione,distanza_proiezione,numero_frange+1);
figure(1)
xlabel('[mm]');
ylabel('[mm]');
for i=1:numero_frange
if(tipo_frange==2)
if(mod(i,2)==1)
color(i)=0;
else color(i)=1;
end
else if(tipo_frange==1)
% if(i==100)
% phase=pi/4;
% else
% phase=0;
% end
color(i)=0.5+A*sin((2*pi/T)*(i-1)+phase);
end
end
patch([xb(i) xb(i) xb(i+1) xb(i+1)],[zb_alto(i) zb_basso(i) zb_basso(i+1) zb_alto(i+1)],[color(i) color(i) color(i)],'LineStyle','none');
end
%piano
R1=[cosd(angolo_proi) -sind(angolo_proi) 0;
sind(angolo_proi) cosd(angolo_proi) 0;
0 0 1];
R2=[0 0 1;
0 cosd(angolo_i) -sind(angolo_i);
0 sind(angolo_i) cosd(angolo_i)];
dist_plane=100;
Q=R2*R1;
k=[0,1,0]*Q;
a=k(1);
b=k(2);
c=k(3);
d=-b*dist_plane;
for i=1:numero_frange+1
t1=(-d)/(a*xb(i)+b*yb(i)+c*zb_basso(i));
t2=(-d)/(a*xb(i)+b*yb(i)+c*zb_alto(i));
x_intersez_alto(i)=t1*xb(i);
y_intersez_alto(i)=t1*yb(i);
z_intersez_alto(i)=t1*zb_alto(i);
x_intersez_basso(i)=t2*xb(i);
y_intersez_basso(i)=t2*yb(i);
z_intersez_basso(i)=t2*zb_basso(i);
end
figure(2)
hold
grid
%ylim([0 301])
for i=1:numero_frange
xx=[x_intersez_alto(i) x_intersez_basso(i) x_intersez_basso(i+1) x_intersez_alto(i+1)];
214
yy=[y_intersez_alto(i) y_intersez_basso(i) y_intersez_basso(i+1) y_intersez_alto(i+1)];
zz=[z_intersez_alto(i) z_intersez_basso(i) z_intersez_basso(i+1) z_intersez_alto(i+1)];
fill3(xx,yy,zz,[color(i) color(i) color(i)],'LineStyle','none');
xx1=[xb(i) xb(i) xb(i+1) xb(i+1)];
yy1=[yb(i) yb(i) yb(i+1) yb(i+1)];
zz1=[zb_alto(i) zb_basso(i) zb_basso(i+1) zb_alto(i+1)];
fill3(xx1,yy1,zz1,[color(i) color(i) color(i)],'LineStyle','none');
end
%2100 -325
figure('Units','pixels','pos',[100 100 420 420])
hold
set(gca,'position',[0 0 1 1],'units','normalized')
axis 'equal'
%xlim([x_intersez_basso(1),x_intersez_basso(numero_frange)]);
% ylim([z_intersez_basso(numero_frange),5.0]);
%
axis off
% axis 'off'
%set(gca,'Xdir','reverse')
for i=1:numero_frange
% if(mod(i,2)==1)
% color=[0 0 0];
% else color=[0.8 0.8 0.8];
% end
x(i)=i-1;
x_p=[x_intersez_alto(i) x_intersez_basso(i) x_intersez_basso(i+1) x_intersez_alto(i+1)];
z_p=[z_intersez_alto(i) z_intersez_basso(i) z_intersez_basso(i+1) z_intersez_alto(i+1)];
j= patch(x_p,z_p,[color(i) color(i) color(i)],'LineStyle','none'); grid
end
%
hold off
figure(4)
plot(x,color),grid