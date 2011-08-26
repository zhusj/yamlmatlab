function result = doinheritance(r)
    result = recurse(r, 0, []);
end

function result = recurse(data, level, addit)
    if iscell(data) && ~ismymatrix(data)
        result = iter_cell(data, level, addit);
    elseif isstruct(data)
        result = iter_struct(data, level, addit);
    else
        result = data;
    end;
end

function result = iter_cell(data, level, addit)
    result = {};
    for i = 1:length(data)
        result{i} = recurse(data{i}, level + 1, addit);
    end;
end

function result = iter_struct(data, level, addit)
    result = struct();
    for i = fields(data)'
        fld = char(i);
        result.(fld) = recurse(data.(fld), level + 1, addit);
    end;
    
    % Inheritance here (point of return from tree traversal):
    
    result = inherit(result);
end

function result = inherit(homestruct)
    for i = fields(homestruct)'
        fld = char(i);
        if isfield(homestruct.(fld), kwd_parent())
            parfcont = homestruct.(fld).(kwd_parent());
            if iscell(parfcont)
                for p = parfcont(:)'
                    homestruct = inherit_concrete(homestruct, p, fld);
                end;
            else
                homestruct = inherit_concrete(homestruct, parfcont, fld);
            end;
        end;
    end;
    result = homestruct;
end

function result = inherit_concrete(homestruct, par, fld)
    parchr = char(par);    
    parstruct = eval(['homestruct.' parchr]);
    parstruct = inherit(parstruct);
    homestruct.(fld) = merge_struct(parstruct, homestruct.(fld));
    result = homestruct;
end