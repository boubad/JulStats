module JulStats
# ======================
# Write your package code here.
include("infodomain.jl")
include("storeobject_file.jl")
include("notesdata.jl")
include("dbclient.jl")
include("couchdbclient.jl")
include("media.jl")
include("mediaproducer.jl")
# ================
include("datasetobject.jl")
include("statitemobject_file.jl")
# =================
include("statdatasetmanager.jl")
# =================
export remove_outliers!
export remove_all_outliers!
export convert_to_ranks
export get_notes_dataframe
export compute_occurences
# =================
export StoreObject
# ==================
export Photo
export Video
export MediaItem
export mediaitem
export dicttomediaitem
# =========================
export DBClient
export DatasetObject
export StatItemObject
export StatDatasetManager
# ======================
end