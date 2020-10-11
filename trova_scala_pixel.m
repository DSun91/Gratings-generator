function [ scala_mm_per_pixel_orizzontale,scala_mm_per_pixel_verticale, angolo_apert_x,angolo_apert_z ,angolo_i] = trova_scala_pixel( distanza,flag )

d=[1165 1747 2329 2911 3494 4076 4658 5241 5823];%mm
vertical_offset=[25 37 50 62 75 87 100 112 125];%mm
altezza=[498 747 996 1245 1494 1743 1992 2241 2491];%mm
larghezza=[886 1328 1771 2214 2657 3099 3542 3985 4428];%mm
pixel_w=1920;
pixel_h=1080;

for i=1:size(d,2)
    angolo_offset(i)=atand(vertical_offset(i)/d(i));
end

%angolo iniziale
angolo_i=mean(angolo_offset)


%% %angolo apertura_z

for i=1:size(d,2)
    angolo_apertura_z(i)=atand((vertical_offset(i)+altezza(i))/d(i))-angolo_i;
end

angolo_apert_z=mean(angolo_apertura_z);


%% legge  mm/pixel

for i=1:size(d,2)
    pixel_mm_w(i)=larghezza(i)/pixel_w;
    pixel_mm_h(i)=altezza(i)/pixel_h;
end
p_w=polyfit(d,pixel_mm_w,1);
p_h=polyfit(d,pixel_mm_h,1);
x_w=linspace(0,d(9),200);
y_w=x_w.*p_w(1)+p_w(2);
y_h=x_w.*p_h(1)+p_h(2);
%inserire distanza così da sapere quanti millimetri equivalgono al pixel

scala_mm_per_pixel_verticale=distanza*p_h(1)+p_h(2)
scala_mm_per_pixel_orizzontale=distanza*p_w(1)+p_w(2)


%% angolo apertura x



for i=1:size(d,2)
    angolo_apertura_x(i)=2*atand((larghezza(i)/2)/d(i));
end

angolo_apert_x=mean(angolo_apertura_x)

%% grafici
if(flag==1)
figure(10)
hold
title('angolo offset')
xlabel('distanza mm');
ylabel('angolo offset°');
plot(d,angolo_offset,'*'), grid on

figure(20)
hold
title('angolo \delta°')
xlabel('distanza mm');
ylabel('\delta°');
plot(d,angolo_apertura_z,'*'), grid on

figure(30)

P1=subplot(2,1,1)
hold
xlabel(P1, 'distanza mm');
ylabel(P1,'[mm/pixel] orizzontale');
plot(d,pixel_mm_w,'*',x_w,y_w,distanza,scala_mm_per_pixel_orizzontale,'*r'), grid on


P2=subplot(2,1,2)
hold
xlabel(P2, 'distanza mm');
ylabel(P2,'[mm/pixel] vericale');
plot(d,pixel_mm_h,'*',x_w,y_h,distanza,scala_mm_per_pixel_verticale,'*r'), grid on


figure(40)
hold

title('angolo \gamma°')
xlabel('distanza mm');
ylabel('\gamma°');
plot(d,angolo_apertura_x,'*'), grid on
end




end

