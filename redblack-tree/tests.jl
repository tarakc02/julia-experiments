module RedBlackTests

using Test
include("RedBlack.jl")
using .RedBlack
import .RedBlack.NonEmpty, .RedBlack.is_empty, .RedBlack.size

function is_balanced(t::NonEmpty{T, C}) where {T, C}
    black_height(t.left) == black_height(t.right)
end

black_height(::E{T}) where {T} = 1

function black_height(t::NonEmpty{T, true}) where {T} 
    bhl = black_height(t.left)
    bhr = black_height(t.right)
    bhl == bhr || throw("unbalanced subtree")
    return bhl
end

function black_height(t::NonEmpty{T, false}) where {T}
    bhl = black_height(t.left)
    bhr = black_height(t.right)
    bhl == bhr || throw("unbalanced subtree")
    return 1 + bhl
end

is_bst(::E{T}) where {T} = true
function is_bst(t::RB{T}) where {T}
    is_bst(t.left) || return false
    is_bst(t.right) || return false
    !is_empty(t.left) && t.left.key >= t.key && return false
    !is_empty(t.right) && t.right.key <= t.key && return false
    return true
end

is_redblack(::E{T}) where{T} = true

is_black(::E{T}) where {T} = true
is_black(::NonEmpty{T, false}) where {T} = true
is_black(::NonEmpty{T, true}) where {T} = false

function is_redblack(t::NonEmpty{T, true}) where {T}
    is_black(t.left)  || return false
    is_black(t.right) || return false
    is_redblack(t.left) && is_redblack(t.right)
end

function is_redblack(t::NonEmpty{T, false}) where {T}
    is_redblack(t.left) && is_redblack(t.right)
end

function array2tree(x::Array{T, 1}) where {T}
    tree = E{T}()
    for element in x
        tree = insert(tree, element)
    end
    return tree
end

function rand_tree(size)
    tree = E{Int64}()
    for x in rand(Int64, size)
        tree = insert(tree, x)
    end
    return tree
end

@testset "insert elements" begin
    inorder = array2tree(collect(1:5))
    backward = array2tree(reverse(collect(1:5)))
    random = rand_tree(10)

    @test size(inorder) == 5
    @test size(backward) == 5
    @test size(random) == 10

    @test contains(inorder, 1)
    @test contains(inorder, 2)
    @test contains(inorder, 3)
    @test contains(inorder, 4)
    @test contains(inorder, 5)

    @test contains(backward, 1)
    @test contains(backward, 2)
    @test contains(backward, 3)
    @test contains(backward, 4)
    @test contains(backward, 5)

    inorder2 = insert(inorder, 6)
    @test !contains(inorder, 6)
    @test contains(inorder2, 6)

    backward2 = insert(backward, 6)
    @test !contains(backward, 6)
    @test contains(backward2, 6)
end

@testset "range operators" begin
    inorder = array2tree(collect(1:10))
    backward = array2tree(reverse(collect(1:10)))

    @test [el for el in between(inorder, 3, 5)] == [3, 4, 5]
    @test [el for el in between(backward, 6, 9)] == [6, 7, 8, 9]
end

@testset "maintain ordering" begin
    inorder = array2tree(collect(1:10))
    backward = array2tree(reverse(collect(1:10)))
    random = rand_tree(10)

    @test is_bst(inorder)
    @test is_bst(backward)
    @test is_bst(random)
end

@testset "maintain black balance" begin
    inorder = array2tree(collect(1:10))
    backward = array2tree(reverse(collect(1:10)))
    random = rand_tree(10)

    @test is_balanced(inorder)
    @test is_balanced(backward)
    @test is_balanced(random)
end

@testset "no red-red violations" begin
    inorder = array2tree(collect(1:10))
    backward = array2tree(reverse(collect(1:10)))
    random = rand_tree(10)

    @test is_redblack(inorder)
    @test is_redblack(backward)
    @test is_redblack(random)
end

end
