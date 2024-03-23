

load('results_evaluate_signal_res_D_SR.mat');


smooth_w=10;

corr_m(1,:)=smooth(mean(corr(:,1,:),1),smooth_w);
corr_m(2,:)=smooth(mean(corr(:,2,:),1),smooth_w);
corr_m(3,:)=smooth(mean(corr(:,3,:),1),smooth_w);

corr_std(1,:)=smooth(std(corr(:,1,:)),smooth_w);
corr_std(2,:)=smooth(std(corr(:,2,:)),smooth_w);
corr_std(3,:)=smooth(std(corr(:,3,:)),smooth_w);

D_conf1=[D D(end:-1:1)];
corr_conf1=[corr_m(1,:)+corr_std(1,:) corr_m(1,end:-1:1)-corr_std(1,end:-1:1)]

D_conf2=[D D(end:-1:1)];
corr_conf2=[corr_m(2,:)+corr_std(2,:) corr_m(2,end:-1:1)-corr_std(2,end:-1:1)]

D_conf3=[D D(end:-1:1)];
corr_conf3=[corr_m(3,:)+corr_std(3,:) corr_m(3,end:-1:1)-corr_std(3,end:-1:1)]



set(0,'defaultAxesFontSize',18);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',18);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])


semilogx(D,corr_m(1,:),'blue','LineWidth',2);
hold on;
semilogx(D,corr_m(2,:),'red','LineWidth',2);
semilogx(D,corr_m(3,:),'green','LineWidth',2);

%{
fi_1=fill(D_conf1,corr_conf1,'blue');
fi_2=fill(D_conf2,corr_conf2,'red');
fi_3=fill(D_conf3,corr_conf3,'green');

fi_1.FaceColor = [0.8 0.8 1];       % make the filled area  blue
fi_1.EdgeColor = 'none';            % remove the line around the filled area
fi_1.FaceAlpha = 0.5;

fi_2.FaceColor = [1.0 0.8 0.8];       % make the filled area  blue
fi_2.EdgeColor = 'none';            % remove the line around the filled area
fi_2.FaceAlpha = 0.5;

fi_3.FaceColor = [0.8 1.0 0.8];       % make the filled area  blue
fi_3.EdgeColor = 'none';            % remove the line around the filled area
fi_3.FaceAlpha = 0.5;
%}
grid on;


ylim([0 1.0]);
ylabel('max_\tau C(\tau)');
xlabel('Noise strength D');
legend('a=2.82','a=2.825','a=2.83','location','Northeast');
saveas(gca,'res_D_SR.eps','epsc');



