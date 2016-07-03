function disp_match_features_vgg(img1,img2,feat1,feat2,match_points)
%
%Displays affine regions on the image
%
%disp_features(file1,imf1,dx,dy)
%
%file1 - 'filename' - ASCII file with affine regions
%imf1 - 'filename'- image
%dx - shifts all the regions in the image by dx  
%dy - shifts all the regions in the image by dy
%
%example:
%disp_features('101300.siftgeo','101300.pgm',0,0);

%   meta        meta data for each descriptor, i.e., per line:
%               x, y, scale, angle, mi11, mi12, mi21, mi22, cornerness


dx = 0;
dy = 0;

[h1, w1,~]= size(img1);
[h2,w2,~] = size(img2);

%new image  and show images
if(h1 == h2 && w1 == w2)
    I = [img1 img2];
else if(h1 < h2 )
     comI = zeros(h2-h1,w1,3);
     %comI = zeros(h2-h1,w1);
     img1 = [img1;comI];
     I = [img1 img2];
    else        
     comI = zeros(h1-h2,w2,3);
     %comI = zeros(h1-h2,w2);
     img2 = [img2;comI];
     I = [img1 img2];
    end
end
clear img1;
clear img2;
clf;
imshow(I);

%draw the boundry of img1 and img2;
hold on;
boundary_x = w1*ones(h1);
boundary_y = 1:h1;
plot(boundary_x,boundary_y,'-c','LineWidth',2);

n_match = size(match_points,2);
%n_match = 1;
%draw ellispe in the image1
for k=1:n_match%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    c1 = match_points(1,k);    
    drawellipse([feat1(3,c1) feat1(4,c1); feat1(4,c1) feat1(5,c1) ], feat1(1,c1)+dx, feat1(2,c1)+dy,'r', 1);
end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%draw ellispe in the image2
for k=1:n_match%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    c1 = match_points(2,k);    
    drawellipse([feat2(3,c1) feat2(4,c1); feat2(4,c1) feat2(5,c1) ], feat2(1,c1)+dx+w1, feat2(2,c1)+dy,'r', 1);
    %drawellipse([feat2(3,c1) feat2(4,c1); feat2(4,c1) feat2(5,c1) ], feat2(1,c1)+dx, feat2(2,c1)+dy+w1,'r', 1);
end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      

%draw match line
%color = 'g';
color = 'w';
length = 1;
for k=1:n_match
    c1 = match_points(1,k);
    c2 = match_points(2,k);
    x1 = feat1(1,c1)+dx;
    y1 = feat1(2,c1)+dy;
    x2 = feat2(1,c2)+dx+w1;
    y2 = feat2(2,c2)+dy;
    drawline(x1,y1,x2,y2,color,length)
end
end

function drawellipse(Mi,i,j,col,scale)
hold on;

[v, e]=eig(Mi);
l1=1/sqrt(e(1));  %long axis
l2=1/sqrt(e(4));  %short axis
%l1=e(1);
%l2=e(4);

alpha=atan2(v(4),v(3));
s=scale; %s =1;

t = 0:pi/50:2*pi;
y=s*(l2*sin(t));
x=s*(l1*cos(t));  %scale change 

xbar=x*cos(alpha) + y*sin(alpha);
ybar=y*cos(alpha) - x*sin(alpha); %clock-wise rotation 

%plot(ybar+i,xbar+j,'-y','LineWidth',2);
plot(ybar+i,xbar+j,col,'LineWidth',2);
col='-y';

%plot([i-2 i+2],[j j],col,'LineWidth',3);
%plot([i i],[j-2 j+2],col,'LineWidth',3);

set(gca,'Position',[0 0 1 1]);
hold off;
end

function drawline(x_start,y_start,x_end,y_end,color,width)
  hold on;
  
  theta = atan2(y_end-y_start,x_end-x_start);
  t = 0:1:(x_end-x_start);
  dx = 0:1:(x_end-x_start);
  dy = dx * tan(theta);
  
  plot(dx+x_start,dy+y_start,color,'LineWidth',width);
  
  set(gca,'Position',[0 0 1 1]);
  hold off;
end
