# Test functions
using Test
using TestItems
# ===============
using NotesData
using DataFrames
# ===================
# 
# Notes data test
@testitem "Notes data tests" begin
    vret = NotesData.get_notes_dataframe()
    nrows = size(vret)[1]
    @test nrows == 349
    ncols = size(vret)[2]
    @test ncols == 8
end
