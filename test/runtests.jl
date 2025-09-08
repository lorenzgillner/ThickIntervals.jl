using ThickIntervals

using Test

@testset verbose = true "ThickIntervals" begin
    @testset "Creation" begin
        @testset "From Reals" begin
            a = thickinterval(0.5, 1.0, 2.0, 2.5)
            @test inf(inf(a)) == 0.5 && sup(inf(a)) == 1.0 && inf(sup(a)) == 2.0 && sup(sup(a)) == 2.5
        end

        @testset "From Intervals" begin
            a = thickinterval(interval(1.5, 2), interval(3.0, 3.5))
            @test inf(inf(a)) == 1.5 && sup(inf(a)) == 2.0 && inf(sup(a)) == 3.0 && sup(sup(a)) == 3.5
        end
    end

    @testset "Operators" begin
        a = thickinterval(1, 2, 4, 5)
        b = thickinterval(3, 7, 6, 8)

        @testset "Addition" begin
            @test a + b == thickinterval(4, 9, 10, 13)
        end

        @testset "Subtraction" begin
            @test a - b == thickinterval(-7, -4, -3, 2)
        end

        @testset "Multiplication" begin
            @test a * b == thickinterval(3, 14, 24, 40)
        end

        # TODO more tests!
    end
end