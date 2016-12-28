classdef solver
    % Solver class
    % Stochastic gradient descent solver
    % Trains a neural network via backpropagation
	properties
		% Network
		network;
        % Loss type
        loss_type;
        % Snapshot interval
        snapshot_interval;
        % Losses
        losses;
	end
	methods
        % Constructor
		function obj = solver(network, loss_type, snapshot_interval)
            obj.network = network;
            obj.loss_type = loss_type;
            
            % Set automatic snapshot interval
            if nargin > 2
                obj.snapshot_interval = snapshot_interval;
            else
                obj.snapshot_interval = Inf;
            end

            obj.losses = [];
        end
        
        % Execute optimization step
        function obj = step(obj, x, y_gt)
            % Forward pass
            [obj.network, y, L] = obj.network.forward_all(x);
            
            % Compute the final loss
            if strcmp(obj.loss_type, 'log')
                [Ll, dy] = solver.log_loss(y, y_gt);
            else
                [Ll, dy] = solver.l2_loss(y, y_gt);
            end
            L = L + Ll;
           
            % Plot
            obj.losses(end+1) = L;
            fprintf(1,'Loss = %.5f\n', L);
            figure(1);
            title('Loss');
            semilogy(obj.losses,'b');
            drawnow;

            % Backward pass
            [obj.network, ~] = obj.network.backward_all(dy);
            
            % Update
            for j=1:length(obj.network.layers)
                obj.network.layers{j} = obj.network.layers{j}.update();
            end
            
            % Visualize
            visualize_features(obj.network.get_theta());
        end
		
        % Train the network
		function obj = solve(obj, x, y_gt, num_iterations)
            % Determine batch size
			batch_size = obj.network.input_size(end);

            % Optimization loop (stochastic gradient descent)
			for i=0:num_iterations-1
                fprintf(1, 'Iteration %d of %d\n', i+1, num_iterations);
                
                % Do optimization step
                if strcmp(obj.loss_type,'log')
                    obj = obj.step(x(:,:,:,mod((i*batch_size):((i+1)*batch_size-1),size(x,4))+1), y_gt(:,mod((i*batch_size):((i+1)*batch_size-1),size(x,4))+1));
                else
                    obj = obj.step(x(:,:,:,mod((i*batch_size):((i+1)*batch_size-1),size(x,4))+1), y_gt(:,:,:,mod((i*batch_size):((i+1)*batch_size-1),size(x,4))+1));
                end
                
                % Save the trained network
                if (i > 0) && (mod(i, obj.snapshot_interval) == 0)
                    obj.network.save(sprintf('trained_net_%d.h5', i));
                end
			end
        end
    end
    methods(Static)
        % Logistic loss function
        function [L, dy] = log_loss(y, y_gt)
            % Compute the logistic loss dy using the network output (y) and
            % the groundtruth labels (y_gt)
            % To avoid numerical problems is is helpful to add a small
            % number e.g. eps inside the log
            %%% START YOUR CODE HERE %%%
            
            %L =
                
        
            
            % dy = ...
            %%% END YOUR CODE HERE %%%
        end
        
        % L2 loss function
        function [L, dy] = l2_loss(y, y_gt)
            % Compute the L2 loss dy using the network output (y) and
            % the groundtruth labels (y_gt)
            %%% START YOUR CODE HERE %%%
            % Batch size
            dy = y-y_gt;
            L = sum(dy.*dy)/N;
            
        
            % dy = ...
            %%% END YOUR CODE HERE %%%
        end
        
        % Helper function for external optimizer
        function [L, grad] = opt_func(theta, x, y_gt, solv)
            % Set parameters
            solv.network = solv.network.set_theta(theta);
            
            % Forward pass
            [solv.network, y, L] = solv.network.forward_all(x);

            % Compute the loss
            [L2, dy] = solv.l2_loss(y, y_gt);
            L = L + L2;

            % Backward pass
            [solv.network, ~] = solv.network.backward_all(dy);
            
            % Get gradient
            grad = solv.network.get_grad();
        end
	end
end