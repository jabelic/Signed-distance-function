using DataFrames, CSV
using Profile
include("./sdistance.jl") # 必ずダブルクオーテーション
include("./draw.jl")
include("./SignedDistance.jl")
include("./environments.jl")
include("../test/APT.jl")
import .Sdistance: computing_bench
import .Draw: parformance_graphs
using .SignedDistance
using .APT

# This script run by test.sh

# === profiling ===

# @profile signedDistance2D("./test/mock_csv_data/interface.csv",parse(Int, ARGS[1])) 
# @profile signedDistance2D("./test/mock_csv_data/interface.csv",parse(Int, ARGS[1]), "multi")
# Profile.print()
# open("prof.txt", "w") do s
#     Profile.print(IOContext(s, :displaysize => (24, 500)))
# end

# === memory size === 
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv")
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv", "multi")
p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/multiple_curves.csv", "multi")

# p = @allocated signedDistance2D("./test/mock_csv_data/interface.csv", parse(Int, ARGS[1]), "multi")
# p =  signedDistance2D("./test/mock_csv_data/interface.csv", parse(Int, ARGS[1]))
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv", "multi")
# q = signedDistance2D( "./test/mock_csv_data/multiple_curves.csv", parse(Int, ARGS[1]), "multi")
# plots_contours([i for i = 50:50:300], "./test/mock_csv_data/interface.csv", "multi")
# plots_contours([i for i = 50:50:300], "./test/mock_csv_data/interface.csv")
# plots_wireframe([i for i = 50:50:300], "./test/mock_csv_data/interface.csv", "multi")

# DataFrame(p, :auto) |> CSV.write("./test/result/interface_result_n500.csv", header=false)
# println("\nmemory size: ",p/(1024*1024), " MB")
