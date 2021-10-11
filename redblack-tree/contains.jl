Base.contains(::E{T}, ::T) where {T} = false
function Base.contains(tree::RB{T}, key::T) where {T}
    key <  tree.key && return contains(tree.left, key)
    key >  tree.key && return contains(tree.right, key)
    return true
end
