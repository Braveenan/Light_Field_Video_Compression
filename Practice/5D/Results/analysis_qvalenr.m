clc
clear all

myFolder = 'E:/Semester notes/Individual Research Project/Practice/5D/Results';
baseFileName4 = 'LFV_enr.mat';

enr_mat = sprintf('%s/%s', myFolder ,baseFileName4);

load(enr_mat);


dataset_array = {'Dataset1 - Car', 'Dataset2 - David', 'Dataset3 - Toy'};
channel_array = {'LFVU', 'LFVV', 'LFVY'};
dcttype_array = {'True', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'PMC 2014'};
qval_array = [1, 3, 5, 7, 10, 15, 25, 35, 50, 80, 100, 120, 150, 180, 200];

subplot(2,2,1)
for d=1:3
    enr_arr = (transpose(squeeze(LFV_enr(d,1,1,1:15)))+transpose(squeeze(LFV_enr(d,2,1,1:15)))+4*transpose(squeeze(LFV_enr(d,3,1,1:15))))/6;
        
    plot(qval_array,enr_arr,'-o')
    hold on
end 
axis([0 200 0.9 1.1])
legend('Dataset1 - Car', 'Dataset2 - David', 'Dataset3 - Toy')
legend('Location','northeast')
grid on    
xlabel('Quantization value')
ylabel('Energy retained')   
title('True DCT')

for d=1:3
    subplot(2,2,d+1)
        
    for t = 1:7
        enr_arr = (transpose(squeeze(LFV_enr(d,1,t,1:15)))+transpose(squeeze(LFV_enr(d,2,t,1:15)))+4*transpose(squeeze(LFV_enr(d,3,t,1:15))))/6;      

        plot(qval_array,enr_arr,'-o')
        hold on
    end
    axis([0 200 0.9 1.1])
    legend('True', 'BAS 2008', 'BAS 2011 parameter 0', 'BAS 2011 parameter 1', 'CB 2011', 'Modified CB 2011', 'PMC 2014')
    legend('Location','northeast')
    grid on
    xlabel('Quantization value')
    ylabel('Energy retained')
    
    d_name = string(dataset_array(d));
    g_title = sprintf('%s',d_name);
    title(g_title)
end 






