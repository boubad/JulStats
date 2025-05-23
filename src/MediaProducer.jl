module MediaProducer
# ========================
include("CouchDBClient.jl")
include("InfoDomain.jl")
include("Media.jl")
# ==========================
using .InfoDomain
using .CouchDBClient
# ==========================
export MediaProducer
export producer_photo
export producer_video
# ======
function producer_photo(c::Channel)
    filter = Dict{String,Any}("doctype" => InfoDomain.type_photo)
    count = 10
    skip = 0
    done = false
    while !done
        dx = CouchDBClient.findquery(filter; limit=count, offset=skip)
        cur = size(dx)[1]
        skip += cur
        done = isempty(dx) || cur < count
        if !isempty(dx)
            for p in dx
                x = Media.dicttomediaitem(p)
                put!(c, x)
            end
        end
    end
end
function producer_video(c::Channel)
    filter = Dict{String,Any}("doctype" => InfoDomain.type_video)
    count = 10
    skip = 0
    done = false
    while !done
        dx = CouchDBClient.findquery(filter; limit=count, offset=skip)
        cur = size(dx)[1]
        skip += cur
        done = isempty(dx) || cur < count
        if !isempty(dx)
            for p in dx
                x = Media.dicttomediaitem(p)
                put!(c, x)
            end
        end
    end
end
# ==========================
end
