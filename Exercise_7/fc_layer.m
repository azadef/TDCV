%% TDCV exercise on neural networks

classdef fc_layer < layer
    % Fully connected layer class
    % Holds the layers weights, biases, gradients and update values
    % Implements forward, backward and update function
	properties
		% Number of filters
		num_filters;
		% Weights
		W;
		% Biases
		b;
		% Weight gradients
		dW;
		% Bias gradients
		db;
		% Weight update
		uW;
		% Bias update
		ub;
        % Weight average
		aW;
		% Bias average
		ab;
        % Learning rate
        lr;
        % Momentum
        M;
        % Decay
        decay;
	end
	methods
		% Constructor
		function obj = fc_layer(num_filters, decay, lr, M)
			% Call layer constructor
			obj@layer('FullyConnected');
			% Set properties
			obj.num_filters = num_filters;
            
            if nargin > 1
                obj.decay = double(decay);
            else
                obj.decay = 0;
            end
            if nargin > 2
                obj.lr = double(lr);
            else
                obj.lr = 0;
            end
            if nargin > 3
                obj.M = double(M);
            else
                obj.M = 0;
            end
		end
		
		% Initialize the inner parameters and compute output shape
		function [obj, y] = initialize(obj, x)
            % Initialize the layers parameters W, b, dW, db, etc.
            %%% START YOUR CODE HERE %%%
            % Parameters
            range = sqrt(6)/ x(4) + obj.num_filters +1; %not sure
            obj.W = -range + (2*range).*rand(x);
			obj.b = double(zeros(x(4), 1));
			
            % Gradients
			obj.dW = gradient(obj.W);
			obj.db = double(zeros(obj.num_filters, 1));
			
            % Update (Useful for RMSProp and AdaM updates)
			obj.uW = 0;
			obj.ub = 0;
            
            % Average (Useful for RMSProp and AdaM updates)
			obj.aW = mean(obj.W);
			obj.ab = 0;
			
            % Output
			y = [1 1 obj.num_filters x(4)];
            %%% END YOUR CODE HERE %%%
		end
		
		% Forward pass
		function [obj, y , L] = forward(obj, x)
            % Compute the loss (L) and the layers output (y)
            % A vectorized implementation can speed up your training.
            % Make use of reshape and repmat to create the tensors
            %%% START YOUR CODE HERE %%%
            L = 0;
            %squeeze(reshape(repmat(obj.b,size(x,1),size(x,2)),size(x)))
            t = reshape(obj.W,size(x)).*x;
            y = t + reshape(repmat(obj.b,size(x,1),size(x,2)),size(x));
            L = 0;
            %%% END YOUR CODE HERE %%%
		end
		
		% Backward pass
		function [obj, dx] = backward(obj, dy, x)
            % Compute the gradients dx,dW and db using dy,x and W
            %%% START YOUR CODE HERE %%%
            dx = obj.W .* dy;
            obj.dW = x .* dy;
            obj.db = obj.b; %sum(obj.b * dy);
            %%% END YOUR CODE HERE %%%
		end
		
		% Updates the layers parameters via stochastic gradient descent
		function obj = update(obj)
            % Use dW and db computed in the backward pass together with the
            % layer settings for learning rate (lr) and momentum (M) to
            % compute the update, you can use uW,ub and aW,ab to store
            % certain values
            %%% START YOUR CODE HERE %%%
            
            
            
            % obj.W = ...
            % obj.b = ...
            %%% END YOUR CODE HERE %%%
		end
	end
end