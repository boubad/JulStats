# include("InfoDomain.jl")
# ====================
# using .InfoDomain
# ===========================
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
# ====================
function create_statitemobject(d::Dict{String,Any})::StatItemObject
    id = haskey(d, InfoDomain.field_id) ? d[InfoDomain.field_id] : ""
    rev = haskey(d, InfoDomain.field_rev) ? d[InfoDomain.field_rev] : ""
    datasetid = haskey(d, InfoDomain.field_datasetid) ? d[InfoDomain.field_datasetid] : ""
    name = haskey(d, InfoDomain.field_name) ? d[InfoDomain.field_name] : ""
    data = haskey(d, InfoDomain.field_data) ? d[InfoDomain.field_data] : Dict{String,Any}()
    observations = haskey(d, InfoDomain.field_observations) ? d[InfoDomain.field_observations] : ""
    return StatItemObject(id=id, rev=rev, datasetid=datasetid, name=name, data=data, observations=observations)
end
# =====================
export StatItemObject
# ===================
