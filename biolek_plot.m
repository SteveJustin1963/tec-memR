% Biolek Window Function Plot for Memristor Models
% f(x) = 1 - (2*x - 1)^(2*p), x in [0,1]

clear all;
close all;

x = linspace(0, 1, 1000);  % Fine grid for smooth curves

p_values = [1, 2, 4, 8, 16];  % Common values of p
colors = {'b', 'r', 'g', 'm', 'c'};  % Different colors for each curve

figure;  % Open a new figure window
hold on;
grid on;

for i = 1:length(p_values)
    p = p_values(i);
    f = 1 - (2*x - 1).^(2*p);
    plot(x, f, colors{i}, 'LineWidth', 2, 'DisplayName', sprintf('p = %d', p));
end

hold off;

title('Biolek Window Function f(x) = 1 - (2x - 1)^{2p} for Different p Values');
xlabel('State Variable x (normalized, 0 to 1)');
ylabel('Window Function f(x)');
legend('show', 'Location', 'best');
axis([0 1 0 1.05]);  % Slight padding on y-axis

% Keep the plot window open until you close it manually
waitfor(gcf);


