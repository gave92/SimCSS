clearvars
close all
clc

% Show text?
show_text = true;

if show_text
    f = figure('Units','norm','Position',[0.05,0.2,0.9,0.6]);
else
    f = figure;
end
f.Color = 'white';

% Create axes for surface
if show_text
    ax = axes('Position',[0.22 0 1 1]);
else
    ax = axes('Position',[0 0 1 1]);
end
ax.XLim = [1 201];
ax.YLim = [1 201];
ax.ZLim = [-53.4 160];
hold on
axis off
view(3)

% Create red surface
L = 160*membrane(1,100);
s = surface(L);
s.EdgeColor = 'none';

% Set camera position
ax.CameraPosition = [-145.5 -229.7 283.6];
ax.CameraTarget = [77.4 60.2 63.9];
ax.CameraUpVector = [0 0 1];
ax.CameraViewAngle = 36.7;
ax.DataAspectRatio = [1 1 .9];

% Set colormap
length = 100;
red = [1, 0, 0];
pink = [255, 192, 203]/255;
colors_p = [linspace(red(1),pink(1),length)', linspace(red(2),pink(2),length)', linspace(red(3),pink(3),length)'];
colormap(colors_p)

% Create second axes behind the other
if show_text
    ax = axes('Position',[0.22 0 1 1]);
else
    ax = axes('Position',[0 0 1 1]);
end
axis square
ax.XLim = [0 1];
ax.YLim = [0 1];
uistack(ax,'bottom');
hold on
axis off

% Plot rectangle
x = [0 0.5 0.5 0]+0.05;
y = [0 0 0.5 0.5]+0.4;
z = [0 0 0 0];
ct = [[1 112 186]/255;[1 112 186]/255;[41 169 223]/255;[1 112 186]/255];
csq(1,1:4,1:3) = ct;
sq = patch(x,y,z,csq);
sq.EdgeColor = 'none';

txt = text(0.1,0.8,'CSS');
set(txt,'FontName','Segoe UI Symbol')
set(txt,'FontSize',48)
% set(txt,'Color',[207 207 207]/255)
set(txt,'Color',[255 255 255]/255)

% Add text
if show_text
    ax = axes('Position',[0 0 1 1]);
    hold on
    axis off
    txt = text(0.05,0.5,'SimCSS');
    set(txt,'FontName','Segoe UI Symbol')
    set(txt,'FontSize',140)
    set(txt,'Color',[89 89 89]/255)
    
    % Resize text with figure!!
    orig_sz = f.Position;
    f.ResizeFcn = @(src,ev) set(txt,'FontSize',src.Position(3)/orig_sz(3)*140);
end

% Export to PNG
if show_text
    export_fig(f,'simcss-icon.png','-m4','-transparent')
else
    export_fig(f,'simcss-logo.png','-m4','-transparent')
end

