function YamlStruct = ReadYaml(yaml_file)
% This function reads Yaml file into struct
% Example
% >> yaml_file = 'EnaspolMain.yaml';
% >> YamlStruct = ReadYaml(yaml_file)
%
%  %======================================================================
%{
		Copyright (c) 2011
		This program is a result of a joined cooperation of Energocentrum
		PLUS, s.r.o. and Czech Technical University (CTU) in Prague.
        The program is maintained by Energocentrum PLUS, s.r.o. and
        licensed under the terms of MIT license. Full text of the license
        is included in the program release.
		
        Author(s):
		Jiri Cigler, Dept. of Control Engineering, CTU Prague 
		Jan  Siroky, Energocentrum PLUS s.r.o.
		
        Implementation and Revisions:

        Auth  Date        Description of change
        ----  ---------   -------------------------------------------------
        jc    01-Mar-11   First implementation
        jc    02-Mar-11   .jar package initialization moved to external fun
        jc    18-Mar-11   Warning added when imported file not found
        jc    07-Jun-11   Ability to merge structures
%}
%======================================================================

InitYaml();

import('org.yaml.snakeyaml.Yaml');

yamlreader = Yaml();

Data = ReplaceImportByStruct(yaml_file);

work_folder=fileparts(yaml_file);
if isfield(Data,'import')    
    for i=1:numel(Data.import)
        fToImport=[work_folder filesep Data.import{i}];
        
        try            
            s = ReplaceImportByStruct(fToImport);
            Data = catstruct(s,Data);
        catch
            warning('YAMLMatlab:FileNotFoundException','YAMLMatlab: File %s not found',fToImport);
        end        
    end
    %jymlobj = yamlreader.load(yml);
    %YamlStruct = Hash2Struct(jymlobj);
    YamlStruct = rmfield(Data,'import');
else
    YamlStruct =Data;
end
    function s = ReplaceImportByStruct(fname)
        yml_file = fileread(fname);
        ymlobj = yamlreader.load(yml_file);

        s = Hash2Struct(ymlobj);
    end % end of ReplaceImportByStruct

end % end of function


function A = catstruct(varargin)
% CATSTRUCT - concatenate structures
%
%   X = CATSTRUCT(S1,S2,S3,...) concates the structures S1, S2, ... into one
%   structure X. 
%
%   Example:
%     A.name = 'Me' ; 
%     B.income = 99999 ; 
%     X = catstruct(A,B) 
%     % -> X.name = 'Me' ;
%     %    X.income = 99999 ;
%
%   CATSTRUCT(S1,S2,'sorted') will sort the fieldnames alphabetically.
%
%   If a fieldname occurs more than once in the argument list, only the last
%   occurence is used, and the fields are alphabetically sorted.
%
%   To sort the fieldnames of a structure A use:
%     A = CATSTRUCT(A,'sorted') ;
%
%   To concatenate two similar array of structs use simple concatenation:
%     A = dir('*.mat') ; B = dir('*.m') ; C = [A ; B] ;
%
%   When there is nothing to concatenate, the result will be an empty
%   struct (0x0 struct array with no fields). 
%
%   See also CAT, STRUCT, FIELDNAMES, STRUCT2CELL

% for Matlab R13 and up
% version 2.2 (oct 2008)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% Created:  2005
% Revisions
%   2.0 (sep 2007) removed bug when dealing with fields containing cell
%                  arrays (Thanks to Rene Willemink) 
%   2.1 (sep 2008) added warning and error identifiers
%   2.2 (oct 2008) fixed error when dealing with empty structs (Thanks to
%                  Lars Barring)

N = nargin ;

error(nargchk(1,Inf,N)) ;

if ~isstruct(varargin{end}),
    if isequal(varargin{end},'sorted'),
        sorted = 1 ;
        N = N-1 ;
        if N < 1,
            A = struct([]) ;
            return
        end
    else
        error('catstruct:InvalidArgument','Last argument should be a structure, or the string "sorted".') ;
    end
else
    sorted = 0 ;
end

FN = cell(N,1) ;
VAL = cell(N,1) ;

for ii=1:N,
    X = varargin{ii} ;
    if ~isstruct(X),
        error('catstruct:InvalidArgument',['Argument #' num2str(ii) ' is not a structure.']) ;
    end
    if ~isempty(X),
        % empty structs are ignored
        FN{ii} = fieldnames(X) ;
        VAL{ii} = struct2cell(X) ; 
    end
end

FN = cat(1,FN{:}) ;
VAL = cat(1,VAL{:}) ;
[UFN,ind] = unique(FN) ;

if numel(UFN) ~= numel(FN),
    warning('catstruct:DuplicatesFound','Duplicate fieldnames found. Last value is used and fields are sorted') ;
    sorted = 1 ;
end

if sorted,
    VAL = VAL(ind) ;
    FN = FN(ind) ;
end

if ~isempty(FN),
    % This deals correctly with cell arrays
    A = cell2struct(VAL, FN);
else
    A = struct([]) ;
end
end



