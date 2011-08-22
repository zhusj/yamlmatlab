%==========================================================================
% Recursively walks through a Matlab hierarchy and converts it to the
% hierarchy of java.util.ArrayListS and java.util.MapS. Then calls
% Snakeyaml to write it to a file.
%=========================================================================
function WriteYaml(data, filename)
    [pth,~,~,~] = fileparts(mfilename('fullpath'));
    javaaddpath([pth '\external\snakeyaml-1.8.jar']);
    import('org.yaml.snakeyaml.Yaml');
    javastruct = scan(data);
    yaml = Yaml();
    output = yaml.dump(javastruct);
    fid = fopen(filename,'w');
    fprintf(fid,'%s',char(output) );
    fclose(fid);
end

%--------------------------------------------------------------------------
%
%
function result = scan(r)
    if ischar(r)
        result = scan_char(r);
    elseif iscell(r)
        result = scan_cell(r);
    elseif isord(r)
        result = scan_ord(r);
    elseif isstruct(r)
        result = scan_struct(r);                
    elseif isnumeric(r)
        result = scan_numeric(r);
    elseif isa(r,'DateTime')
        result = scan_datetime(r);
    else
        error(['Cannot handle type: ' class(r)]);
    end
end

%--------------------------------------------------------------------------
%
%
function result = scan_numeric(r)
    result = java.lang.Double(r);
end

%--------------------------------------------------------------------------
%
%
function result = scan_char(r)
    result = java.lang.String(r);
end

%--------------------------------------------------------------------------
%
%
function result = scan_datetime(r)
    result = java.util.Date(datestr(r));
end

%--------------------------------------------------------------------------
%
%
function result = scan_cell(r)
    if(isrowvector(r))
        result = scan_cell_row(r);
    elseif(iscolumnvector(r))
        result = scan_cell_column(r);
    elseif(ismymatrix(r))
        result = scan_cell_matrix(r);
    elseif(issingle(r));
        result = scan_cell_single(r);
    else
        error('Unknown cell content.');
    end;
end

%--------------------------------------------------------------------------
%
%
function result = scan_ord(r)
    if(isrowvector(r))
        result = scan_ord_row(r);
    elseif(iscolumnvector(r))
        result = scan_ord_column(r);
    elseif(ismymatrix(r))
        result = scan_ord_matrix(r);
    elseif(issingle(r))
        result = scan_ord_single(r);
    else
        error('Unknown ordinary array content.');
    end;
end

%--------------------------------------------------------------------------
%
%
function result = scan_cell_row(r)
    result = java.util.ArrayList();
    for ii = 1:size(r,2)
        result.add(scan(r{ii}));
    end;
end

%--------------------------------------------------------------------------
%
%
function result = scan_cell_column(r)
    result = java.util.ArrayList();
    for ii = 1:size(r,1)
        result.add(scan(r{ii}));
    end;    
end

%--------------------------------------------------------------------------
%
%
function result = scan_cell_matrix(r)
    result = java.util.ArrayList();
    for ii = 1:size(r,1)
        i = r(ii,:);
        result.add(scan_cell_row(i));
    end;
end

%--------------------------------------------------------------------------
%
%
function result = scan_cell_single(r)
    result = scan(r{1});
end

%--------------------------------------------------------------------------
%
%
function result = scan_ord_row(r)
    result = java.util.ArrayList();
    for i = r
        result.add(scan(i));
    end;
end

%--------------------------------------------------------------------------
%
%
function result = scan_ord_column(r)
    result = scan_ord_row(r);
end

%--------------------------------------------------------------------------
%
%
function result = scan_ord_matrix(r)
    result = java.util.ArrayList();
    for i = r'
        result.add(scan_ord_row(i'));
    end;
end

%--------------------------------------------------------------------------
%
%
function result = scan_struct(r)
    result = java.util.LinkedHashMap();
    for i = fields(r)'
        key = i{1};
        val = r.(key);
        result.put(key,scan(val));
    end;
end











