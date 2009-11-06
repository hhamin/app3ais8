% DSPIRALE Distinction entre deux spiralesfunction nn = nn_app3()    close all;    clear all;    clc;    %    ==========================================================    %    SPIRALE            %    ==========================================================    %    INITFF   - Inititializes feed-forward networks up to 3 layers.    %    TRAINBPX - Trains a feed-forward network with faster backpropagation.    %    SIMUFF    - Simulates feed-forward networks up to 3 layers.    %    NONLINEAR SYSTEM IDENTIFICATION:    % Input    Fe = 2000;    f = 20;    falls = [...        '3ITB1A'; ...        '3ITB1B'; ...        '3ITB1C'; ...        '3ATF2A'; ...         '3ATF2B'; ...        '3ATF2C'; ...        '3SVF3A'; ...        '3SVF3B'; ...        '3SVF3C';];    non_falls = [...        '3ITB1D'; ...        '3ATF2D'; ...        '3NNC4A'; ...        '3NNC4B'; ...        '3NNC4C'; ...        '3NNC4D'];    for i = 1 : length(falls)        file = falls(i, :);        for j = 1:5            ext = sprintf('00%d', j);            data = load_file('Sujet_3', file, ext);            % Downsample the signals from channels 2 to 6            for k=2:6%                 length(data(:,k))                % Chopping data to the 8000th sample because it is the                % smallest sample size                plot_data_fall(k-1, :) = downsample_signal(data(1:8000,k), f, Fe);            end        end    end    plot_data_fall        % Plot non falls    for i = 1 : length(non_falls)        file = non_falls(i, :);        for j = 1:5            ext = sprintf('00%d', j);            data = load_file('Sujet_3', file, ext);            % Downsample the signals from channels 2 to 6            for k=2:6%                 length(data(:,k))                plot_data_non_fall(k-1, :) = downsample_signal(data(1:8000,k), f, Fe);            end        end    end    % % Training vectors    % [R,Q]=size(spirales);  % Structure d'entree et de sortie du RNA    % [S2,Q]=size(targets);    %     % %    DEFINING THE NETWORK    % %    ====================    %     % %    The spiral network will have x     % %    neurons in its hidden layer.    %     % S1 = 500;        % Nombre d'unites cachees    % net =newff(minmax(spirales),[S1 S2],{'logsig' 'logsig'},'traingdm');    % net.LW{2,1} = net.LW{2,1}*0.01;    % net.b{2} = net.b{2}*0.01;    %     % %    TRAINING THE NETWORK WITHOUT NOISE    % %    ==================================    %     % net.performFcn = 'sse';         % Sum-Squared Error performance function    % net.trainParam.goal = 0.1;      % Sum-squared error goal.    % net.trainParam.show = 1000;     % Frequency of progress displays (in epochs).    % net.trainParam.epochs = 10000;  % Maximum number of epochs to train.    % net.trainParam.mc = 0.9;        % Momentum constant.    % net.trainParam.lr=0.15;         % Learning rate    %     % %    Training begins...please wait...    %     % P = spirales;    % T = targets;    %     % [net,tr] = train(net, P, T);    %     % %    ...and finally finishes.    %     % % PERFORM THE TEST    % A = sim(net,P);    % AA = hardlim(A-0.5);            % Seuil de decision entre les deux courbes    % errors1 = sum(abs(AA-T));    %     % errors1   % Nombre de vecteurs non apprisfunction data = load_file(subject, file, fileNumber)    path = sprintf('%s/%s/%s_%s.dat', subject, file, file, fileNumber);    fid = fopen(path,'r','b');      data = fread(fid,[6,inf],'single')';   % Lecture du fichier binaire    fclose(fid);        function data = downsample_signal(x, f, Fe)    data_size = size(x, 1);    x_fft = fft(x, data_size);    data = real(ifft(x_fft(1:2*f), round(data_size/Fe*f)));function data = window_average(x, window_size)    data = x;    wsize = window_size / 2;    for i = 1 : wsize        data(i) = mean(x(1):x(i));    end    for i = wsize+1 : length(x) - wsize        data(i) = mean(x(i - wsize: i + wsize));    end    for i = length(x) - wsize + 1 : length(x)        data(i) = mean(x(i : length(x)));    end