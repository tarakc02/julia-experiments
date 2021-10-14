# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:

# during insertion, temporarily allow a single red-red violation {{{
struct RedViolL{T}
    key::T
    left::Red{T}
    right::Union{E{T}, Black{T}}
end

struct RedViolR{T}
    key::T
    left::Union{E{T}, Black{T}}
    right::Red{T}
end

RedViol{T} = Union{RedViolL{T}, RedViolR{T}} where {T}

function Red(key::T, left::Red{T}, right::Union{E{T}, Black{T}}) where {T}
    RedViolL(key, left, right)
end

function Red(key::T, left::Union{E{T}, Black{T}}, right::Red{T}) where {T}
    RedViolR(key, left, right)
end

# convenience function -- returns a copy of a tree, but root painted black
function turn_black(t::Red{T}) where {T}
    Black(t.key, t.left, t.right)
end
function turn_black(t::RedViol{T}) where {T}
    Black(t.key, t.left, t.right)
end
turn_black(t::Black{T}) where {T} = t
# }}}

function insert(tree::RB{T}, key::T) where {T}
    res = ins(tree, key)
    turn_black(res)
end

ins(::E{T}, key::T) where {T} = Red(key, E{T}(), E{T}())
function ins(t::Red{T}, key::T) where {T}
    key < t.key && return Red(t.key, ins(t.left, key), t.right)
    key > t.key && return Red(t.key, t.left, ins(t.right, key))
    return t
end
function ins(t::Black{T}, key::T) where {T}
    key < t.key && return balance(t.key, ins(t.left, key), t.right)
    key > t.key && return balance(t.key, t.left, ins(t.right, key))
    return t
end

balance(key::T, left::RB{T}, right::RB{T}) where {T} = Black(key, left, right)

function balance(key::T, left::RedViolL{T}, right::RB{T}) where {T}
    x = turn_black(left.left)
    z = Black(key, left.right, right)
    Red(left.key, x, z)
end

function balance(key::T, left::RedViolR{T}, right::RB{T}) where {T}
    x = Black(left.key, left.left, left.right.left)
    z = Black(key, left.right.right, right)
    Red(left.right.key, x, z)
end

function balance(key::T, left::RB{T}, right::RedViolL{T}) where {T}
    x = Black(key, left, right.left.left)
    z = Black(right.key, right.left.right, right.right)
    Red(right.left.key, x, z)
end

function balance(key::T, left::RB{T}, right::RedViolR{T}) where {T}
    x = Black(key, left, right.left)
    z = turn_black(right.right)
    Red(right.key, x, z)
end

# done.
