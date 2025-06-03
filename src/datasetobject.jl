# ===========================
export DatasetObject
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
# ====================
function create_datasetobject(d::Dict{String,Any})::DatasetObject
    id = haskey(d, InfoDomain.field_id) ? d[InfoDomain.field_id] : ""
    rev = haskey(d, InfoDomain.field_rev) ? d[InfoDomain.field_rev] : ""
    name = haskey(d, InfoDomain.field_name) ? d[InfoDomain.field_name] : ""
    sigle = haskey(d, InfoDomain.field_tag) ? d[InfoDomain.field_tag] : ""
    variables = haskey(d, InfoDomain.field_persons) ? d[InfoDomain.field_persons] : []
    observations = haskey(d, InfoDomain.field_observations) ? d[InfoDomain.field_observations] : ""
    return DatasetObject(id=id, rev=rev, name=name, sigle=sigle, variables=variables, observations=observations)
end
# =======================