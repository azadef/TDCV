%% TDCV exercise on neural networks

classdef neural_network
    % Neural network class
    % Holds layers, input/output blobs and their gradients
    % Provides functions for forward and backward pass
	properties
        % The input size of the network
		input_size;
        % Vector with all the layers
		layers;
        % Vector with all the data between layers (blobs)
        blobs;
        % Vector with all the gradients between layers (blobs)
        bblobs;
	end
	methods
        % Constructor
		function obj = neural_network()
            obj.layers = {};
            obj.blobs = {};
        end
		
        % Initialize the network, given an input size
		function obj = initialize(obj, x)
			obj.input_size = x;
            
            % Set input as first blob
            obj.blobs = {};
            obj.blobs{1} = zeros(obj.input_size);
            obj.bblobs{1} = zeros(obj.input_size);
            
            fprintf('%d %s %dx%dx%dx%d\n', 0, 'Input', obj.input_size(1), obj.input_size(2), obj.input_size(3), obj.input_size(4));
            
            % Initialize the layers
			for i=1:length(obj.layers)
                % Initialize layer
				[obj.layers{i}, y] = obj.layers{i}.initialize(x);
                
                % Allocate output
                obj.blobs{i+1} = zeros(y);
                obj.bblobs{i+1} = zeros(y);
                
                fprintf('%d %s %dx%dx%dx%d\n', i, obj.layers{i}.type, y(1), y(2), y(3), y(4));
                
                % Layer output becomes the input of the next layer
				x = y;
			end
        end
		
        % Forward pass through the whole network
		function [obj, y, L] = forward_all(obj, x)
            obj.blobs{1} = x;
            L = 0;
			for i=1:length(obj.layers)
				[obj.layers{i}, obj.blobs{i+1}, l] = obj.layers{i}.forward(obj.blobs{i});
                L = L + l;
            end
            y = obj.blobs{end};
        end
		
        % Backward pass through the whole network
		function [obj, dx] = backward_all(obj, dy)
            obj.bblobs{length(obj.layers)+1} = dy;
			for i=length(obj.layers):-1:1
				[obj.layers{i}, obj.bblobs{i}] = obj.layers{i}.backward(obj.bblobs{i+1}, obj.blobs{i});
            end
            dx = obj.bblobs{1};
        end
        
        % Backward pass from layer x to layer y (pracitcal for visualization)
		function [obj, dx] = backward_from_to(obj, dy, from, to)
            obj.bblobs{from+1} = dy;
			for i=from:-1:to
				[obj.layers{i}, obj.bblobs{i}] = obj.layers{i}.backward(obj.bblobs{i+1}, obj.blobs{i});
            end
            dx = obj.bblobs{1};
        end
        
        % Load trained parameters from hdf5 file
        function obj = load(obj, path, layers)
            % Check file
            if ~exist(path,'file')
                error(sprintf('File %s does not exist\n', path));
            end
            
            if nargin < 3
                layers = 1:length(obj.layers);
            end
            
            num_conv_layers = 0;
            num_ip_layers = 0;
            for j=1:length(layers)
                i = layers(j);
                if isa(obj.layers{i}, 'conv_layer') || isa(obj.layers{i}, 'deconv_layer') || isa(obj.layers{i}, 'fc_layer')
                    % Construct layer name
                    if isa(obj.layers{i}, 'conv_layer')
                        num_conv_layers = num_conv_layers + 1;
                        layer_name = sprintf('conv%d', num_conv_layers);
                    elseif isa(obj.layers{i}, 'deconv_layer')
                        num_ip_layers = num_ip_layers + 1;
                        layer_name = sprintf('deconv%d', num_ip_layers);
                    else
                        num_ip_layers = num_ip_layers + 1;
                        layer_name = sprintf('ip%d', num_ip_layers);
                    end
                    
                    % Weights
                    obj.layers{i}.W = hdf5read(path, sprintf('/data/%s/%d', layer_name, 0));
                    if isa(obj.layers{i}, 'deconv_layer')
                        obj.layers{i}.W = permute(obj.layers{i}.W,[1 2 4 3]);
                    end
                    % Bias
                    obj.layers{i}.b = hdf5read(path, sprintf('/data/%s/%d', layer_name, 1));
                    
                    fprintf(1, 'Loaded paremters for %s\n', layer_name);
                end
            end
        end
        
        % Save parameters to hdf5 file
        function save(obj, path)
            
            % Delete snapshot
            if exist(path,'file')
                delete(path);
            end
            
            num_conv_layers = 0;
            num_ip_layers = 0;
            for i=1:length(obj.layers)
                
                if isa(obj.layers{i}, 'conv_layer') || isa(obj.layers{i}, 'deconv_layer') || isa(obj.layers{i}, 'fc_layer')
                    % Construct layer name
                    if isa(obj.layers{i}, 'conv_layer')
                        num_conv_layers = num_conv_layers + 1;
                        layer_name = sprintf('conv%d', num_conv_layers);
                    elseif isa(obj.layers{i}, 'deconv_layer')
                        num_ip_layers = num_ip_layers + 1;
                        layer_name = sprintf('deconv%d', num_ip_layers);
                    else
                        num_ip_layers = num_ip_layers + 1;
                        layer_name = sprintf('ip%d', num_ip_layers);
                    end
                    
                    if isa(obj.layers{i}, 'deconv_layer')
                        obj.layers{i}.W = permute(obj.layers{i}.W,[1 2 4 3]);
                    end
                    
                    if exist(path,'file')
                        % Weights
                        hdf5write(path, sprintf('/data/%s/%d', layer_name, 0), obj.layers{i}.W, 'WriteMode', 'append');
                        % Bias
                        hdf5write(path, sprintf('/data/%s/%d', layer_name, 1), obj.layers{i}.b, 'WriteMode', 'append');
                    else
                        % Weights
                        hdf5write(path, sprintf('/data/%s/%d', layer_name, 0), obj.layers{i}.W);
                        % Bias
                        hdf5write(path, sprintf('/data/%s/%d', layer_name, 1), obj.layers{i}.b, 'WriteMode', 'append');
                    end
                    
                    if isa(obj.layers{i}, 'deconv_layer')
                        obj.layers{i}.W = permute(obj.layers{i}.W,[1 2 4 3]);
                    end
                end
            end
        end
        
        % Returns vector with all parameter gradients
        % (Used for optimization)
        function grad = get_grad(obj)
            grad = [];
            for i=1:length(obj.layers)
                if isa(obj.layers{i}, 'fc_layer') ||isa(obj.layers{i}, 'conv_layer')
                    grad = [grad;obj.layers{i}.dW(:);obj.layers{i}.db(:)];
                end
            end
        end
        
        % Returns vector with all parameters
        % (Used for optimization)
        function theta = get_theta(obj)
            theta = [];
            for i=1:length(obj.layers)
                if isa(obj.layers{i}, 'fc_layer') ||isa(obj.layers{i}, 'conv_layer')
                    theta = [theta;obj.layers{i}.W(:);obj.layers{i}.b(:)];
                end
            end
        end
        
        % Updates the networks parameters with new values given as vector
        function obj = set_theta(obj, theta)
            offset = 1;
            for i=1:length(obj.layers)
                if isa(obj.layers{i}, 'fc_layer') ||isa(obj.layers{i}, 'conv_layer')
                    obj.layers{i}.W = reshape(theta(offset:offset+prod(size(obj.layers{i}.W))-1), size(obj.layers{i}.W));
                    offset = offset + prod(size(obj.layers{i}.W));
                    obj.layers{i}.b = reshape(theta(offset:offset+prod(size(obj.layers{i}.b))-1), size(obj.layers{i}.b));
                    offset = offset + prod(size(obj.layers{i}.b));
                end
            end
        end
	end
end