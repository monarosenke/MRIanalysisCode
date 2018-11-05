function BarPlotIndivDots( values, x_labels,tilt, y_label,ylim, lettersize,t,varargin )
%create a bar graph with as many bars as entries in Values
%   x_Labels = cells with names for x-axis
%   tilt = true or false ( 1 or 0) if x-axis should be tilted 90 degrees
%   values = (double) columns for each entry that need to be plotted, number of
%   columns defines how many bars, rows are single values within each bar
%   y_label = string
%   lettersize integer defining the size of x axis labels
%   t = title, string
% can enter: chance level mean and std and transparency for plotting (see
% line 45 and 46)
%
% MR Apr 2018

nrval = size(values,2);
x = [1:nrval];

f = figure('color',[1 1 1],'position',3.0000 1.0070 0);
h = bar(nanmean(values,1),0.5);
set(h(1),'FaceColor',[.8,.8,.8])
hold on



% modified jet colors
mycolors = [         0         0    0;
    0         0    1.0000;
    0    128/255    128/255;
    250/255    190/255    190/255;
    0/255    255/255    0/255;
    0    1.0000    1.0000;
    128/255    128/255    128/255;
    138/255    0.0000    0.000;
    244/255    50/255    230/255;
    1.0000    1.0000         0;
    1.0000    0.7500         0;
    145/255    30/255        180/255;
    1.0000    0.2500         0;
    1.0000         0         0];

for ind = 1:size(values,1)   
    plot([repmat(1:size(values,2),1,1)],values(ind,:),'o','LineWidth',2,'Color',mycolors(ind,:),'MarkerFaceColor',mycolors(ind,:))   
end

ax = gca;
ax.YLim = ylim;
ax.XTickLabel = x_labels;
ax.FontSize = lettersize;
if(tilt)
    ax.XTickLabelRotation=45;
end
ax.XTick = x;
ylabel(y_label)
tr = title(t)
set(tr, 'Interpreter', 'none')
if ~isempty(varargin)
    chancelevel = varargin{1};
    chancestd = varargin{2};
    transparency = varargin{3};
    hold on
    y2 = repmat(chancelevel,nrval+2,1);
    SE = repmat(chancestd,nrval+2,1); %se
    xi = [0:nrval+1]'
    f = fill([xi;flipud(xi)],[y2-SE;flipud(y2+SE)],[.7 0 0],'linestyle','none');
    line(xi,y2, 'LineWidth',1,'Color',[0.5 0 0])
    set(f, 'FaceAlpha', transparency);
    
    hold on
    y2 = repmat(abs(chancelevel),nrval+2,1);
    SE = repmat(chancestd,nrval+2,1); %se
    xi = [0:nrval+1]'
    f = fill([xi;flipud(xi)],[y2-SE;flipud(y2+SE)],[.7 0 0],'linestyle','none');
    line(xi,y2, 'LineWidth',1,'Color',[0.5 0 0])
    set(f, 'FaceAlpha', transparency);
end
box off;
end

