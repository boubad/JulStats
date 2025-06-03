# Test functions
using Test
using TestItems
# =============
# 
using InfoDomain
using DBManager
# ===================
# test DBManager query_docs
@testitem "DBManager query_docs Tests" tags = [:skipci] begin
    db = DBManager.DBClient()
    sel = Dict{String,Any}("doctype" => InfoDomain.doctype_dataset)
    dx = DBManager.query_docs(db, sel)
    @test !isempty(dx)
    for x in dx
        @test haskey(x, InfoDomain.field_id)
        @test haskey(x, InfoDomain.field_name)
        @test haskey(x, InfoDomain.field_doctype)
        @test isequal(x[InfoDomain.field_doctype], InfoDomain.doctype_dataset) 
        println(x[InfoDomain.field_name])
      end
end 
# ===================