Base.contains(::E{T}, ::T) where {T} = false
Base.contains(::E{T}, key::T, sentinel::T) where {T} = isequal(key, sentinel)
function Base.contains(tree::RB{T}, key::T) where {T}
    key <  tree.key && return contains(tree.left, key)
    contains(tree.right, key, tree.key)
end
function Base.contains(tree::RB{T}, key::T, sentinel::T) where {T}
    key <  tree.key && return contains(tree.left, key, sentinel)
    contains(tree.right, key, tree.key)
end

