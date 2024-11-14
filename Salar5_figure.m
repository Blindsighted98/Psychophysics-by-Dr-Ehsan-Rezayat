%%first
figure;
x=rand(1,200);
y=rand(1,200);
subplot(2,1,1)
plot(x);
title('Line__x','FontSize',20)
subplot(2,1,2)
colors = jet(length(x)); 
scatter(x, y, 36, colors, 'filled'); 
title('Scatter__x&y','FontSize',20)
xlabel('x probability','FontSize',12)
ylabel('y probability','FontSize',12)
%%
figure;
colorfulPic=imread('1.jpg');
grayy=rgb2gray(colorfulPic);
subplot(1,2,1);
imshow(colorfulPic)
subplot(1,2,2);
imshow(grayy)
%%
figure;
resPic=imresize(grayy,[100,100]);
noiseResPic=imnoise(resPic,"gaussian",0.5);
subplot(1,2,1);
imshow(resPic)
subplot(1,2,2);
imshow(noiseResPic);
%%
save('xVar',"x");
imwrite(noiseResPic,'noise.jpg');