module JulStats
# ======================
export NotesData
export InfoDomain
export CouchDBClient
export Media
export MediaProducer
export DBManager
export DatasetObject
export StatItemObject
# =============
# Write your package code here.
include("InfoDomain.jl")
include("StoreObject.jl")
include("NotesData.jl")
include("DBManager.jl")
include("CouchDBClient.jl")
include("Media.jl")
include("MediaProducer.jl")
# ================
include("DatasetObject.jl")
# include("StatItemObject.jl")
# ======================
end