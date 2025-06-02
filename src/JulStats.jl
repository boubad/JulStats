module JulStats
# ======================
export NotesData
export InfoDomain
export CouchDBClient
export Media
export MediaProducer
# =============
# Write your package code here.
include("InfoDomain.jl")
include("NotesData.jl")
include("DBManager.jl")
include("CouchDBClient.jl")
include("StoreObject.jl")
include("StatObject.jl")
include("Media.jl")
include("MediaProducer.jl")
# ======================
end