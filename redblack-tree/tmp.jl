include("RedBlack.jl")
using .RedBlack

using BenchmarkTools    
using Random: randstring
using DataStructures: SortedSet, startof

# helpers {{{
function randstring_tree(size)
    tree = E{String}()
    for i in 1:size
        x = randstring("AB", 80)
        tree = insert(tree, x)
    end
    return tree
end


function randstring_set(size)
    set = SortedSet{String}()
    for i in 1:size
        x = randstring("AB", 80)
        push!(set, x)
    end
    return set
end
# }}}

tree = randstring_tree(100);
treea = insert(tree, randstring("AB", 80));
Base.summarysize(tree)
Base.summarysize(treea)
Base.summarysize([tree, treea])
set = randstring_set(1_000);

# setup to get baselines {{{
@benchmark k1 < k2 setup=(k1=randstring("AB", 80); k2=randstring("AB", 80))
@benchmark k1 < k2 setup=(k1=rand(Int64); k2=rand(Int64))

@benchmark tree.left.right setup=(tree=randstring_tree(25))

@benchmark isequal(k1, k2) setup=(k1=randstring("AB", 80); k2=randstring("AB", 80))

@benchmark contains(tree, x) setup=(tree = E{String}(); x=randstring("ABCD", 40))
@benchmark x in set setup=(set = SortedSet{String, Base.Order.ForwardOrdering}(); x=randstring("ABCD", 40))

@benchmark contains(tree, x) setup=(tree = randstring_tree(1); x=randstring("AB", 80))
@benchmark x in set setup=(set = randstring_set(1); x=randstring("AB", 80))

# }}}

@benchmark contains(tree, x) setup=(tree = randstring_tree(1000); x=randstring("AB", 80))
@benchmark x in set setup=(set = randstring_set(1000); x=randstring("AB", 80))


@benchmark contains(tree, x) setup=(tree = randstring_tree(256); x=randstring("AB", 80))
@benchmark contains(tree, x) setup=(tree = randstring_tree(512); x=randstring("AB", 80))
@benchmark contains(tree, x) setup=(tree = randstring_tree(1024); x=randstring("AB", 80))
@benchmark contains(tree, x) setup=(tree = randstring_tree(2048); x=randstring("AB", 80))


@benchmark insert(tree, x) setup=(tree = randstring_tree(1_000); x=randstring("AB", 80))
@benchmark insert!(set, x) setup=(set = randstring_set(10_000); x=randstring("AB", 80))


tree = randstring_tree(1_000_000);
tree2 = insert(tree, randstring("AB", 80));
Base.summarysize(tree)
Base.summarysize(tree2)
Base.summarysize((tree, tree2)) - Base.summarysize(tree2)

@benchmark insert(tree, x) setup=(tree = randstring_tree(0); x=randstring("AB", 80))
@benchmark insert(tree, x) setup=(tree = randstring_tree(1); x=randstring("AB", 80))
@benchmark insert(tree, x) setup=(tree = randstring_tree(2); x=randstring("AB", 80))
@benchmark insert(tree, x) setup=(tree = randstring_tree(4); x=randstring("AB", 80))

@benchmark insert(tree, x) setup=(tree = randstring_tree(128); x=randstring("AB", 80))
# alloc: 192 bytes, time: 433ns (min 150)
@benchmark insert(tree, x) setup=(tree = randstring_tree(256); x=randstring("AB", 80))
# alloc: 224 bytes, time:489ns (min 188)
@benchmark insert(tree, x) setup=(tree = randstring_tree(512); x=randstring("AB", 80))
# predicted alloc: 262 bytes, time: 560ns
# actual alloc: 256 bytes, time: 551ns
@benchmark insert(tree, x) setup=(tree = randstring_tree(1024); x=randstring("AB", 80))
# predicted alloc: 294 bytes, time: 634ns
# actual alloc: 288 bytes, time: 645ns
@benchmark insert(tree, x) setup=(tree = randstring_tree(4096); x=randstring("AB", 80))

const bigtree = randstring_tree(1_000_000);
@benchmark insert($bigtree, x) setup=(x=randstring("AB", 80))





# as of 17-Oct, this has min=109ns, median=152ns, mean=155ns, sd=25ns
@benchmark contains(tree, x) setup=(tree = randstring_tree(10_000); x=randstring("AB", 80))
# 4.7ns to compare random pairs of string keys
5 .+ log2(10_000) * 5, 2*log2(10_000) * 5

4.7 + log2(25000) * 4.7, 4.7 + 2*log2(25000) * 4.7
@benchmark contains(tree, x) setup=(tree = randstring_tree(25000); x=randstring("AB", 80))

@benchmark first(set) setup=(set=randstring_set(10_000))
@benchmark minimum(tree) setup=(tree=randstring_tree(10_000))
@benchmark RedBlack.minimum2($tree1)

@benchmark insert($tree1, x) setup=(x=randstring("ABCD", 40))
@benchmark delete_min($tree1)
@benchmark delete_min2($tree1)

