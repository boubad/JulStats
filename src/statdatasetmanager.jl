include("infodomain.jl")
include("dbclient.jl")
include("storeobject.jl")
include("datasetobject.jl")
include("statitemobject.jl")
# ==================
using .InfoDomain
# ==================
using .DBManager
# ==================
function get_datasets_count(db::DBManager.DBClient)::Int64
    sel = Dict{String,Any}(InfoDomain.field_doctype => InfoDomain.doctype_dataset)
    return DBManager.get_docs_count(db, sel)
end
# ==================
function get_datasets(db::DBManager.DBClient; offset::Int64=0, limit::Int64=0)::Vector{DatasetObject}
    sel = Dict{String,Any}(InfoDomain.field_doctype => InfoDomain.doctype_dataset)
    docs = DBManager.query_docs(db, sel; offset=offset, limit=limit)
    vret = Vector{DatasetObject}()
    for x in docs
        z = create_datasetobject(x)
        push!(vret, z)
    end
    return vret
end
# ==================
function get_dataset_by_id(db::DBManager.DBClient, id::String)::DatasetObject
    doc = DBManager.get_doc(db, id)
    if length(doc) == 0
        return DatasetObject.DatasetObject()
    end
    return create_datasetobject(doc)
end
# ==================
function get_dataset_by_sigle(db::DBManager.DBClient, sigle::String)::DatasetObject
    sel = Dict{String,Any}(InfoDomain.field_doctype => InfoDomain.doctype_dataset, InfoDomain.field_sigle => sigle)
    doc = DBManager.query_one_doc(db, sel)
    if length(doc) == 0
        return DatasetObject.DatasetObject()
    end
    return create_datasetobject(doc)
end
# ===================
function get_dataset_by_name(db::DBManager.DBClient, name::String)::DatasetObject
    sel = Dict{String,Any}(InfoDomain.field_doctype => InfoDomain.doctype_dataset, InfoDomain.field_name => name)
    doc = DBManager.query_one_doc(db, sel)
    if length(doc) == 0
        return DatasetObject.DatasetObject()
    end
    return create_datasetobject(doc)
end
# ===================
function maintains_dataset(db::DBManager.DBClient, ds::DatasetObject)::Bool
    name = strip(ds.name)
    if length(name) == 0
        return false
    end
    d = Dict{String,Any}()
    oldid = strip(ds.storeobject.id)
    if length(id) > 0
        dx = get_dataset_by_id(db, oldid)
        if length(dx.storeobject.id) > 0
            oldid = dx.storeobject.id
        else
            oldid = ""
        end
    end
    dy = get_dataset_by_name(db, name)
    if length(dy.storeobject.id) > 0
        id = dy.storeobject.id
        if oldid != id && length(oldid) > 0
            return false
        end
        oldid = id
    end
    s = lowercase(strip(ds.sigle))
    sigle = replace(s, " " => "_")
    if length(sigle) == 0
        s = lowercase(strip(name))
        sigle = replace(s, " " => "_")
    end
    dz = get_dataset_by_sigle(db, sigle)
    if length(dz.storeobject.id) > 0
        id = dz.storeobject.id
        if oldid != id && length(oldid) > 0
            return false
        end
        oldid = id
    end
    if length(oldid) > 0
        d[InfoDomain.field_id] = oldid
    end
    d[InfoDomain.field_sigle] = sigle
    df[InfoDomain.field_name] = name
    d[InfoDomain.field_doctype] = InfoDomain.doctype_dataset
    variables = ds.variables
    if length(variables) > 0
        d[InfoDomain.field_variables] = variables
    end
    observations = strip(ds.observations)
    if length(observations) > 0
        d[InfoDomain.field_observations] = observations
    end
    return DBManager.maintains_doc(db, d)
end
# ===================
function get_dataset_items_count(db::DBManager.DBClient, datasetid::String)::Int64
    sel = Dict{String,Any}(InfoDomain.field_doctype => InfoDomain.doctype_statitem, InfoDomain.field_datasetid => datasetid)
    return DBManager.get_docs_count(db, sel)
end
# ===================
function get_dataset_items(db::DBManager.DBClient, datasetid::String; offset::Int64=0, limit::Int64=0)::Vector{StatItemObject}
    sel = Dict{String,Any}(InfoDomain.field_doctype => InfoDomain.doctype_statitem, InfoDomain.field_datasetid => datasetid)
    docs = DBManager.query_docs(db, sel; offset=offset, limit=limit)
    vret = Vector{StatItemObject}()
    for x in docs
        z = create_statitemobject(x)
        push!(vret, z)
    end
    return vret
end
# ===================
function get_dataset_item_by_id(db::DBManager.DBClient, id::String)::StatItemObject
    doc = DBManager.get_doc(db, id)
    if length(doc) == 0
        return StatItemObject.StatItemObject()
    end
    return create_statitemobject(doc)
end
# ====================
function get_dataset_item_by_name(db::DBManager.DBClient, datasetid::String, name::String)::StatItemObject
    sel = Dict{String,Any}(InfoDomain.field_doctype => InfoDomain.doctype_statitem, InfoDomain.field_datasetid => datasetid, InfoDomain.field_name => name)
    doc = DBManager.query_one_doc(db, sel)
    if length(doc) == 0
        return StatItemObject.StatItemObject()
    end
    return create_statitemobject(doc)
end
# ====================
function maintains_dataset_item(db::DBManager.DBClient, ds::StatItemObject)::Bool
    datasetid = strip(ds.datasetid)
    name = strip(ds.name)
    if length(name) == 0 || length(datasetid) == 0
        return false
    end
    d = Dict{String,Any}()
    oldid = strip(ds.storeobject.id)
    if length(id) > 0
        dx = get_dataset_item_by_id(db, oldid)
        if length(dx.storeobject.id) > 0
            oldid = dx.storeobject.id
        else
            oldid = ""
        end
    end
    dy = get_dataset_item_by_name(db, datasetid, name)
    if length(dy.storeobject.id) > 0
        id = dy.storeobject.id
        if oldid != id && length(oldid) > 0
            return false
        end
        oldid = id
    end
    if length(oldid) > 0
        d[InfoDomain.field_id] = oldid
    end
    d[InfoDomain.field_name] = name
    d[InfoDomain.field_datasetid] = datasetid
    d[InfoDomain.field_doctype] = InfoDomain.doctype_statitem
    data = ds.data
    if length(data) > 0
        d[InfoDomain.field_data] = data
    end
    observations = strip(ds.observations)
    if length(observations) > 0
        d[InfoDomain.field_observations] = observations
    end
    return DBManager.maintains_doc(db, d)
end
# ===================
function delete_dataset_item(db::DBManager.DBClient, id::String)::Bool
    return DBManager.delete_doc(db, id)
end
# ===================
function delete_dataset_items(db::DBManager.DBClient, datasetid::String)::Bool
    x = get_dataset_by_id(db, datasetid)
    if length(x.storeobject.id) == 0
        return false
    end
    offset = 0
    limit = 64
    done = false
    while !done
        dx = get_dataset_items(db, datasetid; offset=offset, limit=limit)
        cur = length(dx)
        if cur < 1
            break
        end
        for p in dx
            delete_dataset_item(db, p.storeobject.id)
        end
        offset += cur
        done = cur < limit
    end
    return delete_doc(db, datasetid)
end
# ==================
