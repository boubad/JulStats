# Test functions
using Test
using TestItems
# ============= 
using InfoDomain
using MediaProducer
# ===================
# 
# Photo procuder test
@testitem "Photo producer tests" tags = [:skipci] begin
    for p in Channel(MediaProducer.producer_photo)
        @test p.doctype == InfoDomain.type_photo
    end
end
# 
# Video producer test
@testitem "Video producer tests" tags = [:skipci] begin
    for p in Channel(MediaProducer.producer_video)
        @test p.doctype == InfoDomain.type_video
    end
end
# 
