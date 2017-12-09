% This code will plot all of our data. We will go through each plot to
% determine whether or not the data is good

%Load the data
addpath('C:\Users\kelly_000\OneDrive\Documents\Olin 2017\NeuroTech\NeuroTech-Project-2\data');
data_folder = dir('data')
data_folder.name
parse(data_folder(7).name)
%[data_norm, stimulus_type, match_type, event_times] = [0,0,0,0]
[data_norm, stimulus_type, match_type, event_times] = parse(data_folder(4).name);
for i=5:7
    [data_norm_temp, stimulus_type_temp, match_type_temp, event_times_temp] = parse(data_folder(i).name);
    data_norm = vertcat(data_norm, data_norm_temp);
    stimulus_type = vertcat(stimulus_type,stimulus_type_temp);
    match_type = vertcat(match_type,match_type_temp);
    event_times = vertcat(event_times,event_times_temp);
    %[data_norm, stimulus_type, match_type, event_times; data_norm_temp, stimulus_type_temp, match_type_temp, event_times_temp]
end

%% plotting

%good_data = zeros(length(event_times),1);

for i=120:length(event_times)
    figure;
    plot(event_times{i}, data_norm{i}(:,[1,2,3,4]));
    title(['Trial' num2str(i)]);
    legend('1','2,','3','4')
    %ylim([-40,40]);
    w = waitforbuttonpress;
    if w == 0
        good_data(i)=0;
    else
        good_data(i)=1;
    end
    close
end


%%

good_trials = zeros(71, 250, 4); %(number of good trials, number of time points, # Channels)
condition = zeros(71,1);
j = 1; 
for i=1:length(good_data)
    if good_data(i) == 1
        good_trials(j,:,:) = data_norm{i}(1:250,:);
        condition(j) = stimulus_type(i);
        j = j+1;
    end
end

plot(good_trials(:,:,4)') %plot each channely
C = mean(good_trials(:,:,4));
plot(0:2:498, C)

%%
D = mean(good_trials(:,:,3));
E = mean(good_trials(:,:,2));
F = mean(good_trials(:,:,1));

plot(0:2:498, D)
hold on
%plot(0:2:498, E)
plot(0:2:498, F)
plot(0:2:498, C)
legend('3', '2', '1', '4')