function [data_norm, stimulus_type, match_type, event_times] = parse(filename)
    
    %% Usage :
    % [data_norm, stimulus_type, match_type, event_times] = parse('data/stroop-subj1-run2.mat');
    
    % Plot ...
    % plot(event_times{1}, data_norm{1});
    % xlabel('Time(ms)');
    % ylabel('Amplitude(?)');
    
    % Group ...
    % match = data_norm{match_type == 1};
    % unmatch = data_norm{match_type == 0};
    % text_color = data_norm(stimulus_type == 1);
    % audio_text = data_norm(stimulus_type == 2);
    % color_audio = data_norm(stimulus_type == 3);
  
    %% Parse Data
    raw_data = load(filename);
    raw_data = raw_data.mytraindata;
    data = raw_data.data(2:5,:); %data 1,6 are invalid

    event = struct2table(raw_data.event);

    event_idx = floor(event.latency);
    %event_time = raw_data.times(event_idx);
    event_type = str2num(cell2mat(event.type));

    start = find(event_type == 100, 1, 'first');

    event_type = event_type(start+1:end);
    event_idx = event_idx(start+1:end);

    event_type = reshape(event_type, 3, [])';
    event_idx = reshape(event_idx, 3, [])';
    n = length(event_type);
    
    stimulus_type = floor(mod(event_type(:,2), 100)/10);
    match_type = mod(event_type(:,2), 10);
    
    % Get timestamps ...
    event_times = cell(n,1);
    for i=1:n
        event_times{i} = raw_data.times(event_idx(i,2) : event_idx(i,3))';
        % reset reference offset to 0
        event_times{i} = event_times{i} - min(event_times{i});
    end
    
    %% Normalize Data
    data_norm = cell(n,1);
    for i=1:n
        % compute DC offset ...
        data_0 = data(:, event_idx(i,1) : event_idx(i,2));
        
        % subtract & format data
        data_norm{i} = data(:, event_idx(i,2) : event_idx(i,3)) - mean(data_0, 2);
        data_norm{i} = data_norm{i}';
    end
    
    %% Plot Data for validation
    %figure;
    %hold on;
    %for i=1:n
    %   plot(data_norm{i}(:,1));
    %end
end