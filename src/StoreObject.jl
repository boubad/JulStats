module BaseObject
# ===============
include("InfoDomain.jl")
# ==================
using .InfoDomain
# =====================
export StoreObject
# =============
struct StoreObject
    id::String
    rev::String
    doctype::String
    function StoreObject(; id::String="", rev::String="", doctype::String="")
        new(id, rev, doctype)
    end
end
# =============
# end module
end
