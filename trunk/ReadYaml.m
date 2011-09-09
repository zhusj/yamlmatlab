%==========================================================================
% Actually reads YAML file and transforms it using several mechanisms:
%
%   - Transforms mappings and lists into Matlab structs and cell arrays,
%     for timestamps uses DateTime class, performs all imports (when it
%     finds a struct field named 'import' it opens file(s) named in the
%     field content and substitutes the filename by their content.
%   - Deflates outer imports into inner imports - see deflateimports(...)
%     for details.
%   - Merges imported structures with the structure from where the import
%     was performed. This is actually the same process as inheritance with
%     the difference that parent is located in a different file.
%   - Does inheritance - see doinheritance(...) for details.
%   - Makes matrices from cell vectors - see makematrices(...) for details.
%
function result = ReadYaml(filename)
    ry = ReadYamlRaw(filename, 0);
    ry = deflateimports(ry);
    if iscell(ry) && ...
        length(ry) == 1 && ...
        isstruct(ry{1}) && ...
        length(fields(ry{1})) == 1 && ...
        isfield(ry{1},'import')        
        ry = ry{1};
    end;
    ry = mergeimports(ry);    
    ry = doinheritance(ry);
    ry = makematrices(ry);
    result = ry;
end