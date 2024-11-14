clc,clear
n=input('enter the number of fibo sequence you want\n')

if n==1
    third=0;
elseif n==2
    third=1;
else
    first=0;
    second=1;
    for i=3:n
        third=second+first;
        first=second;
        second=third;
    end
end
fprintf('your %dth number of fibo sequence is %d \n',n,third)