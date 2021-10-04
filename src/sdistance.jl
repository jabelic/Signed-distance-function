module Sdistance
    include("./draw.jl")
    import .Draw:draw
    import  CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools
    using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools
    # 定義上のある点に対して全てのganma曲線上との距離を算出
    function distance(px::Float64, py::Float64, gem::Array) # TODO: 型
        min_distance = 10000.0 # 初期値は大きく
        for i = 1:length(gem[:,1])
            distnow = sqrt((gem[i,1] - px)^2 + (gem[i,2] - py)^2)
            if (distnow < min_distance)
                min_distance = distnow
            end
        end
        return min_distance
    end


    # ジョルダン曲線: ねじれのない閉曲線のこと.
    """
        ジョルダン閉曲線であるかどうか
    """
    function is_ganma_Jordan_curve(_ganma, x_array, y_array)
        progression_of_differences = [sqrt((_ganma[i,1] - _ganma[i + 1,1])^2 + (_ganma[i,2] - _ganma[i + 1,2])^2) for i = 1:(length(_ganma[:, 1]) - 1)]
        ave_distance = sum(progression_of_differences) / length(progression_of_differences)
        if ave_distance * 2 < abs(_ganma[1,1] - _ganma[length(_ganma[:,1]),1])
            return true
        else
            return false
        end
    end


    function judge_(_x::Array, _y::Array, _ganma::Array)
        x_length = length(_x[:,1])
        return_value = zeros(Float64, x_length, x_length)
        for indexI = 1:length(_y)
            for indexJ = 1:length(_x)
                sdist = 1.0 * distance(_x[indexJ], _y[indexI], _ganma)
                # ganmaが閉曲線でないと成立しない。
                # omegaとの境界線上はErrorになる
                if Point(_x[indexJ], _y[indexI]) in [Point(_ganma[i,1], _ganma[i,2]) for i = 1:length(_ganma[:,1])]
                    sdist = 0
                elseif isinside(Point(_x[indexJ], _y[indexI]), [Point(_ganma[i,1], _ganma[i,2]) for i = 1:length(_ganma[:,1])])
                    sdist = (-1) * sdist
                end
                return_value[indexI,indexJ] = sdist
    end
        end
        return return_value
    end

    function judge_para(_x::Array, _y::Array, _ganma::Array)
        x_length = length(_x[:,1])
        return_value = zeros(Float64, x_length, x_length)
        Threads.@threads for indexI = 1:length(_y)
            for indexJ = 1:length(_x)
                sdist = 1.0 * distance(_x[indexJ], _y[indexI], _ganma)
                if Point(_x[indexJ], _y[indexI]) in [Point(_ganma[i,1], _ganma[i,2]) for i = 1:length(_ganma[:,1])]
                    sdist = 0
                elseif isinside(Point(_x[indexJ], _y[indexI]), [Point(_ganma[i,1], _ganma[i,2]) for i = 1:length(_ganma[:,1])])
                    sdist = (-1) * sdist
                end
                return_value[indexI,indexJ] = sdist
    end
        end
        return return_value
    end


    # FIXME: 倍々ではなく, linearに補完数を指定できるように。

    "n行目とn+1行目の間のデータを補完,境界条件を付与 (x, 2)->(x*2-1, 2)"
    function complement_p(array::Array)
        (x, y) = size(array)
        return_value = zeros(Float64, 2 * x, y)
        for i = 1:x - 1
            return_value[i * 2 - 1, :] = array[i, :]
        return_value[i * 2, :] = (array[i, :] .+ array[i + 1, :]) ./ 2
        end
        return_value[x * 2 - 1, :] = array[x, :]
        return_value[x * 2, :] = array[1, :]# Note: _ganma += _ganma's head line coz boundary condition. size: (N+1,2)
        return return_value
    end

    # function complement(array::Array{Float64,2}, times::UInt64)
    """
        times回, 倍の数だけデータを補完する
    """
    function complement(array::Array, times::Int)
        tmp = []
        for i = 1:times
            tmp = complement_p(array)
            array = tmp
        end
        return tmp
    end


    function main(N::Int=1000, para_or_serialize_process::Int=1, _csv_datafile::String="./interface.csv")
    # create the computational domain
        L = 1.5
        _phi = zeros(Float64, N + 1, N + 1)
        println("Thread数: ", Threads.nthreads())
        
        # ganma曲線 data 読み込みちょっと遅いかも. (50 x 2)
        _ganma = readdlm(_csv_datafile, ',', Float64)
        _x = [i for i = -L:2 * L / N:L] # len:N+1 
        _y = [i for i = -L:2 * L / N:L] # len:N+1
        is_ganma_Jordan_curve(_ganma, _x, _y) # TODO: 丁寧なError messageを付与

        _ganma = complement(_ganma, 3)
        println("_gen size", size(_ganma))

        runtime_ave = 0
        exetimes = 4

        for i = 1:exetimes
            if para_or_serialize_process == 1
                _phi, runtime = @timed judge_para(_x, _y, _ganma) # parallel processing
            else
                _phi, runtime = @timed judge_(_x, _y, _ganma) # serialize processing
            end
            runtime_ave += runtime
        end
        println("実行時間: ",runtime_ave / exetimes)
        draw(_x, _y, _phi)
        return (runtime_ave / exetimes)
    end
    export main
end

# main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./interface.csv")