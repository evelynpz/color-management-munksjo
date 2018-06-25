%% -------------------------------------------------------------------
% University Jean Monnet
% Introduction to specialization fields and industrial cases
% Project: Munksjo
% Partners: Alireza Rezaei, Evelyn Paiz, Nadile Nunes & Yu-Jung Chen.
% Instructors: Alain Tremeau
% Description: Function that receives the information to be predicted using
% a specific method.
% Parameters: 
%   - test_data: an array that contains all the corresponding information.
%   - method: the method to use for the prediction.
%% -------------------------------------------------------------------
function Result = predict_rejection(test_data, method)
   % Loads the models for prediction created previously with all the data.
   load('models');
   % Predicts
   switch method
    case 'Bayes'
        Result = predict(FIT{1},test_data)
    case 'AdaBoostM1'
        Result = predict(FIT{2},test_data)
    case 'Bag'
        Result = predict(FIT{3},test_data)
    otherwise
        error('wrong type of prediction method')
   end
   filename = 'result.txt';
   fid=fopen(filename,'w');
   fprintf(fid, Result);
   fclose(fid);
end