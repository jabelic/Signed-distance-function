# The Signed distance function

[![Build Status](https://travis-ci.com/jabelic/SignedDistanceFunction.jl.svg?branch=main)](https://travis-ci.com/jabelic/SignedDistanceFunction.jl)
[![Coverage](https://codecov.io/gh/jabelic/SignedDistanceFunction.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jabelic/SignedDistanceFunction.jl)
[![Coverage](https://coveralls.io/repos/github/jabelic/SignedDistanceFunction.jl/badge.svg?branch=main)](https://coveralls.io/github/jabelic/SignedDistanceFunction.jl?branch=main)


SignedDistanceFunction.jl is a package to compute signed distance function.

Main features are:

- Creating a signed distance to compute the signed distance function of the jordan closed curve data set(2D).
- Creating a signed distance to compute the signed distance function of the multiple closed curve data set(2D).

<!-- レベルセット法のためのレベルセット関数を計算する際に初期値として必要な付合付き距離関数を閉曲線データから提供する。 -->

## Usage

The closed curve data must be

`signedDistance2D("XXXXXX.csv", N)`

`signedDistance2D("XXXXXX.csv", N, "multi")`


## images

<img src="./test/image/2x2interface_multicurves_multiprocess_300.png" width=50%><img src="./test/image/2x2multiple_curves_multicurves_multiprocess_300.png" width=50%>

## Contribution

### Setup

#### macOS

`$ make initial`

or

`$ julia>`  
`$ Pkg(1.5)> add PackageCompiler`  
`$ Pkg(1.5)> add DelimitedFiles`  
`$ Pkg(1.5)> add TimerOutputs`  
`$ Pkg(1.5)> add Test`  
`$ Pkg(1.5)> add Plots`  
`$ julia> using PackageCompiler`  
`$ julia> PackageCompiler.create_sysimage([:CSV, :DataFrames, :Plots, :Luxor, :BenchmarkTools, :TimerOutputs, :Test]; sysimage_path="Sysimage.so")`  
`$ Pkg(1.5)> activate .`  
`$ (SignedDistanceFunction)>`  
`$ julia> using SignedDistanceFunction`  
`$ julia> signedDistance2D("xxxxxx.csv", N)`  



### Debug in REPL

`$julia>`

enter the Pgk mode(`]`)

`$ pkg>`

`$ pkg> activate .`

`(SignedDistanceFunction) pkg>`

return the REPL(`Delete/Backspace`)

`julia> `

`julia> using SignedDistanceFunction`

`julia> signedDistance2D("XXXXXX.csv", N)`

<!-- Plots sample data: 

`julia> using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools`

`julia> gamma = readdlm("data.csv", ',', Float64)`

`julia> plot(gamma[:, 1], gamma[:, 2], st=:scatter, title="infty_shape", markersize=2, grid=false)` 

`julia>  savefig("interface.png") -->
