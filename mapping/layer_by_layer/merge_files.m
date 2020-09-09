
clc
clear
close all

string_name='steel_shield';
number_of_layers=6;

clear BSave_Store 

for i=1:number_of_layers;
   string_use=strcat(string_name,'_layer',num2str(i),'.mat');
   load(string_use);
   if i==1;
       BSave_Store=BSave;
   else
       BSave_Store=cat(3,BSave_Store,BSave);
   end
   
    
    
end

BSave=BSave_Store;
save(strcat(string_name,'.mat'),'BSave')