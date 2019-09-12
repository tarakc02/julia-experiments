function delmin(t::NonEmpty{T, true}) where {T}
    is_empty(t.left) && return t.right
    if is_empty(t.left.left) && is_red(t.left.right)
        return Red(t.key,
                   Black(t.left.right.key, E{T}(), E{T}()),
                   t.right)
    elseif is_empty(t.left.left) && is_empty(t.right.left)
        b = Red(t.key, E{T}(), E{T}())
        return Black(t.right.key, b, t.right.right)
    elseif is_empty(t.left.left) && is_red(t.right.left)
        b = Black(t.key, t.left.right, E{T}())
        d = Black(t.right.key, E{T}(), t.right.right)
        return Red(t.right.left.key, b, d)
    elseif is_red(t.left.left)
        a = delmin(t.left.left)
        b = Black(t.left.key, a, t.left.right)
        return Red(t.key, b, t.right)
    elseif is_red(t.right.left) && !is_red(t.left.right)
        a = delmin(Red(t.left.key,
                       turn_black(t.left.left),
                       turn_black(t.left.right)))
        b = Black(t.key, a, t.right.left.left)
        d = Black(t.right.key, t.right.left.right, t.right.right)
        return Red(t.right.left.key, b, d)
    elseif !is_red(t.left.right)
        b = delmin(Red(t.left.key, t.left.left, t.left.right))
        if is_red(b) return Red(t.key, turn_black(b), t.right) end
        d = Red(t.key, b, t.right.left)
        return Black(t.right.key, d, t.right.right)
    else
        b = delmin(Red(t.left.key,
                       t.left.left,
                       t.left.right.left))
        d = Black(t.left.right.key,
                  b,
                  t.left.right.right)
        return Red(t.key, d, t.right)
    end
end

function delete_min(t::NonEmpty{T, false}) where {T}
    if is_empty(t.left)
        is_empty(t.right) && return E{T}()
        return turn_black(t.right)
    end

    is_red(t.left) && return Black(t.key, delmin(t.left), t.right)

    if !is_red(t.right)
        res = delmin(Red(t.key, t.left, t.right))
        return turn_black(res)
    end

    b = Red(t.key, t.left, t.right.left)
    return Black(t.right.key,
                 delmin(b),
                 t.right.right)
end
