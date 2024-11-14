clc,clear;
curse=[0,1];
for i=3:11 %fibonacci
    curse(i)=curse(i-1)+curse(i-2);
end
curse(2,1)=0; %x fibonacci
curse(3,1)=0; %y fibonacci
for i=2:11
    c=sqrt(2)*curse(1,i);
    if mod(i,4)==1 || mod(i,4)==2
        curse(2,i)=curse(2,i-1)+c;
    else
      curse(2,i)=curse(2,i-1)-c;
    end
    if mod(i,4)==2 || mod(i,4)==3
        curse(3,i)=curse(3,i-1)+c;
    else
      curse(3,i)=curse(3,i-1)-c;
    end
end
curse(4,1:21)=-100:10:100; %x zig zag
curse(5,:)=[0:5,4:-1:1,2:5,4:-1:1,2:4]*20;
curse(6,1)=0;
for i=2:21
curse(6,i)=curse(6,i-1)+((-1)^mod(i-1,2))*curse(5,i); %y zig zag
end
curse(7,1:322)=[-80:80,-80:80]; %x circle
for i=1:181
curse(8,i)=sqrt(80^2-curse(7,i)^2); %y circle
end
curse(8,162:322)=curse(8,1:161)*(-1); %y circle

figure
plot(curse(2,1:11),curse(3,1:11))
hold on
plot(curse(4,1:21),curse(6,1:21),'Color','y')
plot(curse(7,:),curse(8,:))
axis equal;
xlim([-100,100])
ylim([-100,100])
