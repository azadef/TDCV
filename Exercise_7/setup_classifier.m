% Script to setup the classifier
function net = setup_classifier(n_hidden, n_out)
%% Training parameters
lr = 0.001; % Learning rate
M = 0.9; % Momentum
decay = 0.0005; % Decay

%% Setup the network
net = neural_network();

%----------------------- Feature extraction -----------------------------%
% Add fully connected layer with 196 neurons
net.layers{end+1} = fc_layer(n_hidden, [lr lr], [M M], [decay 0], 1);

% Add sigmoid layer
net.layers{end+1} = sigmoid_layer(0.1, 3, 1);

%--------------------------- Classifier ---------------------------------%
% Add fully connected layer with 10 neurons
net.layers{end+1} = fc_layer(n_out, [lr lr], [M M], [decay 0], 1);

net.layers{end+1} = softmax_layer();
end