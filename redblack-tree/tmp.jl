include("RedBlack.jl")
using .RedBlack
using .RedBlack: turn_black, ins, Black, Red

using BenchmarkTools    

x = Black(1533, E{Int64}(), E{Int64}())
y = Red(1533, E{Int64}(), E{Int64}())
@code_warntype Base.getproperty(x, :key)

tree0 = E{Int64}()
res = ins(tree0, -15379)
@benchmark tree0 = E{Int64}()
@benchmark insert(tree0, -15379)

function rand_tree(size)
    tree = E{Int64}()
    for x in rand(Int64, size)
        tree = insert(tree, x)
    end
    return tree
end

tree1 = rand_tree(1_000);
tree2 = rand_tree(10_000);
tree3 = rand_tree(100_000);
tree4 = rand_tree(1_000_000);
tree5 = rand_tree(10_000_000);

# in under a minute!
@time tree5 = rand_tree(10_000_000);

@benchmark contains($tree1, -9192346102151)
@benchmark insert($tree1, 9192346102151525322)
@benchmark insert($tree4, $rand(Int64))

