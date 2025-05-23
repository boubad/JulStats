# Test functions
using Test
using TestItems
# 
using InfoDomain
using CouchDBClient
# ===================
# 
# Server Info
@testitem "Server info tests" tags = [:skipci] begin
    tval = CouchDBClient.getserverinfo()
    @test !isempty(tval)
    @test haskey(tval, "couchdb")
    @test tval["couchdb"] == "Welcome"
    @test haskey(tval, "version")
    version = tval["version"]
    @test version >= "3.0.0"
end
# 
# Database Info
@testitem "Database info Tests" tags = [:skipci] begin
    tval = CouchDBClient.getdatabaseinfo(InfoDomain.database_name)
    @test !isempty(tval)
    @test haskey(tval, "db_name")
    @test tval["db_name"] == InfoDomain.database_name
end
# 
# find query test
@testitem "Find query Tests" tags = [:skipci] begin
    sel = Dict{String,Any}("doctype" => InfoDomain.type_video)
    tval = CouchDBClient.findquery(sel; limit=5)
    @test !isempty(tval)
    for item in tval
        @test !isempty(item)
        @test haskey(item, "_id")
    end
end
# 
# get items count Tests
@testitem "Get Items Count Tests" tags = [:skipci] begin
    sel = Dict{String,Any}("doctype" => InfoDomain.type_video)
    ntotal = CouchDBClient.getitemscount(sel)
    @test ntotal > 0
end
# 
# find one item by filter tests
@testitem "Find one item by filter Tests" tags = [:skipci] begin
    sel = Dict{String,Any}("doctype" => InfoDomain.type_video)
    tval, ok = CouchDBClient.findoneitem(sel)
    @test ok
    @test !isempty(tval)
    @test haskey(tval, "_id")
end
# 
# find item by idtests
@testitem "Find item by id Tests" tags = [:skipci] begin
    sel = Dict{String,Any}("doctype" => InfoDomain.type_video)
    tval, ok = CouchDBClient.findoneitem(sel)
    @test ok
    @test !isempty(tval)
    @test haskey(tval, "_id")
    id = tval["_id"]
    db = InfoDomain.database_name
    tval, ok = CouchDBClient.finditembyid(id; databasename=db)
    @test ok
    @test !isempty(tval)
    @test haskey(tval, "_id")
end
