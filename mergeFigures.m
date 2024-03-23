set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off','WindowState', 'maximized');

h1 = openfig('.\RRO\BD\Figure\BifurcationRRO_A_9.8.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('.\RRO\BD\Figure\lyapunov_exponent_A_9.8.fig','reuse');
ax2 = gca;
h3 = openfig('.\RRO\BD\Figure\AttractorMergingCondition_A_9.8.fig','reuse'); % open figure
ax3 = gca; % get handle to axes of figure

s1 = subplot(3,1,1); %create and get handle to the subplot axes
s2 = subplot(3,1,2);
s3 = subplot(3,1,3);

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');

copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3);

exportgraphics(gca,".\RRO\BD\SystemBehavior_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)