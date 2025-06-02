module DBManager
# =================
include("InfoDomain.jl")
# ==================
using .InfoDomain
# ==================
export DBManager
export DBClient
# ====================	
using Base64
using JSON
using HTTP
# ============================
using .InfoDomain
# ============================
# constants definitions
const global db_credentials = "Basic " * base64encode("boubad:bouba256")
const global db_heads = Dict("Authorization" => db_credentials)
const global db_postheaders = Dict("Authorization" => db_credentials, "Content-Type" => "application/json")
# =================
struct DBClient
    credentials::String
    baseuri::String
    dbname::String  
    heads::Dict{String, String}
    postheaders::Dict{String, String}
    function DBClient(; credentials::String=db_credentials, baseuri::String=InfoDomain.baseuri, dbname::String=InfoDomain.database_name,
        heads::Dict{String, String}=db_heads, postheaders::Dict{String, String}=db_postheaders)
        new(credentials, baseuri, dbname, heads, postheaders)
    end
end
# ==============
# end module
end