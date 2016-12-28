%% TDCV exercise on neural networks
%
% Script to train the autoencoder
global net;

%% Setup the network
% Specify the input size of the network
% width x height x channels x batch size
input_size = [28 28 1 60000];
num_filters = 100;
number_outputs = prod(input_size(1:3));
net = setup_autoencoder(num_filters, number_outputs);

%% Randomly initialize the networks parameters
net = net.initialize(input_size);

%% Load trainings data
% Download dataset from http://yann.lecun.com/exdb/mnist/
data = loadMNISTImages('train-images.idx3-ubyte');

% Shuffle the data
permutation = randperm(size(data,4));
data = data(:,:,:,permutation);

%% Setup the solver
% For the autoencoder we use the L2 loss
solv = solver(net,'L2');

%% Train the network
% Here we use the L-BFGS solver integrated in Matlab
% The optimizer expects all the variables and their derivatives as two
% vectors so the helper functions get_theta and set_theta of the
% neural_network class convert the network parameters for us
num_iterations = 50;
options = optimoptions(@fmincon,'Display','iter-detailed','GradObj','on','Hessian','lbfgs','MaxIter',num_iterations,'OutputFcn', {@plot_loss, @visualize_features});
theta = solv.network.get_theta();
[opttheta, cost] = fmincon( @(p) solv.opt_func(p, data, data, solv), theta, [],[],[],[],[],[],[],options);
solv.network = solv.network.set_theta(opttheta);

%% Visualize features
visualize_features(opttheta);

%% Save network
solv.network.save(sprintf('trained_autoencoder.h5'));
