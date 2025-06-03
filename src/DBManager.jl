module DBManager
# =================
# include("InfoDomain.jl")
# ==================
# export DBManager
export DBClient
# ====================	
using Base64
using JSON
using HTTP
# ============================
# using InfoDomain
# ============================
# constants definitions
const db_credentials = "Basic " * base64encode("boubad:bouba256")
const db_heads = Dict("Authorization" => db_credentials)
const db_postheaders = Dict("Authorization" => db_credentials, "Content-Type" => "application/json")
const items_chunk_size = 128
# =================
struct DBClient
    credentials::String
    baseuri::String
    dbname::String
    heads::Dict{String,String}
    postheaders::Dict{String,String}
    function DBClient(; credentials::String=db_credentials, baseuri::String=InfoDomain.server_uri, dbname::String=InfoDomain.database_name,
        heads::Dict{String,String}=db_heads, postheaders::Dict{String,String}=db_postheaders)
        new(credentials, baseuri, dbname, heads, postheaders)
    end
end
# ==============
function check_persist_object(d::Dict{String,Any})::Dict{String,Any}
    dret = Dict{String,Any}()
    id = ""
    for (k, v) in d
        if startswith(k, "_")
            if k == InfoDomain.field_id
                id = v
            end
            continue
        end
        if ismissing(v) || isnothing(v)
            continue
        end
        if typeof(v) == String
            s = strip(v)
            if length(s) == 0
                continue
            end
        end
        dret[k] = v
    end
    if length(id) > 0
        dret[InfoDomain.field_id] = id
    end
    return dret
end
# ==============    
function maintains_doc(db::DBClient, d::Dict{String,Any})::Bool
    dd = check_persist_object(d)
    id = haskey(dd, InfoDomain.field_id) ? dd[InfoDomain.field_id] : ""
    if length(id) > 0
        uri = db.baseuri * "/" * db.dbname * "/" * id
        rsp = HTTP.get(uri, db.heads)
        if rsp.status < 400
            old = JSON.parse(String(rsp.body))
            rev = haskey(old, InfoDomain.field_rev) ? old[InfoDomain.field_rev] : ""
            if length(rev) > 0
                uri = uri * "?rev=" * rev
                rsp = HTTP.put(uri, db.postheaders, JSON.json(dd))
                return rsp.status < 400
            end
        end
    end
    if haskey(dd, InfoDomain.field_id)
        delete!(dd, InfoDomain.field_id)
    end
    uri = db.baseuri * "/" * db.dbname
    rsp = HTTP.post(uri, db.postheaders, JSON.json(dd))
    return rsp.status < 400
end
# ==============
function delete_doc(db::DBClient, id::String)::Bool
    uri = db.baseuri * "/" * db.dbname * "/" * id
    rsp = HTTP.get(uri, db.heads)
    if rsp.status < 400
        rsp = HTTP.delete(uri, db.heads)
        return rsp.status < 400
    end
    return false
end
# ===============
function get_doc(db::DBClient, id::String)::Dict{String,Any}
    uri = db.baseuri * "/" * db.dbname * "/" * id
    rsp = HTTP.get(uri, db.heads)
    if rsp.status < 400
        return JSON.parse(String(rsp.body))
    end
    return Dict{String,Any}()
end
# ===================
function query_docs(db::DBClient, sel::Dict{String,Any}; fields::Vector{String}=Vector{String}(), sort::Vector{Dict{String,Any}}=Vector{Dict{String,Any}}(), offset::Int64=0, limit::Int64=0)
    q = Dict{String,Any}()
    q["selector"] = sel
    if !isempty(fields)
        q["fields"] = fields
    end
    if !isempty(sort)
        q["sort"] = sort
    end
    if offset >= 0
        q["skip"] = offset
    end
    if limit > 0
        q["limit"] = limit
    end
    uri = db.baseuri * "/" * db.dbname * "/_find"
    rsp = HTTP.post(uri, db.postheaders, JSON.json(q))
    if rsp.status < 400
        xx = JSON.parse(String(rsp.body))
        if haskey(xx, "docs")
            vx = xx["docs"]
            return vx
        end
    end
    return Vector{Dict{String,Any}}()
end
# ==================
function query_one_doc(db::DBClient, sel::Dict{String,Any})::Dict{String,Any}
    dx = query_docs(db, sel; limit=1, offset=0)
    if !isempty(dx)
        return dx[1]
    end
    return Dict{String,Any}()
end
# ===================
function get_docs_count(db::DBClient, sel::Dict{String,Any})::Int64
    fields = [InfoDomain.field_id]
    skip = 0
    total = 0
    done = false
    while !done
        dx = query_docs(db, sel; fields=fields, limit=items_chunk_size, offset=skip)
        if isempty(dx)
            break
        end
        cur = size(dx)[1]
        total += cur
        skip += cur
        done = cur < items_chunk_size
    end
    return total
end
# ==============
# end module
end