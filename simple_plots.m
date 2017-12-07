% set source ...
src = data_norm;

%% Gather + Visualizae Some Statistics
n = length(src);
mxs = cell2mat(cellfun(@max, src, 'UniformOutput', false));
mns = cell2mat(cellfun(@min, src, 'UniformOutput', false));
avgs = cell2mat(cellfun(@mean, src, 'UniformOutput', false));
figure;
hold on;
plot(mxs);  
plot(mns);
plot(avgs);
hold off;

% boxplot on channel 1
figure;
c1 = cellfun(@(x)x(:,1), src, 'UniformOutput', false);
col=@(x)reshape(x,numel(x),1);
boxplot2=@(C,varargin)boxplot(cell2mat(cellfun(col,col(C),'uni',0)),cell2mat(arrayfun(@(I)I*ones(numel(C{I}),1),col(1:numel(C)),'uni',0)),varargin{:});
boxplot2(c1);

% attempt anova ...
idx = find((stimulus_type == 1) & (match_type == 1));
all_src = vertcat(src{idx});
groups = [];
for j = 1:length(idx)
    i=idx(j);
    groups = vertcat(groups, ones(length(src{i}),1)*i);
end
p = anova1(all_src(:,1), groups);

%% Instance Analysis

figure;
hold on;

k = 37; % instance to analyze

plot(event_times{k}, src{k});
xlabel('Time(ms)');
ylabel('Amplitude(?)');

%smt = smooth(src{k}(:,1));
%plot(event_times{k}, smt);

% 95% conf. interval over all data
all_src = vertcat(src{:});
stds = std(all_src,0,1);
ms = mean(all_src,1);

upper_bound = ms + 2*stds; % +95
lower_bound = ms - 2*stds;

upper_bound = upper_bound(1);
lower_bound = lower_bound(1);

mx = event_times{i}(end);
h = fill([0,mx,mx,0],[lower_bound,lower_bound,upper_bound,upper_bound], 'g');
set(h,'facealpha',.125)

title('Sample Response');
legend('CH1', 'CH2', 'CH3', 'CH4', '95%');