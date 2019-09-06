module RedBlack

export Tree, RB, E, insert, contains, show, size, minimum, maximum, between

abstract type Tree{T} end
abstract type RB{T} <: Tree{T} end

# A tree is either an empty tree, or a key with left and right sub-trees
struct E{T} <: RB{T} end

struct NonEmpty{T, C} <: RB{T}
    key::T
    left::RB{T}
    right::RB{T}
end

# convenience:
is_empty(::E{T}) where {T} = true
is_empty(::NonEmpty{T, C}) where {T, C} = false

include("contains.jl")
include("insert.jl")
include("range-ops.jl")
include("helpers.jl")

end
