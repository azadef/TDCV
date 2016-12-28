%% TDCV exercise on neural networks

classdef sigmoid_layer < layer
    % Sigmoid layer class
    % Implements the sigmoid non-linearity together with a
    % sparsity term based on the Kullback-Leibler-Divergence
	properties
        % Sparsity factor
        beta;
        % Targeted average activation
        alpha;
        % Average activations
        A_avg;
        % Average momentum
        gamma;
	end
	methods
		% Constructor
		function obj = sigmoid_layer(alpha, beta, gamma)
			% Call layer constructor
			obj@layer('Sigmoid');
            if nargin > 0
                obj.alpha = alpha;
                obj.beta = beta;
                obj.gamma = gamma;
            else
                obj.alpha = 0;
                obj.beta = 0;
                obj.gamma = 0;
            end
        end
        
        % Initialize intern variables and compute output shape
        function [obj, y] = initialize(obj, x)
            % Initialize verage activations
            num_channels = x(3);
            obj.A_avg = double(zeros(num_channels,1));
            
            % Output shape is equal to the input shape
            y = x;
        end
		
		% Forward pass
		function [obj, y, L] = forward(obj, x)
            % Compute the average activation (A_avg), the loss (L) and the layers output (y)
            %%% START YOUR CODE HERE %%%
            % y = ...
            % obj.A_avg = ...
            % L = ...
            %%% END YOUR CODE HERE %%%
		end
		
		% Backward pass
		function [obj, dx] = backward(obj, dy, x)
            % Compute the gradients dx using dy,x and A_avg
            %%% START YOUR CODE HERE %%%
            % dx = ...
            %%% END YOUR CODE HERE %%%
        end
	end
end