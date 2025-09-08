# ThickIntervals.jl

This package provides a basic implementation of *thick intervals* for the Julia language. It builds on top of [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl).

## About

A [thick interval](https://www.sciencedirect.com/science/article/pii/S0004370217300425) is an [interval](https://en.wikipedia.org/wiki/Interval_arithmetic) with uncertain bounds; that is, the bounds are intervals themselves.

## Installation

This package requires [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl?tab=readme-ov-file#installation) to function properly, so its prerequisites also apply.

You can install both packages using the following command in the Julia REPL:

```julia
using Pkg; Pkg.add(["IntervalArithmetic", "ThickIntervals"])
```

## Usage

```julia
using ThickIntervals
```

Considering an interval $[a] = [1.5, 3.5]$ with an uncertainty of $\pm 0.5$ in both the lower and upper bound, we can construct a thick interval $\llbracket a \rrbracket = \llbracket [1,2], [3,4] \rrbracket$.

```julia
a = thickinterval(1, 2, 3, 4);
```

Given a second thick interval $\llbracket b \rrbracket = \llbracket [2.25,2.75], [3.33,3.67] \rrbracket$, we can construct it from two intervals as well.

```julia
b = thickinterval(interval(2.25,2.75), interval(3.5,4.5));
```

Currently, the basic arithmetic operations $\{+,-,\cdot,/\}$ are supported by this package, e.g.:

```julia
diff = a - b
# ⟦[-3.5, -1.5], [0.25, 1.75]⟧
```