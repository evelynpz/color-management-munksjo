%% -------------------------------------------------------------------
% University Jean Monnet
% Introduction to specialization fields and industrial cases
% Project: Munksjo
% Partners: Alireza Rezaei, Evelyn Paiz, Nadile Nunes & Yu-Jung Chen.
% Instructors: Alain Tremeau
% Description: Function that receives an excell docs and saves the
% classification methdos to be used as the future predictions.
% Parameters: 
%   - data_name: name of the excel file.
%   - per_training: number of sample to be use as training (from 0 to 1).
%% -------------------------------------------------------------------
function Accuracy = load_data(data_name, per_training, fileID)
    % -------------------------------------
    % Methods definition
    % -------------------------------------
    methods = {'Bayes', 'AdaBoostM1', 'Bag'};

    % -------------------------------------
    % Data processing
    % -------------------------------------
    data = readtable(data_name);
    % Start color computation to identify Delta E 97
    data.White_DeltaE97 = sqrt((data.SpectroL_WhiteMaster - data.SpectroL_WhiteSample).^2 + ....
        (data.SpectroA_WhiteMaster - data.SpectroA_WhiteSample).^2 + ...
        (data.SpectroB_WhiteMaster - data.SpectroB_WhiteSample).^2);
    data.Kraft_DeltaE97 = sqrt((data.SpectroL_KraftMaster - data.SpectroL_KraftSample).^2 + ....
        (data.SpectroA_KraftMaster - data.SpectroA_KraftSample).^2 + ...
        (data.SpectroB_KraftMaster - data.SpectroB_KraftSample).^2);
    advanced = data(:,4:end);
    % Obtains size of the training sample
    smp_size = floor(per_training * height(advanced));
    % Set the seed to make your partition reproductible
    rng('default');
    rng(321);
    training_ind = randi([1 height(advanced)], 1, smp_size);
    % Obtains the data use for training and testing
    train = advanced(training_ind,:);
    test = setdiff(advanced,train);
    % Create arrays for the data of training
    X_training = table2array(train(:,2:end));
    Y_training = train.RollRejected;
    % Creates arrays for the data to test
    X_test = table2array(test(:,2:end));
    
    % -------------------------------------
    % Naive Bayes
    % -------------------------------------
    % Naive Bayes - trains
    FIT{1} = fitNaiveBayes(X_training,Y_training);
    
    % -------------------------------------
    % Ensemble method
    % -------------------------------------
    for i=2:size(methods,2)
        FIT{i} = fitensemble(X_training, Y_training, methods{i}, ...
            200, 'Tree', 'Type', 'Classification');
    end
    
    % -------------------------------------
    % Accuracy for each type
    % -------------------------------------
    % Accuracy
    Comp = test.RollRejected;
    % For each method, the accuracy is obtained.
    for i=1:size(FIT,2)
        % Predicts
        Value = predict(FIT{i},X_test);
        % Total accuracy
        F = strcmp(Value,Comp);
        A{i} = (sum(F)/height(test))*100;
    end
    %Accuracy = table(methods', A');
    %Accuracy.Properties.VariableNames = {'Method' 'Accuracy'};
    fprintf(fileID,'%d,%d,%d\r\n', A{1}, A{2}, A{3});
    % Saves the results 
    % filename = 'accuracy.txt';
    % writetable(Accuracy, filename);
    % save('models')
end