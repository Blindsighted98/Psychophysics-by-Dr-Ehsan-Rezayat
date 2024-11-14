function Salar4_func()
clf;
x_data=rand(1,200);
save x_data;
y_data=rand(1,200);
scatter(x_data,y_data, 50, jet(200), 'filled')
axis equal
grid on
%legend On
grid on
xlabel('XAxis', 'FontSize', 14,'Color','r') 
ylabel('YAxis', 'FontSize', 14,'Color','B') 

end