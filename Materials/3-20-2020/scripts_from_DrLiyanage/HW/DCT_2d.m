clear all
st=10/(10*1e6);
a=1;%latency
b=2;%latency for delay between mux
a_mux=2;%latency within mux
W=8; B=0;
    T1 = [1,1,1,1,1,1,1,1;
        0,1,0,0,0,0,-1,0;
        1,0,0,-1,-1,0,0,1;
        1,0,0,0,0,0,0,-1;
        1,-1,-1,1,1,-1,-1,1;
        0,0,0,1,-1,0,0,0;
        0,-1,1,0,0,1,-1,0;
        0,0,1,0,0,-1,0,0];
    
%     D = diag([1/sqrt(8), % Diagonal matrix is absorbed to 
%         1/sqrt(2), 
%         1/2, 
%         1/sqrt(2), 
%         1/sqrt(8), 
%         1/sqrt(2), 
%         1/2, 
%         1/sqrt(2)]);
%     
% T = D*T1;
T=T1;
Tinv = T';

% v = [1 1 1 1 1 1 1 1];
% input=diag(v);
input=zeros(8,8);
input(1,1)=1;

Midchunk =( T* input)'
chunk = (T* input * Tinv);

x=zeros(8,9);
x(:,1) = 0:st:7*st;      
x(:,2:9)=255*input;

tic
sim('DCT_2D_MRDCT');
toc