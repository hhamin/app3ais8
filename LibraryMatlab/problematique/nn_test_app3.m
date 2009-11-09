% DSPIRALE Distinction entre deux spirales
function errors = nn_test_app3(net)
    % Input

    Fe = 2000;
    f = 20;
    
    fixed_sample_size = 8000;
    samples_per_channel = f / Fe * fixed_sample_size;
    num_constants = 2;

    S3_falls = [ ...
        '3ITB1A'; ...
        '3ITB1B'; ...
        '3ITB1C'; ...
        '3ATF2A'; ...
        '3ATF2B'; ...
        '3ATF2C'; ...
        '3SVF3A'; ...
        '3SVF3B'; ...
        '3SVF3C'; ...
        ];
    
    S5_falls = [ ...
        '5ITB1A'; ...
        '5ITB1B'; ...
        '5ITB1C'; ...
        '5ATF2A'; ...
        '5ATF2B'; ...
        '5ATF2C'; ...
        '5SVF3A'; ...
        '5SVF3B'; ...
        '5SVF3C'; ...
        ];

    S3_non_falls = [ ...
        '3ITB1D'; ...
        '3ATF2D'; ...
        '3NNC4A'; ...
        '3NNC4B'; ...
        '3NNC4C'; ...
        '3NNC4D'; ...
        ];
    
    S5_non_falls = [ ...
        '5ITB1D'; ...
        '5ATF2D'; ...
        '5NNC4A'; ...
        '5NNC4B'; ...
        '5NNC4C'; ...
        '5NNC4D'; ...
        ];
    
    data_falls = [];
    data_non_falls = [];
    
    for i = 1 : length(S3_falls)
        file = S3_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_3', file, ext);
            data_row = [];
            % Downsample the signals from channels 2 to 6
            for k=2:6
%                 length(data(:,k))
                % Chopping data to the 8000th sample because it is the
                % smallest sample size
%                middle_8000 = get_middle_samples(data(:, k), fixed_sample_size);
%                data_row(1+(k-2)*samples_per_channel:(k-1)*samples_per_channel) = downsample_signal(middle_8000, f, Fe);

                average_start = mean(data(1:500,k));
                average_end = mean(data(length(data)-500:length(data), k));
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S3_data_falls((i-1)*5+j, :) = [data_row 1 0];
        end
    end
  
    % Plot non falls
    for i = 1 : length(S3_non_falls)
        file = S3_non_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_3', file, ext);
            cory_data_row = [];
            % Downsample the signals from channels 2 to 6
            for k=2:6
                % middle_8000 = get_middle_samples(data(:, k), fixed_sample_size);
                % cory_data_row(1+(k-2)*samples_per_channel:(k-1)*samples_per_channel) = downsample_signal(middle_8000, f, Fe);
                
                average_start = mean(data(1:500,k));
                average_end = mean(data(length(data)-500:length(data), k));
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                cory_data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S3_data_non_falls((i-1)*5+j, :) = [cory_data_row 0 1];
        end
    end
    
    for i = 1 : length(S5_falls)
        file = S5_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_5', file, ext);
            data_row = [];
            % Downsample the signals from channels 2 to 6
            for k=2:6
%                 length(data(:,k))
                % Chopping data to the 8000th sample because it is the
                % smallest sample size
%                middle_8000 = get_middle_samples(data(:, k), fixed_sample_size);
%                data_row(1+(k-2)*samples_per_channel:(k-1)*samples_per_channel) = downsample_signal(middle_8000, f, Fe);

                average_start = mean(data(1:500,k));
                average_end = mean(data(length(data)-500:length(data), k));
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S5_data_falls((i-1)*5+j, :) = [data_row 1 0];
        end
    end
  
    % Plot non falls
    for i = 1 : length(S5_non_falls)
        file = S5_non_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_5', file, ext);
            cory_data_row = [];
            % Downsample the signals from channels 2 to 6
            for k=2:6
                % middle_8000 = get_middle_samples(data(:, k), fixed_sample_size);
                % cory_data_row(1+(k-2)*samples_per_channel:(k-1)*samples_per_channel) = downsample_signal(middle_8000, f, Fe);
                
                average_start = mean(data(1:500,k));
                average_end = mean(data(length(data)-500:length(data), k));
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                cory_data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S5_data_non_falls((i-1)*5+j, :) = [cory_data_row 0 1];
        end
    end

    testing_data = [S3_data_falls; S3_data_non_falls; S5_data_falls; S5_data_non_falls];
    
    testing_input = testing_data(:, 1:5*num_constants)';
    testing_output = testing_data(:, (5*num_constants)+1:(5*num_constants)+2)';
    [R, Q] = size(testing_input); % Structure d'entree et de sortie du RNA
    [S2, Q] = size(testing_output);
   
    % 
    % %    Training begins...please wait...
    % 
    P = testing_input;
    T = testing_output;
    size(P);
    size(T);

    % 
    % PERFORM THE TEST
    A = sim(net,P);
    for i = 1 : size(A, 2)
        if A(1,i) < A(2,i)
            AA(i) = 0;
        else
            AA(i) = 1;
        end
    end

    for i = 1 : size(T, 2)
        if T(1,i) < T(2,i)
            TT(i) = 0;
        else
            TT(i) = 1;
        end
    end
    errors = sum(abs(AA-TT));
    
    errors   % Nombre de vecteurs non appris

function data = load_file(subject, file, fileNumber)
    path = sprintf('%s/%s/%s_%s.dat', subject, file, file, fileNumber);
    fid = fopen(path,'r','b');  
    data = fread(fid,[6,inf],'single')';   % Lecture du fichier binaire
    fclose(fid);
        

function data = downsample_signal(x, f, Fe)
    data_size = size(x, 1);
    x_fft = fft(x, data_size);

    data = real(ifft(x_fft(1:2*f), round(data_size/Fe*f)));

function data = window_average(x, window_size)
    data = x;
    wsize = window_size / 2;
    for i = 1 : wsize
        data(i) = mean(x(1):x(i));
    end
    for i = wsize+1 : length(x) - wsize
        data(i) = mean(x(i - wsize: i + wsize));
    end
    for i = length(x) - wsize + 1 : length(x)
        data(i) = mean(x(i : length(x)));
    end

function data = get_middle_samples(input, amount)
    l = length(input);
    
    start_index = round(l/2 - amount/2) + 1;
    end_index = round(l/2 + amount/2);
    
    data = input(start_index: end_index);