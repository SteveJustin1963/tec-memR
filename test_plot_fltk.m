% Test with FLTK backend
graphics_toolkit('fltk');
x = linspace(0, 2*pi, 100);
y = sin(x);

figure(1);
plot(x, y);
title('Test Plot - FLTK');
xlabel('x');
ylabel('sin(x)');
grid on;

print -dpng test_plot_fltk.png -r150
fprintf("FLTK: Plot saved successfully to test_plot_fltk.png\n");
