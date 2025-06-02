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
    observations::String
    function StoreObject(id::String, rev::String, doctype::String, observations::String)
        new(id, rev, doctype, observations)
    end
end
# ==============
function dicttostoreobject(d::Dict{String,Any})
    id = haskey(d, InfoDomain.field_id) ? d[InfoDomain.field_id] : ""
    rev = haskey(d, InfoDomain.field_rev) ? d[InfoDomain.field_rev] : ""
    doctype = haskey(d, InfoDomain.field_doctype) ? d[InfoDomain.field_doctype] : ""
     observations = haskey(d, InfoDomain.field_observations) ? d[InfoDomain.field_observations] : ""
    return 
end
# ==============
# end module
end
