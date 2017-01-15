%% TDCV exercise on neural networks

function net = setup_autoencoder(n_hidden, n_out)
% Function to setup the autoencoder network
% Returns the network 

%% Network parameters
decay = 3e-3; % Decay for L2 regularizer
beta = 3; % Sparsity term weight for KL term
avg_sparsity = 0.1; % Targeted average sparsity

%% Setup the network
net = neural_network();

%------------------------ Compression ------------------------------%
% Add fully connected layer with n_hidden neurons
net.layers{end+1} = fc_layer(n_hidden, [decay 0]);

% Add sigmoid layer
net.layers{end+1} = sigmoid_layer(avg_sparsity, beta, 1);

%----------------------- Decompression -----------------------------%
% Add fully connected layer with n_out neurons
net.layers{end+1} = fc_layer(n_out, [decay 0]);

% % Add sigmoid layer
net.layers{end+1} = sigmoid_layer();

end