# to preserve balance, use red and black nodes
# note that the color is a type parameter
function Red(key::T, left::RB{T}, right::RB{T}) where{T}
    NonEmpty{T, true}(key, left, right)
end

function Black(key::T, left::RB{T}, right::RB{T}) where {T}
    NonEmpty{T, false}(key, left, right)
end

is_red(::E{T}) where {T} = false
is_red(tree::NonEmpty{T, true}) where {T} = true
is_red(tree::NonEmpty{T, false}) where {T} = false

# convenience function -- returns a copy of a tree, but root painted black
function turn_black(t::NonEmpty{T, true}) where {T}
    NonEmpty{T, false}(t.key, t.left, t.right)
end
turn_black(t::NonEmpty{T, false}) where {T} = t

ins(::E{T}, key::T) where {T} = Red(key, E{T}(), E{T}())
function ins(t::NonEmpty{T, true}, key::T) where {T}
    key < t.key && return Red(t.key, ins(t.left, key), t.right)
    key > t.key && return Red(t.key, t.left, ins(t.right, key))
    return t
end
function ins(t::NonEmpty{T, false}, key::T) where {T}
    key < t.key && return lbalance(t.key, ins(t.left, key), t.right)
    key > t.key && return rbalance(t.key, t.left, ins(t.right, key))
    return t
end

function insert(tree::RB{T}, key::T) where {T}
    res = ins(tree, key)
    turn_black(res)
end

function lbalance(key::T, left::NonEmpty{T, true}, right::RB{T}) where {T}
    if is_red(left.left)
        x = turn_black(left.left)
        z = Black(key, left.right, right)
        return Red(left.key, x, z)
    end
    if is_red(left.right)
        x = Black(left.key, left.left, left.right.left)
        z = Black(key, left.right.right, right)
        return Red(left.right.key, x, z)
    end
    return Black(key, left, right)
end
lbalance(key::T, left::RB{T}, right::RB{T}) where {T} = Black(key, left, right)

function rbalance(key::T, left::RB{T}, right::NonEmpty{T, true}) where {T}
    if is_red(right.right)
        x = Black(key, left, right.left)
        z = turn_black(right.right)
        return Red(right.key, x, z)
    end
    if is_red(right.left)
        x = Black(key, left, right.left.left)
        z = Black(right.key, right.left.right, right.right)
        return Red(right.left.key, x, z)
    end
    return Black(key, left, right)
end
rbalance(key::T, left::RB{T}, right::RB{T}) where {T} = Black(key, left, right)

# done.
