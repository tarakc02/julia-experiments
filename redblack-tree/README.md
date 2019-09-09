## Background/introduction

I'd like to implement a set-like data structure using a red-black binary tree. It should support the following methods efficiently:

- `insert(set, element)` returns a new set, which contains all elements of `set`, plus the new `element`. However, it should not modify `set`.
- `contains` returns `true` or `false` based on whether an element is present in the set
- `minimum` and `maximum` return the minimum and maximum element
- `between` returns an iterator of elements between a low and high value (in ascending order)

The constraint that I can't modify the set during `insert`s means I'll have a persistent data structure. But to still be efficient, I can't just be making deep copies of a set every time I want to insert a new element.

## Examples

Trees are built by starting with an empty tree, and then `insert`ing elements one at a time. I'll use a convenience function to create random trees:

```julia
include("RedBlack.jl")
using .RedBlack

function array2tree(x::Array{T, 1}) where {T}
    tree = E{T}()
    for element in x
        tree = insert(tree, element)
    end
    return tree
end
```

To demonstrate the persistence, compare what happens when I insert into a tree-based set vs. when I try to insert into a `Base.Set`:

```julia
julia> test = [x for x in 1:10]
10-element Array{Int64,1}:
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10

julia> set = Set(test)
Set([7, 4, 9, 10, 2, 3, 5, 8, 6, 1])

julia> tr  = array2tree(test);

julia> in(9, set)
true

julia> in(11, set)
false

julia> contains(tr, 9)
true

julia> contains(tr, 11)
false

julia> tr2 = tr;

julia> tr2 = insert(tr2, 11);

julia> contains(tr, 11)
false

julia> contains(tr2, 11)
true

## compare to:
julia> set2 = set
Set([7, 4, 9, 10, 2, 3, 5, 8, 6, 1])

julia> push!(set2, 11);

julia> in(11, set)
true
```
Modifying `set2` also modified `set`, since they both point to the same mutable object. But modifying `tr2` did nothing to `tr`.

Range operators work as expected:

```julia
demo_array = [8, 39, 96, 9, 87, -36, -36, -86, -14, -58]
demo_tree = array2tree(demo_array)

julia> minimum(demo_tree)
-86

julia> maximum(demo_tree)
96

julia> [element for element in between(demo_tree, 25, 100)]
3-element Array{Int64,1}:
 39
 87
 96
```
## Tests

```julia
julia> include("tests.jl")
Test Summary:   | Pass  Total
insert elements |   17     17
Test Summary:   | Pass  Total
range operators |    2      2
Test Summary:     | Pass  Total
maintain ordering |    3      3
Test Summary:          | Pass  Total
maintain black balance |    3      3
Test Summary:         | Pass  Total
no red-red violations |    3      3
```

## Some benchmarking

These tests are all using an element that did not exist in any of the constructed trees. Note that each tree is 10 times as large as the previous tree, but the median time for a search miss grows much more slowly.

```julia
julia> using BenchmarkTools    

julia> function rand_tree(size)
           tree = E{Int64}()
           for x in rand(Int64, size)
               tree = insert(tree, x)
           end
       return tree
       end

julia> tree1 = rand_tree(1_000);
julia> tree2 = rand_tree(10_000);
julia> tree3 = rand_tree(100_000);
julia> tree4 = rand_tree(1_000_000);
julia> tree5 = rand_tree(10_000_000);

julia> @benchmark contains(tree1, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  128 bytes
  allocs estimate:  8
  --------------
  minimum time:     189.498 ns (0.00% GC)
  median time:      203.110 ns (0.00% GC)
  mean time:        209.095 ns (1.15% GC)
  maximum time:     1.066 μs (79.34% GC)
  --------------
  samples:          10000
  evals/sample:     651

julia> @benchmark contains(tree2, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  256 bytes
  allocs estimate:  16
  --------------
  minimum time:     336.326 ns (0.00% GC)
  median time:      354.719 ns (0.00% GC)
  mean time:        369.406 ns (1.77% GC)
  maximum time:     3.982 μs (88.70% GC)
  --------------
  samples:          10000
  evals/sample:     221

julia> @benchmark contains(tree3, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  272 bytes
  allocs estimate:  17
  --------------
  minimum time:     367.316 ns (0.00% GC)
  median time:      387.757 ns (0.00% GC)
  mean time:        402.289 ns (1.23% GC)
  maximum time:     3.029 μs (86.81% GC)
  --------------
  samples:          10000
  evals/sample:     206

julia> @benchmark contains(tree4, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  288 bytes
  allocs estimate:  18
  --------------
  minimum time:     381.722 ns (0.00% GC)
  median time:      385.371 ns (0.00% GC)
  mean time:        407.073 ns (1.48% GC)
  maximum time:     4.452 μs (88.71% GC)
  --------------
  samples:          10000
  evals/sample:     205

julia> @benchmark contains(tree5, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  368 bytes
  allocs estimate:  23
  --------------
  minimum time:     484.251 ns (0.00% GC)
  median time:      523.136 ns (0.00% GC)
  mean time:        542.798 ns (1.53% GC)
  maximum time:     4.650 μs (86.05% GC)
  --------------
  samples:          10000
  evals/sample:     195
```

And for inserts (same test). Here I'm interested in the amount of memory used for each insert, which again should grow logarithmically.

```julia
julia> @benchmark insert(tree1, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  512 bytes
  allocs estimate:  21
  --------------
  minimum time:     678.977 ns (0.00% GC)
  median time:      751.395 ns (0.00% GC)
  mean time:        1.193 μs (34.91% GC)
  maximum time:     177.399 μs (99.51% GC)
  --------------
  samples:          10000
  evals/sample:     133

julia> @benchmark insert(tree2, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  960 bytes
  allocs estimate:  39
  --------------
  minimum time:     1.220 μs (0.00% GC)
  median time:      1.506 μs (0.00% GC)
  mean time:        2.273 μs (32.33% GC)
  maximum time:     1.919 ms (99.90% GC)
  --------------
  samples:          10000
  evals/sample:     10

julia> @benchmark insert(tree3, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  944 bytes
  allocs estimate:  39
  --------------
  minimum time:     1.286 μs (0.00% GC)
  median time:      1.636 μs (0.00% GC)
  mean time:        2.396 μs (30.13% GC)
  maximum time:     1.909 ms (99.86% GC)
  --------------
  samples:          10000
  evals/sample:     10

julia> @benchmark insert(tree4, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  992 bytes
  allocs estimate:  41
  --------------
  minimum time:     1.204 μs (0.00% GC)
  median time:      1.527 μs (0.00% GC)
  mean time:        2.276 μs (31.09% GC)
  maximum time:     1.882 ms (99.90% GC)
  --------------
  samples:          10000
  evals/sample:     10

julia> @benchmark insert(tree5, 9192346102151525322)
BenchmarkTools.Trial:
  memory estimate:  1.20 KiB
  allocs estimate:  51
  --------------
  minimum time:     1.508 μs (0.00% GC)
  median time:      1.819 μs (0.00% GC)
  mean time:        2.751 μs (32.17% GC)
  maximum time:     1.904 ms (99.88% GC)
  --------------
  samples:          10000
  evals/sample:     10
```

