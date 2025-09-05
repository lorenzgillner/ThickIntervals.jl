using ThickIntervals

using Test

A = t2interval(0.5, 1.0, 2.0, 2.5)
B = t2interval(interval(1.5, 2), interval(3.0, 3.5))

@testset verbose = true "Operators" begin
	@testset "Addition" begin
		@test A + B == t2interval(2.0, 3.0, 5.0, 6.0)
	end

	@testset "Subtraction" begin
		@test A - B == t2interval(-3.0, -2.0, 0.0, 1.0)
	end

	@testset "Multiplication" begin
		@test A * B == t2interval(0.75, 2.0, 6.0, 8.75)
	end
end
