module StatObject
# ===========================
include("InfoDomain.jl")
include("StoreObject.jl")
# ====================
export DatasetObject
export StatItemObject
# ===================
using .InfoDomain
using .BaseObject
# =======================
mutable struct DatasetObject
    storeobject::StoreObject
    name::String
    sigle::String
    variables::Vector{String}
    observations::String
    function DatasetObject(; id::String="", rev::String="", doctype::String=InfoDomain.doctype_dataset,
        name::String="", sigle::String="", variables::Vector{String}=Vector{String}(), observations::String="")
        new(StoreObject(id=id, rev=rev, doctype=doctype), name, sigle, variables, observations)
    end
end
# =====
function fill_datasetobject(p::DatasetObject, d::Dict{String,Any})
    p.id = haskey(d, InfoDomain.field_id) ? d[InfoDomain.field_id] : ""
    p.rev = haskey(d, InfoDomain.field_rev) ? d[InfoDomain.field_rev] : ""
    p.doctype = InfoDomaindoctype_dataset
    p.name = haskey(d, InfoDomain.field_name) ? d[InfoDomain.field_name] : ""
    p.sigle = haskey(d, InfoDomain.field_sigle) ? d[InfoDomain.field_sigle] : ""
    p.variables = haskey(d, InfoDomain.field_variables) ? d[InfoDomain.field_variables] : []
    p.observations = haskey(d, InfoDomain.field_observations) ? d[InfoDomain.field_observations] : ""
    return p
end
# =======================
mutable struct StatItemObject
    storeobject::StoreObject
    datasetid::string
    name::string
    data:::Dict{String,Any}
    observations::String
    function StatItemObject(; id::String="", rev::String="", doctype::String=InfoDomain.doctype_statitem,
        datasetid::String="", name::String="", data::Dict{String,Any}=Dict{String,Any}(), observations::String="")
        new(StoreObject(id=id, rev=rev, doctype=doctype), datasetid, name, data, observations)
    end
end
# =======================
function fill_statitemobject(p::StatItemObject, d::Dict{String,Any})
    p.id = haskey(d, InfoDomain.field_id) ? d[InfoDomain.field_id] : ""
    p.rev = haskey(d, InfoDomain.field_rev) ? d[InfoDomain.field_rev] : ""
    p.doctype = InfoDomain.doctype_statitem
    p.datasetid = haskey(d, InfoDomain.field_datasetid) ? d[InfoDomain.field_datasetid] : ""
    p.name = haskey(d, InfoDomain.field_name) ? d[InfoDomain.field_name] : ""
    p.data = haskey(d, InfoDomain.field_data) ? d[InfoDomain.field_data] : Dict{String,Any}()
    p.observations = haskey(d, InfoDomain.field_observations) ? d[InfoDomain.field_observations] : ""
    return p
end
# =====================
# end module
end
