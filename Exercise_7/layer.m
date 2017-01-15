%% TDCV exercise on neural networks
%
classdef layer
	% Layer base class
	properties
		% Layer type
		type;
	end
	
	methods
        % Constructor
		function obj = layer(type)
			obj.type = type;
		end
		
		% Initialize
		function [obj, y] = initialize(obj, x)
			y = x;
		end
		
		% Update
        function obj = update(obj, lr, M)
		end
	end
end