## Overview ##
_YAMLMatlab_ is a set of Matlab functions which enables reading in and writing out documents in _YAML_ format (the format definition can be found on http://www.yaml.org/). The hierarchical structure of a YAML file is represented as a Matlab struct.

### Features ###
  * Reading in and writing out a yaml file.

  * Available data types are:
    * Time (like 00:11:12) (extra Matlab object is used to represent datetime stamp), internally represented in UTC format
    * Strings
    * Int/Double
    * Array of strings of size MxN
    * Matrices of arbitrary size
    * Introduced "description file" containing key-word "import" standing for files which are to be processed together e.g.
```
---
import: 
    - test1.yaml
    - test2.yaml
...
```
> > > stands for situation when the program reads two yaml files together
> > > into one struct

## Installation ##
Just add the codes and all subfolders to Matlab path by
```
>> addpath(genpath('path/to/codes'));
```
## Usage ##
  * Reading in:
```
 >> yaml_file = 'test.yaml';
 >> YamlStruct = ReadYaml(yaml_file);
```

  * Writing out
```
 >> x.name='Martin';
 >> WriteYaml('test.yaml',x)
```

## Contributors ##
This program was developed and is being maintained by Energocentrum
PLUS, s.r.o. and Czech Technical University (CTU) in Prague. One can
redistribute the program under terms of MIT license. Full text of the
license is included in the program release.

### Main authors ###
  * Jiri Cigler, Dept. of Control Engineering, CTU Prague http://support.dce.felk.cvut.cz/pub/ciglejir/
  * Jan  Siroky, Energocentrum PLUS, s.r.o.
  * Pavel  Tomasko, student at Faculty of Electrical Engineering, CTU Prague and Institute of Chemical Technology, Prague.

## Requirements ##

> Matlab 2009a and newer

## Known issues ##
  * Special characters as well as whitespaces  are not supported   in field names