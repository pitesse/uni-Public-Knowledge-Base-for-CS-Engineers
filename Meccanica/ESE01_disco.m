clear; close all; clc;
 
%% Initialization

% Parameters
R = 1;                          % Radius of the disk
L = 2*R;                        % Length of the rod

% Motion law
omegad = 10;                    %[rad/s^2]
timeEnd = (2*pi*2/omegad)^0.5;  % compute end time to complete a full rotations
time = linspace(0,timeEnd,100);
omega = omegad*time;            % [rad/s]
theta = 0.5*omegad*time.^2;     % [rad]

%% Positions

a = R;
alpha = pi/2;

b = R*theta;
beta = 0;

c = L;
gamma = 3*pi/2 - theta;

% cartesian coordinates
xB = a*cos(alpha) + b*cos(beta) + c*cos(gamma);
yB = a*sin(alpha) + b*sin(beta) + c*sin(gamma);

xC = b + 2*R;               % arbitrary initial position at 2 m from the origin
yC = R;

% position of point D
% xD = ..
% yD = ..

%% Velocities

gammad = -omega;            % NB: negative sign to comply with sign convention
bd = R*omega;

% cartesian coordinates
xBd = bd*cos(beta) - c*gammad.*sin(gamma);
yBd = bd*sin(beta) + c*gammad.*cos(gamma);

% velocity of the center of the disc
xCd = bd.*cos(beta);

% velocity of point D
% xDd = ..
% yDd = ..

%% Accelerations

gammadd = -omegad;          % NB: negative sign to comply with sign convention
bdd = R*omegad;

% cartesian coordinates
xBdd = bdd*cos(beta) - c*gammadd.*sin(gamma) - c*gammad.^2.*cos(gamma);
yBdd = bdd*sin(beta) + c*gammadd.*cos(gamma) - c*gammad.^2.*sin(gamma);

% acceleration of the center of the disk
xCdd = bdd*cos(beta);

% acceleration of point D
% xDdd = ..
% yDdd = ..

%% Computations for animations

set(0,'defaultTextInterpreter','latex');
set(0,'defaultTextFontSize',12)
set(0,'defaultAxesFontSize',12)
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
set(groot,'defaultLegendLocation','northoutside')

% find normal and tangent components to the rod for visualization purposes
VelNorm_x =  (xBd.*sin(theta)).*sin(theta) + (yBd.*cos(theta)).*sin(theta);
VelNorm_y =  (xBd.*sin(theta)).*cos(theta) + (yBd.*cos(theta)).*cos(theta);
VelTang_x =  (xBd.*cos(theta)).*cos(theta) - (yBd.*sin(theta)).*cos(theta);
VelTang_y = -(xBd.*cos(theta)).*sin(theta) + (yBd.*sin(theta)).*sin(theta);

% find normal and tangent components to the rod for visualization purposes
AccNorm_x =  (xBdd.*sin(theta)).*sin(theta) + (yBdd.*cos(theta)).*sin(theta);
AccNorm_y =  (xBdd.*sin(theta)).*cos(theta) + (yBdd.*cos(theta)).*cos(theta);
AccTang_x =  (xBdd.*cos(theta)).*cos(theta) - (yBdd.*sin(theta)).*cos(theta);
AccTang_y = -(xBdd.*cos(theta)).*sin(theta) + (yBdd.*sin(theta)).*sin(theta);

x_center = xC;
y_center = yC*ones(length(theta),1);
x_tip = xB + 2*R;
y_tip = yB;

Slope = yBd./xBd; % slope of tangent to the trajectory

% x coordinates for tangent plot
for ii = 1:length(Slope)
    if abs(Slope(ii)) > 10
        x_tangent(1,ii) = x_tip(ii)-0.02; 
        x_tangent(2,ii) = x_tip(ii)+0.02;
    else
        x_tangent(1,ii) = x_tip(ii)-0.3; 
        x_tangent(2,ii) = x_tip(ii)+0.3;
    end
end

% compute y coordinates of the tangent 
y_tangent = [Slope.*(x_tangent(1,:)-x_tip) + y_tip; ...
             Slope.*(x_tangent(2,:)-x_tip) + y_tip];

%% Create animation (position of point B)

figure(100);
hold on;
axis equal;
xlim([0, max(x_center)+L+1]);
ylim([min(y_center)-L-1, max(y_center)+L+1]);
grid on;
title('Position Vectors');
yline(0,'k')
xlabel('$x \ [m]$')
ylabel('$y \ [m]$')

