%% TDCV exercise on neural networks
%
% Script to test the neural network

%% Parameters
batch_size = 4;
step_by_step = 1;

%% Setup the network
% Specify the input size of the network
% width x height x channels x batch size
input_size = [28 28 1 batch_size];
num_filters = 100;
num_classes = 10;
net = setup_classifier(num_filters, num_classes);

%% Initialize the network
net = net.initialize(input_size);

%% Load trained model
net = net.load('trained_classifier.h5');

%% Load training data
% Download dataset from http://yann.lecun.com/exdb/mnist/
data = loadMNISTImages('t10k-images-idx3-ubyte');
label = loadMNISTLabels('t10k-labels-idx1-ubyte');

% Store the predictions
predictions = zeros(size(label));

% Go over the dataset
for i=1:ceil(size(data,4)/batch_size)
    fprintf(1, 'Testing batch %d of %d\n', i, ceil(size(data,4)/batch_size));
    
    % Predict batch
    [net, scores] = net.forward_all(data(:,:,:,(i-1)*batch_size+1:i*batch_size));
    
    % Get class with highest score
    [p, maxlabel] = max(scores, [], 3);
    
    % Store
    predictions((i-1)*batch_size+1:i*batch_size) =  maxlabel(:);
    
    % Plot
    if step_by_step
        cnt = 1;
        for j=1:batch_size
            subplot(batch_size,2,cnt);
            imshow(data(:,:,:,(i-1)*batch_size+j));
            cnt = cnt + 1;
            subplot(batch_size,2,cnt);
            bar(0:size(scores,3)-1,reshape(scores(:,:,:,j),[size(scores,3),1]));
            cnt = cnt + 1;
        end
        input('');
    end
end

%% Compute confusion matrix
confusion_matrix = zeros(num_classes, num_classes);
%%% START YOUR CODE HERE %%%


















%%% END YOUR CODE HERE %%%

% Print confusion matrix
for i=1:num_classes
    fprintf(1,'%02.2f  ', confusion_matrix(i,:));
    fprintf(1,'\n');
end

%% Compute accuracy
%%% START YOUR CODE HERE %%%
% accuracy = ...
%%% END YOUR CODE HERE %%%
disp(accuracy);