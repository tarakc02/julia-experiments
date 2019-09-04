## Functions

Functions work basically the way you think they would:

```
julia> function add(x, y)
           return x + y
       end
add (generic function with 1 method)

julia> add(1, 2)
3
```

The return value of a function is the value of the last evaluated expression in the function, so you could just do:

```
function add(x, y)
    x + y
end
```

There's a compact form for short function definitions:

```
julia> add(x, y) = x + y
add (generic function with 1 method)

julia> add(1, 2)
3
```

Note that the longer form doesn't use curly brackets. This is also true more generally -- blocks of code are encapsulated in `begin` and `end` instead of brackets. For things like functions, loops, and conditionals, the keyword does the same job as `begin`. Also you don't have to use a lot of parentheses that you'd find in other languages:

```
f = function(x)
    if x < 5
        print("abcd\n")
    elseif x < 10
        print("efgh\n")
    else
        print("xyz\n")
    end

    while x > 0
        print(x, "\n")
        x -= 1
    end
end
```

Functions can be composed (notice evaluation is from right to left, as in mathematics):

```
f(x) = 2x
g(x) = x + 7
h = f ∘ g

julia> h(1)
16
```

You can make anonymous functions:

```
# this
x -> 2x + 7

# is the same as
function(x) 2x + 7 end

# so you can do:
julia> (x -> 2x + 7)(3)
13

# but more likely you  want to pass the anon. function to something else:
julia> map(x -> 2x + 8, [1, 2, 3])
3-element Array{Int64,1}:
 10
 12
 14
```

You can pipe functions together using the `|>` operator:

```
julia> rand(10) |> sum |> round
5.0
```

## Packages

To use a package, either:

```
import PkgName
PkgName.pkgfunction(...)
```

or to bring stuff into your namespace:

```
using PkgName
pkgfunction(...)
```

or:

```
import PkgName.pkgfunction
pkgfunction(...)
```

or:

```
import PkgName: func1, func2
func1(...)
func2(...)
```

To install a package:

```
import Pkg
Pkg.add("PkgName")
```

## Reading tabular data

Use the `CSV` package to import delimited data as a `DataFrame`:

```
julia> import CSV

julia> mtcars = CSV.read("mtcars.csv", delim = "|")
32×11 DataFrames.DataFrame. Omitted printing of 3 columns
│ Row │ mpg     │ cyl   │ disp    │ hp    │ drat    │ wt      │ qsec    │ vs    │
│     │ Float64 │ Int64 │ Float64 │ Int64 │ Float64 │ Float64 │ Float64 │ Int64 │
├─────┼─────────┼───────┼─────────┼───────┼─────────┼─────────┼─────────┼───────┤
│ 1   │ 21.0    │ 6     │ 160.0   │ 110   │ 3.9     │ 2.62    │ 16.46   │ 0     │
│ 2   │ 21.0    │ 6     │ 160.0   │ 110   │ 3.9     │ 2.875   │ 17.02   │ 0     │
│ 3   │ 22.8    │ 4     │ 108.0   │ 93    │ 3.85    │ 2.32    │ 18.61   │ 1     │
⋮
│ 29  │ 15.8    │ 8     │ 351.0   │ 264   │ 4.22    │ 3.17    │ 14.5    │ 0     │
│ 30  │ 19.7    │ 6     │ 145.0   │ 175   │ 3.62    │ 2.77    │ 15.5    │ 0     │
│ 31  │ 15.0    │ 8     │ 301.0   │ 335   │ 3.54    │ 3.57    │ 14.6    │ 0     │
│ 32  │ 21.4    │ 4     │ 121.0   │ 109   │ 4.11    │ 2.78    │ 18.6    │ 1     │
```

## Working with tabular data

The `DataFrames` package provides a `DataFrame` along with the usual methods to index, etc:

```
julia> using DataFrames

julia> mtcars[1:10, 2:3]
10×2 DataFrames.DataFrame
│ Row │ cyl   │ disp    │
│     │ Int64 │ Float64 │
├─────┼───────┼─────────┤
│ 1   │ 6     │ 160.0   │
│ 2   │ 6     │ 160.0   │
│ 3   │ 4     │ 108.0   │
⋮
│ 7   │ 8     │ 360.0   │
│ 8   │ 4     │ 146.7   │
│ 9   │ 4     │ 140.8   │
│ 10  │ 6     │ 167.6   │

```

## Query.jl

