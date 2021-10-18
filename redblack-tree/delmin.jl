# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:

function delmin(key::T, left::RB{T}, right::RB{T}) where {T}
    is_empty(left) && return right
    if is_empty(left.left) && is_red(left.right)
        return Red(key,
                   Black(left.right.key, E{T}(), E{T}()),
                   right)
    elseif is_empty(left.left) && is_empty(right.left)
        b = Red(key, E{T}(), E{T}())
        return Black(right.key, b, right.right)
    elseif is_empty(left.left) && is_red(right.left)
        b = Black(key, left.right, E{T}())
        d = Black(right.key, E{T}(), right.right)
        return Red(right.left.key, b, d)
    elseif is_red(left.left)
        a = delmin(left.left.key, left.left.left, left.left.right)
        b = Black(left.key, a, left.right)
        return Red(key, b, right)
    elseif is_red(right.left) && !is_red(left.right)
        a = delmin(left.key, turn_black(left.left), turn_black(left.right))
        b = Black(key, a, right.left.left)
        d = Black(right.key, right.left.right, right.right)
        return Red(right.left.key, b, d)
    elseif !is_red(left.right)
        b = delmin(left.key, left.left, left.right)
        if is_red(b) return Red(key, turn_black(b), right) end
        d = Red(key, b, right.left)
        return Black(right.key, d, right.right)
    else
        b = delmin(left.key,
                    left.left,
                    left.right.left)
        d = Black(left.right.key,
                  b,
                  left.right.right)
        return Red(key, d, right)
    end
end

function delete_min(t::Black{T}) where {T}
    if is_empty(t.left)
        is_empty(t.right) && return E{T}()
        return turn_black(t.right)
    end

    is_red(t.left) && return Black(t.key, delmin(t.left.key, t.left.left, t.left.right), t.right)

    if !is_red(t.right)
        res = delmin(t.key, t.left, t.right)
        return turn_black(res)
    end

    return Black(t.right.key,
                 delmin(t.key, t.left, t.right.left),
                 t.right.right)
end
