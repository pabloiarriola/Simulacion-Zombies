figure(2)
plot((0:t)*dt,zt,'r','LineWidth',2)
hold on
plot((0:t)*dt,ht,'b','LineWidth',2)
legend('Zombi','Humano');
title('Poblacion-Tiempo');
xlabel('Tiempo');
ylabel('Poblacion');
hold off