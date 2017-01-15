%% TDCV exercise on neural networks

function stop = plot_loss(x,optimValues,state)
% Plots the loss after each optimization step
    global losses;
    if ~exist('losses', 'var') || (optimValues.iteration == 0)
        losses = [];
    end
    losses(end+1) = optimValues.fval;
    
    % Plot
    figure(1);
    hold on;
    title('Loss');
    if length(losses) == optimValues.iteration+1
        semilogy(0:optimValues.iteration, losses, 'k');
    end
    
    stop = 0;
end