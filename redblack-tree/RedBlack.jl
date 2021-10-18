module RedBlack

export Tree, RB, E, insert, contains, show, size, minimum, maximum, between, delete_min

abstract type Tree{T} end
abstract type RB{T} <: Tree{T} end

# A tree is either an empty tree, or a key with left and right sub-trees
struct E{T} <: RB{T} end

struct NE{T, C} <: RB{T} where {C}
    key::T
    left::Union{E{T}, NE{T, :red}, NE{T, :black}}
    right::Union{E{T}, NE{T, :red}, NE{T, :black}}
end

Black{T} = NE{T, :black} where {T}
Red{T} = NE{T, :red} where {T}

Red(key::T, left::Union{E{T}, Black{T}}, right::Union{E{T}, Black{T}}) where {T} = NE{T, :red}(key, left, right)
Black(key::T, left::Union{E{T}, NE{T}}, right::Union{E{T}, NE{T}}) where {T} = NE{T, :black}(key, left, right)

# convenience:
is_empty(::E{T}) where {T} = true
is_empty(::NE{T}) where {T} = false

is_red(::E) = false
is_red(tree::Red) = true
is_red(tree::Black) = false

include("contains.jl")
include("insert.jl")
include("delmin.jl")
include("range-ops.jl")
include("helpers.jl")

end
