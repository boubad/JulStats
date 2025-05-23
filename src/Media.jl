module Media
# # ==========================
include("InfoDomain.jl")
# ==========
using .InfoDomain
# # ==========================
export Photo
export Video
export MediaItem
export mediaitem
export dicttomediaitem
# # ==========================
abstract type MediaItem end
# # ==========================
struct Photo <: MediaItem
    id::String
    rev::String
    doctype::String
    name::String
    tag::String
    filename::String
    mimetype::String
    lastdate::String
    size::Int64
    observations::String
    persons::Vector{String}
    keywords::Vector{String}
end
# # ==========================
struct Video <: MediaItem
    id::String
    rev::String
    doctype::String
    name::String
    tag::String
    filename::String
    mimetype::String
    lastdate::String
    size::Int64
    observations::String
    persons::Vector{String}
    keywords::Vector{String}
end
# # ==========================
function mediaitem(id::String, rev::String, doctype::String, name::String, tag::String, filename::String, mimetype::String, lastdate::String, size::Int64, observations::String, persons::Vector{String}, keywords::Vector{String})
    if doctype == InfoDomain.type_photo
        return Photo(id, rev, doctype, name, tag, filename, mimetype, lastdate, size, observations, persons, keywords)
    elseif doctype == InfoDomain.type_video
        return Video(id, rev, doctype, name, tag, filename, mimetype, lastdate, size, observations, persons, keywords)
    else
        error("Unknown media type: $doctype")
    end
end
function dicttomediaitem(d::Dict{String,Any})
    id = haskey(d, InfoDomain.field_id) ? d[InfoDomain.field_id] : ""
    rev = haskey(d, InfoDomain.field_rev) ? d[InfoDomain.field_rev] : ""
    doctype = haskey(d, InfoDomain.field_doctype) ? d[InfoDomain.field_doctype] : ""
    name = haskey(d, InfoDomain.field_name) ? d[InfoDomain.field_name] : ""
    tag = haskey(d, InfoDomain.field_tag) ? d[InfoDomain.field_tag] : ""
    filename = haskey(d, InfoDomain.field_filename) ? d[InfoDomain.field_filename] : ""
    mimetype = haskey(d, InfoDomain.field_mimetype) ? d[InfoDomain.field_mimetype] : ""
    lastdate = haskey(d, InfoDomain.field_lastdate) ? d[InfoDomain.field_lastdate] : ""
    size = haskey(d, InfoDomain.field_length) ? d[InfoDomain.field_length] : 0
    observations = haskey(d, InfoDomain.field_observations) ? d[InfoDomain.field_observations] : ""
    persons = haskey(d, InfoDomain.field_persons) ? d[InfoDomain.field_persons] : []
    ppersons = Vector{String}(persons)
    keywords = haskey(d, InfoDomain.field_keywords) ? d[InfoDomain.field_keywords] : []
    pkeywords = Vector{String}(keywords)
    return mediaitem(id, rev, doctype, name, tag, filename, mimetype, lastdate, size, observations, ppersons, pkeywords)
end
# # ==========================
# end module
end