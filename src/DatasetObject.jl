# ===========================
export DatasetObject
# ===================
using .InfoDomain
using .BaseObject
# =======================
struct DatasetObject
    storeobject::StoreObject
    name::String
    sigle::String
    variables::Vector{String}
    observations::String
    function DatasetObject(; id::String="", rev::String="", doctype::String=InfoDomain.doctype_dataset,
        name::String="", sigle::String="", variables::Vector{String}=Vector{String}(), observations::String="")
        return new(StoreObject(id=id, rev=rev, doctype=doctype), name, sigle, variables, observations)
    end
end
# =======================