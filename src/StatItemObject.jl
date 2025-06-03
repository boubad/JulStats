# ===========================
export StatItemObject
# ===================
using .InfoDomain
using .BaseObject
# =======================
struct StatItemObject
    storeobject::StoreObject
    datasetid::string
    name::string
    data:::Dict{String,Any}
    observations::String
    function StatItemObject(; id::String="", rev::String="", doctype::String=InfoDomain.doctype_statitem,
        datasetid::String="", name::String="", data::Dict{String,Any}=Dict{String,Any}(), observations::String="")
        return new(StoreObject(id=id, rev=rev, doctype=doctype), datasetid, name, data, observations)
    end
end
# =====================
