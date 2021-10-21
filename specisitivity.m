function [specifity,sensitivity] = specisitivity(tp,tn,fp,fn)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
specifity = tn/(tn+fp);
sensitivity = tp/(tp+fn);
precision = tp/(tp+fp);
accuracy = (tp+tn)./(tp+fp+tn+fn)
end

