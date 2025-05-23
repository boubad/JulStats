module InfoDomain
# ==============
export InfoDomain
# 
export field_doctype 
export field_id
export field_rev
export field_attachments
export field_blobrems
export field_observations
export type_photo
export type_video
export field_name
export field_tag
export field_mimetype
export field_lastdate
export field_length
export field_filename
export field_persons
export field_keywords
# =======================
const global server_uri = "http://titan:5984"
const global database_name = "infomedia"
# 
# ====================
# 
const global field_doctype = "doctype"
const global field_id = "_id"
const global field_rev = "_rev"
const global field_attachments = "_attachments"
const global field_blobrems = "blobrems"
const global field_observations = "observations"
# ==============================
const global type_photo = "photo"
const global type_video = "video"
const global field_name = "name"
const global field_tag = "tag"
const global field_mimetype = "mimetype"
const global field_lastdate = "lastdate"
const global field_length = "length"
const global field_filename = "filename"
const global field_persons = "persons"
const global field_keywords = "keywords"
# ========================== 
end # en domain InfoDommain
