function s = TimeVals2Cell(time,datavalues,header)
% creates a typical struct with field named by header. Values are cell of
% date and vals.


for i=1:numel(header)
    s.(header{i}) = [num2cell(DateTime(time)) num2cell(datavalues(:,i))];
end
end