function [neuronsSorted,neuronsNamesSorted,namesAllChar,namesAll]=nexSortNeurons(neurons)

%%%%nexSortNeurons just extracts neurons names for my data

neuronsNum=size(neurons,1);

%%%%%%this loop is to extract all of the names
namesAll=cell(neuronsNum,1);
for j=1:neuronsNum
    %%%%namesAll ia a cell contains names of neurons
    namesAll{j,1}=neurons{j}.name;
    
end
namesAllChar=char(namesAll);%%%%convert cell array to char


% neuronsSorted={};
% neuronsNamesSorted=[];
% 
% 
% 
% NeuronsIndices=[];
% 
%     for i=1:neuronsNum-1
%         
%         A=namesAllChar(i,:);
%         B=namesAllChar(i+1,:);
%         
%         L1=length(A);
%         L2=length(B);
%         
%         
%         
%         if L1==L2 && A(end)==' '
%             cmp1=A(1:end-2)==B(1:end-2);
%             cmp2=A(end-1)~=B(end-1);
%             
%             if isempty(find(~cmp1)) && isempty(find(~cmp2))
%                 NeuronsIndices=[NeuronsIndices i];
% %             count=count+1;
%             end
%         end
%         
%         if L1==L2 && A(end)~=' '
%             cmp1=A(1:end-1)==B(1:end-1);
%             cmp2=A(end)~=B(end);
%             
%             if isempty(find(~cmp1)) && isempty(find(~cmp2))
%                 NeuronsIndices=[NeuronsIndices i];
% %             count=count+1;
%             end
%         end
%         
%         
%     end


% neuronsSorted=neurons(NeuronsIndices);
% neuronsNamesSorted=namesAll(NeuronsIndices);

neuronsSorted=neurons;
neuronsNamesSorted=namesAll;


end