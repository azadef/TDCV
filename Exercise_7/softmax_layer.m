classdef softmax_layer < layer
    % Softmax layer class
	properties
	end
	methods
		% Constructor
		function obj = softmax_layer()
			% Call layer constructor
			obj@layer('Softmax');
		end
		
		% Forward pass
		function [obj, y , L] = forward(obj, x)
			% Implement the softmax transformation
			% For numerical stability it is best to subtract the maximum value
			% per channel and sample before computing the exponential.
			%%% START YOUR CODE HERE %%%
            % L = ...
            
            
            % y = ...
			%%% END YOUR CODE HERE %%%
		end
		
		% Backward pass
		function [obj, dx] = backward(obj, dy, x)
            % For numerical stability we just copy the gradients
			dx = dy;
        end
	end
end