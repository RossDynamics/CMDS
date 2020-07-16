# CMDS

[![View CMDS on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/78182-cmds)

## Introduction

CMDS (Context Manager for Dynamical Systems) is a MATLAB framework designed to facilitate analysis of dynamical systems. CMDS can help you:

* organize and manipulate dynamics data (numeric arrays, symbolic expressions, etc.)
* transform effortlessly between coordinate systems (new bases and origins, as well as velocity/momentum coordinate conversions, are currently supported)
* automatically derive and apply Hamiltonians, equations of motion, etc.

CMDS introduces the concept of _context objects_. Context objects are hierarchical representations of dynamical systems and their data. 
They store just about everything&mdash;parameters, equations of motion, active coordinate systems, integration settings, etc.&mdash;as _properties_.
Context objects are manipulated with _context access functions_, which edit or view context objects using a pass-by-value approach.

The most fundamental context access functions, `cg` and `cs`, respectively read and write properties while automatically converting to and from 
the active coordinate system. For example, if velocity variables are active in a context object's coordinate system, `cg` will 
return symbolic expressions stored in the context object in terms of `qdot` variables. If momentum variables are instead active, `cg` will instead use `p` variables. 
CMDS's coordinate system conversion functionality works with both numeric and symbolic data.

Some context access functions perform higher-level functionality. The `solveDynamics` function, for example, calculates and stores the Lagrangian, the Hamiltonian,
the conversion equations between `qdot` and `p` variables, and even the equations of motion for a system. The `integ` function numerically integrates a desired trajectory
using the equations of motion and (if needed) any parameters stored in the context object.

CMDS enormously automates workflows. You don't need to code equations of motion, energies, conversion functions, etc. separately anymore. Using
just a few lines of code, one can specify variables, parameters, and kinetic and potential energies and almost immediately start integrating;
CMDS will create the equations of motion and everything else for you. 

For a useful introductory example to CMDS, see examples/harmonic_oscillator/run_me.m.

## Installation

Download this repository. Then, add the downloaded folder to your MATLAB path with the command

`addpath(genpath(<path to CMDS>));`

### Requirements

CMDS requires MATLAB and the [Symbolic Math Toolbox](https://www.mathworks.com/help/symbolic/getting-started-with-symbolic-math-toolbox.html).
Optional support for other toolboxes may be added in the future.

# Contributing

Pull requests, bug reports, and feature suggestions are all welcome. CMDS is still in the early stages of development, so be aware that CMDS features
may change dramatically and without warning.

## License

CMDS uses the [MIT license](https://choosealicense.com/licenses/mit/).
