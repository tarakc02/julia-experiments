Base.size(::E) = 0
Base.size(t::NE) = 1 + size(t.left) + size(t.right)

# for convenience, a very basic print method
import Base.string

function string(tree::Tree{Int64}, indent = 0)
    treestr =  string(tree.key) * "\n"
    treestr *= repeat(" ", indent) * "|-" * string(tree.left, indent + 2)
    treestr *= repeat(" ", indent) * "|-" * string(tree.right, indent + 2)
    return treestr
end
string(::E{Int64}, indent = 0) = "\n"

import Base.show
Base.show(tree::Tree{T}) where {T} = print(string(tree))
