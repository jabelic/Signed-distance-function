module Draw
    import Plots
    using Plots

    function draw(_x::Array, _y::Array, _phi::Array, fig_name::Union{SubString{String}, Nothing}=nothing)
        s = plot(_x, _y, _phi, st=:wireframe)
        p = contour(_x, _y, _phi)
        q = surface(_x, _y, _phi)
        r = plot(_x, _y, _phi, st=:heatmap)
        plot(s, p, q, r, layout=(4, 1), size=(500, 1200))
        if fig_name !== nothing
            savefig("test/image/"*fig_name*".png")
            # savefig("test/image/double_circle_signed_distance.png")
        else
           savefig("image/tmp_signed_distance.png")
        end
    end
    precompile(draw, (Array, Array, Array, Union{SubString{String}, Nothing}))

    function parformance_graphs(N::Array, exe_num::Array, fig_name::Union{String, Nothing}=nothing, label_name::Union{Array, Nothing}=nothing)
        (row, col) = size(exe_num)
        plot(N, exe_num[:,1],title = "Benchmarks", label = label_name[1], legend = :topleft)
        for i=2:col
            # plot(N, exe_num[:,i],title = "Benchmarks", label = label_name[1], legend = :topleft)
            plot!(N, exe_num[:,i], label = label_name[i])
        end
        xlabel!("Splits of fields")
        ylabel!("Processing time(sec.)")
        if fig_name !== nothing
            savefig("test/image/"*fig_name*"_performance.png")
        else
            savefig("test/image/performance.png")
        end
    end
    precompile(parformance_graphs, (Array, Array))
    export draw,parformance_graphs
end