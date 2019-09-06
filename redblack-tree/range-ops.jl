import Base.maximum, Base.minimum
import DataStructures.Queue, DataStructures.enqueue!

function minimum(tree::NonEmpty{T, C}) where {T, C}
    is_empty(tree.left) && return tree.key
    # this would probably be a tad faster with a while loop, but bleh
    return minimum(tree.left)
end

function maximum(tree::NonEmpty{T, C}) where {T, C}
    is_empty(tree.right) && return tree.key
    return maximum(tree.right)
end

function between(tree::NonEmpty{T, C}, lo::T, hi::T) where {T, C}
    queue = Queue{T}()
    fill(queue, tree, lo, hi)
    return queue
end

function fill(q::Queue{T}, tree::NonEmpty{T, C}, lo::T, hi::T) where {T, C}
    lo < tree.key && fill(q, tree.left, lo, hi)
    lo <= tree.key && hi >= tree.key && enqueue!(q, tree.key)
    hi > tree.key && fill(q, tree.right, lo, hi)
end

fill(::Queue{T}, ::E{T}, ::T, ::T) where {T} = nothing

#struct RBRange{T, C}
#    tree::NonEmpty{T, C}
#    lo::T
#    hi::T
#end
#
#first_in_range(::E{T}, ::T, ::T) where {T} = nothing
#
#function first_in_range(tree::NonEmpty{T, C}, lo::T, hi::T) where {T, C}
#    lo > tree.key && return first_in_range(tree.right)
#    hi < tree.key && return first_in_range(tree.left)
#
#    # now the root of tree is within [lo, hi]
#    # this finds the smallest element in [lo, hi]
#    tmp = tree
#    while !is_empty(tmp.left) && tmp.left.key >= lo
#        tmp = tmp.left
#    end
#    
#end
#
#
#function Base.iterate(iter::RBRange{T}) where {T}
#    tree = iter.tree
#    while iter.lo > tree.key
#        is_empty(tree) && return nothing
#        tree = tree.left
#    end
#    while iter.hi < tree.key
#        is_empty(tree) && return nothing
#        tree = tree.right
#    end
#
#    if tree.left.key >= lo
#
#    state = tree, iter.lo, iter.hi
#
#
#function Base.iterate(iter::RBRange, state=(iter.start, 0))
#    element, count = state
#
#    if count >= iter.length
#        return nothing
#    end
#
#    return (element, (element + iter.n, count + 1))
#end
