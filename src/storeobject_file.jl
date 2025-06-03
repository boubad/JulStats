# ==================
struct StoreObject
    id::String
    rev::String
    doctype::String
    function StoreObject(; id::String="", rev::String="", doctype::String="")
       return  new(id, rev, doctype)
    end
end
# =============
