% Script to train the neural network

%% Setup the network
% Specify the input size of the network
% width x height x channels x batch size
input_size = [2 1 1 2];
num_filters = 2;
number_outputs = prod(input_size(1:3));
net = setup_autoencoder(num_filters, number_outputs);

%% Randomly initialize the networks parameters
net = net.initialize(input_size);

%% Random input
data = rand(2,1,1,2);

%% Setup the solver
solv = solver(net,'L2');

%% Gradient checking
theta = solv.network.get_theta();
numgrad = computeNumericalGradient(@(p) solv.opt_func(p, data, data, solv), theta);
[~,grad] = solv.opt_func(theta, data, data, solv);
delta = numgrad-grad;
diff = norm(delta)/norm(numgrad+grad);
disp(diff); % Should be smaller than 1e-9