% Initialize objects
disk = viscircles([x_center(1), y_center(1)], R, 'Color', 'b'); % Circle outline
rod = plot([x_center(1), x_tip(1)], [y_center(1), y_tip(1)], 'b', 'LineWidth', 2); % Rod
pivot = plot(x_center(1), y_center(1), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Circle center
AO = quiver(0,0,0,R,LineWidth=1.5,AutoScaleFactor=1,Color='g');
CA = quiver(0,R,x_center(1),0,LineWidth=1.5,AutoScaleFactor=1,Color='g');
BC = quiver(x_center(1),y_center(1),x_tip(1)-x_center(1),y_tip(1)-y_center(1),LineWidth=1.5,AutoScaleFactor=1,Color='g');
BO = quiver(0,0,x_tip(1),y_tip(1),LineWidth=1.5,AutoScaleFactor=1,Color='m');

% Animation loop
for i = 1:length(theta)
    % Update disk position
    delete(disk); % Remove previous circle
    disk = viscircles([x_center(i), y_center(i)], R, 'Color', 'b'); % Redraw circle

    % Update rod position
    set(rod, 'XData', [x_center(i), x_tip(i)], 'YData', [y_center(i), y_tip(i)]);

    % Update center marker
    set(pivot, 'XData', x_center(i), 'YData', y_center(i));

    % Update arrows
    set(CA, 'XData', 0, 'YData', R, ...
               'UData', x_center(i), 'VData', 0);

    set(BC, 'XData', x_center(i), 'YData', y_center(i), ...
               'UData', x_tip(i)-x_center(i), 'VData', y_tip(i)-y_center(i));

    set(BO, 'XData', 0, 'YData', 0, ...
               'UData', x_tip(i), 'VData', y_tip(i));

    plot(x_tip(i),y_tip(i),'r.')

    % Update the plot
    drawnow;
    pause(0.01);

end

%% Create animation (velocity of point B)

figure(200);
hold on;
axis equal;
xlim([0, max(x_center)+L+1]);
ylim([min(y_center)-L-1, max(y_center)+L+1]);
grid on;
title('Velocity Vectors');
yline(0,'k')
xlabel('$x \ [m]$')
ylabel('$y \ [m]$')

disk = viscircles([x_center(1), y_center(1)], R, 'Color', 'b');
rod = plot([x_center(1), x_tip(1)], [y_center(1), y_tip(1)], 'r', 'LineWidth', 2);
pivot = plot(x_center(1), y_center(1), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
VelNorm_Arrow = quiver(x_tip(1),y_tip(1),VelNorm_x(1),VelNorm_y(1),LineWidth=1.5,AutoScaleFactor=0.1,Color='g');
VelTang_Arrow = quiver(x_tip(1),y_tip(1),VelTang_x(1),VelTang_y(1),LineWidth=1.5,AutoScaleFactor=0.1,Color='g');
VelTot_Arrow = quiver(x_tip(1),y_tip(1),xBd(1),yBd(1),LineWidth=1.5,AutoScaleFactor=0.1,Color='m');

for i = 1:length(omega)

    delete(disk);
    disk = viscircles([x_center(i), y_center(i)], R, 'Color', 'b');
    set(rod, 'XData', [x_center(i), x_tip(i)], 'YData', [y_center(i), y_tip(i)]);

    set(pivot, 'XData', x_center(i), 'YData', y_center(i));

    set(VelNorm_Arrow, 'XData', x_tip(i), 'YData', y_tip(i), ...
               'UData', VelNorm_x(i), 'VData', VelNorm_y(i));
    set(VelTang_Arrow, 'XData', x_tip(i), 'YData', y_tip(i), ...
               'UData', VelTang_x(i), 'VData', VelTang_y(i));   
    set(VelTot_Arrow, 'XData', x_tip(i), 'YData', y_tip(i), ...
               'UData', xBd(i), 'VData', yBd(i));  
    plot(x_tip(i),y_tip(i),'r.')
    drawnow

    if i==71 || i==80 || i==91
        plot([x_tangent(1,i) x_tangent(2,i)],[y_tangent(1,i) y_tangent(2,i)],'k--',LineWidth=1.5)
        pause(10);
    end

    pause(0.01);

end

%% Create animation (acceleration of point B)

figure(300);
hold on;
axis equal;
xlim([0, max(x_center)+L+1]);
ylim([min(y_center)-L-1, max(y_center)+L+1]);
grid on;
title('Acceleration Vectors');
yline(0,'k')
xlabel('$x \ [m]$')
ylabel('$y \ [m]$')

disk = viscircles([x_center(1), y_center(1)], R, 'Color', 'b');
rod = plot([x_center(1), x_tip(1)], [y_center(1), y_tip(1)], 'r', 'LineWidth', 2);
pivot = plot(x_center(1), y_center(1), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
AccNorm_Arrow = quiver(x_tip(1),y_tip(1),AccNorm_x(1),AccNorm_y(1),AutoScaleFactor=0.01,LineWidth=1.5,Color='g');
AccTang_Arrow = quiver(x_tip(1),y_tip(1),AccTang_x(1),AccTang_y(1),AutoScaleFactor=0.01,LineWidth=1.5,Color='g');
AccTot_Arrow = quiver(x_tip(1),y_tip(1),xBdd(1),yBdd(1),AutoScaleFactor=0.01,LineWidth=1.5,Color='m');
for i = 1:length(omega)

    delete(disk);
    disk = viscircles([x_center(i), y_center(i)], R, 'Color', 'b');    
    set(rod, 'XData', [x_center(i), x_tip(i)], 'YData', [y_center(i), y_tip(i)]);
    
    set(pivot, 'XData', x_center(i), 'YData', y_center(i));
    set(AccNorm_Arrow, 'XData', x_tip(i), 'YData', y_tip(i), ...
               'UData', AccNorm_x(i), 'VData', AccNorm_y(i));
    set(AccTang_Arrow, 'XData', x_tip(i), 'YData', y_tip(i), ...
               'UData', AccTang_x(i), 'VData', AccTang_y(i));   
    set(AccTot_Arrow, 'XData', x_tip(i), 'YData', y_tip(i), ...
               'UData', xBdd(i), 'VData', yBdd(i));   
    drawnow;
    pause(0.01);

end

%% Create animation (velocity of center of the disk)

figure(400);
hold on;
axis equal;
xlim([0, max(x_center)+L+1]);
ylim([min(y_center)-L-1, max(y_center)+L+1]);
grid on;
title('Velocity Vectors - Center of the disk');
yline(0,'k')
xlabel('$x \ [m]$')
ylabel('$y \ [m]$')

disk = viscircles([x_center(1), y_center(1)], R, 'Color', 'b');
rod = plot([x_center(1), x_tip(1)], [y_center(1), y_tip(1)], 'r', 'LineWidth', 2);
pivot = plot(x_center(1), y_center(1), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
VelTotC_Arrow = quiver(x_center(1),y_center(1),xCd(1),0,LineWidth=1.5,AutoScaleFactor=0.1,Color='m');
for i = 1:length(omega)

    delete(disk);
    disk = viscircles([x_center(i), y_center(i)], R, 'Color', 'b');
    set(rod, 'XData', [x_center(i), x_tip(i)], 'YData', [y_center(i), y_tip(i)]);
    
    set(pivot, 'XData', x_center(i), 'YData', y_center(i));
  
    set(VelTotC_Arrow, 'XData', x_center(i), 'YData', y_center(i), ...
               'UData', xCd(i), 'VData', 0);  
    drawnow
    pause(0.01);

end

%% Create animation (acceleration of center of the disk)

figure(500);
hold on;
axis equal;
xlim([0, max(x_center)+L+1]);
ylim([min(y_center)-L-1, max(y_center)+L+1]);
grid on;
title('Acceleration Vectors - Center of the disk');
yline(0,'k')
xlabel('$x \ [m]$')
ylabel('$y \ [m]$')

disk = viscircles([x_center(1), y_center(1)], R, 'Color', 'b');
rod = plot([x_center(1), x_tip(1)], [y_center(1), y_tip(1)], 'r', 'LineWidth', 2);
pivot = plot(x_center(1), y_center(1), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
AccTotC_Arrow = quiver(x_center(1),y_center(1),xCdd(1),0,LineWidth=1.5,AutoScaleFactor=0.1,Color='m');
for i = 1:length(omega)

    delete(disk);
    disk = viscircles([x_center(i), y_center(i)], R, 'Color', 'b');
    set(rod, 'XData', [x_center(i), x_tip(i)], 'YData', [y_center(i), y_tip(i)]);
    
    set(pivot, 'XData', x_center(i), 'YData', y_center(i));
  
    set(AccTotC_Arrow, 'XData', x_center(i), 'YData', y_center(i), ...
               'UData', xCd(i), 'VData', 0);  
    drawnow
    pause(0.01);

end
