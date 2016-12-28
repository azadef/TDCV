%% TDCV exercise on neural networks
%
% Script to train the classifier
global net;

%% Setup the network
% Specify the input size of the network
% width x height x channels x batch size
input_size = [28 28 1 10000];
num_filters = 100;
num_classes = 10;
net = setup_classifier(num_filters, num_classes);

%% Load pretrained network
net = net.initialize(input_size);
net = net.load('trained_autoencoder.h5', [1]);

%% Load trainings data
% Download dataset from http://yann.lecun.com/exdb/mnist/
data = loadMNISTImages('train-images.idx3-ubyte');
label = loadMNISTLabels('train-labels.idx1-ubyte');

% Shuffle the data and labels
permutation = randperm(size(data,4));
data = data(:,:,:,permutation);
label = label(:,permutation);

%% Setup the solver
solv = solver(net,'log');

%% Train the network
solv = solv.solve(data, label, 1000);

%% Save network
solv.network.save(sprintf('trained_classifier.h5'));
