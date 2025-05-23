module CouchDBClient
# ==================
include("InfoDomain.jl")
# ===================
export CouchDBClient
# ====================	
using Base64
using JSON
using HTTP
# ============================
using .InfoDomain
# ============================
# constants definitions
const global credentials = "Basic " * base64encode("boubad:bouba256")
const global heads = Dict("Authorization" => credentials)
const global postheaders = Dict("Authorization" => credentials, "Content-Type" => "application/json")
# ====================================
const global baseuri = InfoDomain.server_uri
# default database
# const global dbname = "test"
const global dbname = InfoDomain.database_name
# ============================
# internal working getfunction
function performget(uri::String, name::String = dbname, sbase::String = baseuri)::Dict{String, Any}
	if isempty(name)
		url = sbase
	else
		if isempty(uri)
			url = sbase * "/" * name
		else
			url = sbase * "/" * name * "/" * uri
		end
	end
	rsp = HTTP.get(url, heads)
	JSON.parse(String(rsp.body))
end
# Server info
function getserverinfo(url::String = baseuri)::Dict{String, Any}
	performget("", "", url)
end
# Database Info
function getdatabaseinfo(name::String = dbname, uri::String = baseuri)::Dict{String, Any}
	performget("", name, uri)
end
# 
# find item by 
function finditembyid(id::String; databasename::String = dbname, serveruri::String = baseuri)
	try
		url = serveruri * "/" * databasename * "/" * id
		rsp = HTTP.get(url, heads)
		try
			body = String(rsp.body)
			d = JSON.parse(body)
			return d, true
		catch ex
			println(ex)
		end
	catch
	end
	return Dict{String, Any}(), false
end
# find query
function findquery(sel::Dict{String, Any}; fields::Vector{String} = Vector{String}(), sort::Vector{Dict{String, Any}} = Vector{Dict{String, Any}}(), offset::Int64 = 0, limit::Int64 = 0,
	databasename::String = dbname, serveruri::String = baseuri)::Vector{Dict{String, Any}}
	vret = Dict{String, Any}()
	try
		vret["selector"] = sel
		if !isempty(fields)
			vret["fields"] = fields
		end
		if !isempty(sort)
			vret["sort"] = sort
		end
		if offset > 0
			vret["skip"] = offset
		end
		if limit > 0
			vret["limit"] = limit
		end
		url = serveruri * "/" * databasename * "/_find"
		body = JSON.json(vret)
		rsp = HTTP.request("POST", url, postheaders, body)
		xx = JSON.parse(String(rsp.body))
		if haskey(xx, "docs")
			return xx["docs"]
		end
	catch
	end
	return Vector{Dict{String, Any}}()
end
# 
# get count
function getitemscount(sel::Dict{String, Any}; databasename::String = dbname, serveruri::String = baseuri)::Int64
	count = 128
	fields = ["_id"]
	skip = 0
	total = 0
	done = false
	while !done
		dx = findquery(sel; fields = fields, limit = count, offset = skip, databasename = databasename, serveruri = serveruri)
		cur = size(dx)[1]
		total += cur
		skip += cur
		done = cur < count
	end
	return total
end
# 
# find one item by filter
function findoneitem(sel::Dict{String, Any}; databasename::String = dbname, serveruri::String = baseuri)
	dx = findquery(sel; limit = 1, offset = 0, databasename = databasename, serveruri = serveruri)
	if isempty(dx)
		return Dict{String, Any}(), false
	else
		return dx[1], true
	end
end
# end module
end
