
%--------------------------------------------------------------------------
% Does merge of two structures. The result is structure which is union of
% fields of p and s. If there are equal field names in p and s, fields in p
% are overwriten with their peers from s.
%
function result = merge_struct(p, s, donotmerge)
    if ~exist('donotmerge','var')
        donotmerge = {};
    end
    result = p;
    for i = fields(s)'
        fld = char(i);
        if any(cellfun(@(x)isequal(x, fld), donotmerge))
            continue;
        end;
        if isfield(result, fld)
            % Just give the user a hint that there may be some information
            % lost.
            fprintf(['Overwriting field ',fld,'\n']);
        end;
        result.(fld) = s.(fld);
    end;
end