[Query.jl](https://github.com/queryverse/Query.jl) looks like a useful package, is based on LINQ and provides a set of `dplyr`-like tools for manipulating stuff:

```
julia> using Query

julia> mtcars |> @filter(_.mpg <= 20)
?x11 query result
mpg  │ cyl │ disp  │ hp  │ drat │ wt    │ qsec  │ vs │ am │ gear │ carb
─────┼─────┼───────┼─────┼──────┼───────┼───────┼────┼────┼──────┼─────
18.7 │ 8   │ 360.0 │ 175 │ 3.15 │ 3.44  │ 17.02 │ 0  │ 0  │ 3    │ 2
18.1 │ 6   │ 225.0 │ 105 │ 2.76 │ 3.46  │ 20.22 │ 1  │ 0  │ 3    │ 1
14.3 │ 8   │ 360.0 │ 245 │ 3.21 │ 3.57  │ 15.84 │ 0  │ 0  │ 3    │ 4
19.2 │ 6   │ 167.6 │ 123 │ 3.92 │ 3.44  │ 18.3  │ 1  │ 0  │ 4    │ 4
17.8 │ 6   │ 167.6 │ 123 │ 3.92 │ 3.44  │ 18.9  │ 1  │ 0  │ 4    │ 4
16.4 │ 8   │ 275.8 │ 180 │ 3.07 │ 4.07  │ 17.4  │ 0  │ 0  │ 3    │ 3
17.3 │ 8   │ 275.8 │ 180 │ 3.07 │ 3.73  │ 17.6  │ 0  │ 0  │ 3    │ 3
15.2 │ 8   │ 275.8 │ 180 │ 3.07 │ 3.78  │ 18.0  │ 0  │ 0  │ 3    │ 3
10.4 │ 8   │ 472.0 │ 205 │ 2.93 │ 5.25  │ 17.98 │ 0  │ 0  │ 3    │ 4
10.4 │ 8   │ 460.0 │ 215 │ 3.0  │ 5.424 │ 17.82 │ 0  │ 0  │ 3    │ 4
... with more rows

```

Intriguingly, Query.jl is very general -- the functions it provides operate on any iterator (!). The reason it works well with `DataFrames` is that it reads them as iterators of named tuples. But:

```
# note that rand returns an array:
julia> rand(5)
5-element Array{Float64,1}:
 0.19325862925795967
 0.5503691006659563
 0.819985671928015
 0.9733686511568578
 0.6583190262930321

# but I can use it in a Query pipeline, and
# by building named tuples, I end up with a dataframe-like thing

julia> rand(100) |> @map((x = _, y = _ * 2, z = _^2)) |> @filter(_.x > .7)
?x3 query result
x        │ y       │ z
─────────┼─────────┼─────────
0.835986 │ 1.67197 │ 0.698873
0.958256 │ 1.91651 │ 0.918254
0.965571 │ 1.93114 │ 0.932328
0.879554 │ 1.75911 │ 0.773615
0.886284 │ 1.77257 │ 0.785499
0.947475 │ 1.89495 │ 0.897708
0.868287 │ 1.73657 │ 0.753923
0.952133 │ 1.90427 │ 0.906558
0.746858 │ 1.49372 │ 0.557797
0.995759 │ 1.99152 │ 0.991535
... with more rows
```

The underscore (`_`) in both of the above code examples is a shortcut provided by Query.jl and only works inside the provided query functions -- it is a shorthand anonymous function. For instance, `_.x` gets translated to `_ -> _.x`

Also notice that the results are "query results" instead of data frames. Just as every function takes in an iterator, it also returns an iterator. Use `collect` to collect the results into an array, or `DataFrame` to return a data frame:

```
julia> rand(10) |> @map((x = _, y = _ * 2)) |> @filter(_.x > .7) |> DataFrame
2×2 DataFrame
│ Row │ x        │ y       │
│     │ Float64  │ Float64 │
├─────┼──────────┼─────────┤
│ 1   │ 0.861846 │ 1.72369 │
│ 2   │ 0.90432  │ 1.80864 │
```

## Macros

[Macros](https://docs.julialang.org/en/v1/manual/metaprogramming/#man-macros-1) "provide a method to include generated code in the final body of a program." So far, I've noticed they're used routinely in Julia code to provide useful features, such as the underscore expansion in the Query.jl examples above.

## Some other useful data structures

- Dicts: `Dict("key1" => 123, "key2" => 473, ...)`
- Arrays: `[1, 2, 3]`
- Tuples: `(1, 2, 3)`
- Named Tuples: `(a = 1, b = 2, c = 3)`
- Sets: `Set([1, 2, 3])`

Python-ish generators/comprehensions:

```
julia> [2x for x in 1:5]
5-element Array{Int64,1}:
  2
  4
  6
  8
 10

julia> Dict((x => 2x) for x in 1:5)
Dict{Int64,Int64} with 5 entries:
  4 => 8
  2 => 4
  3 => 6
  5 => 10
  1 => 2

julia> mydict[5]
10
```
