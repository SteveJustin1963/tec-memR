% Minimal plotting test to isolate crash
graphics_toolkit('gnuplot');  % Try gnuplot instead of qt
x = linspace(0, 2*pi, 100);
y = sin(x);

figure(1);
plot(x, y);
title('Test Plot');
xlabel('x');
ylabel('sin(x)');
grid on;

print -dpng test_plot.png -r150
fprintf("Plot saved successfully to test_plot.png\n");
