module BaseObject
# ===============
include("InfoDomain.jl")
# ==================
using .InfoDomain
# =====================
export StoreObject
# =============
mutable struct StoreObject
    id::String
    rev::String
    doctype::String
    function StoreObject(; id::String="", rev::String="", doctype::String="")
        new(id, rev, doctype)
    end
end
# =============
function fill_storeobject(p::StoreObject, d::Dict{String,Any})
    p.id = haskey(d, InfoDomain.field_id) ? d[InfoDomain.field_id] : ""
    p.rev = haskey(d, InfoDomain.field_rev) ? d[InfoDomain.field_rev] : ""
    p.doctype = haskey(d, InfoDomain.field_doctype) ? d[InfoDomain.field_doctype] : ""
    return p
end
# ==============
# end module
end
