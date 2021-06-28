# Задача 1

include("plane.jl")
using .Vector2Ds
function randpoints(random::Function, num::Integer)
    return[(random(),random()) for _ in 1:num]
end

# Задача 2

import Pkg
Pkg.add("Plots")
using Plots
include("plane.jl")
using .Vector2Ds
points = randpoints(rand, 30)
scatter(points; legend = false)

# Задача 3

using Plots
include("plane.jl")
using .Vector2Ds
function plotsegments(segments; kwargs...)
    p=plot(;kwargs...)
    for s in segments
        plot!(collect(s); kwargs...)
    end
    return p
end

# Задача 4

using Plots
include("plane.jl")
using .Vector2Ds
function trasspasing(segments; kwargs...)
    p=plot(;kwargs...)
    for s in segments
        plot!(collect(s); kwargs...)
    end

    for i in 1:length(segments)
        A,B=segments[i]
        for j in i+1:length(segments)
            C,D=segments[j]
            if intersect((A,B),(C,D))!==nothing
                plot!(intersect((A,B),(C,D)),markershape=:xcross, markercolor=:red )
            end
        end
    end

    return p
end

# Задача 5

using Plots
include("plane.jl")
using .Vector2Ds
function lines(segments,line)
    p=plot(;linecolor=:green, markershape=:circle, markercolor=:blue)
    for s in line
        plot!(collect(s); linecolor=:green, markershape=:circle, markercolor=:blue)
    end
    A,B=line[1]

    scatter!(segments[1],markershape=:circle,markercolor=:blue ; legend = false)

    for i in 2:length(segments)
        if is_one(segments[1],segments[i],A,B)==true
            scatter!(segments[i],markershape=:circle,markercolor=:blue ; legend = false)
        else
            scatter!(segments[i],markershape=:circle,markercolor=:red ; legend = false)
        end
    end

    return p
end

function is_one(C, D, A, B)
    l=B.-A
    return sin(l,C.-A)*sin(l,D.-A)>0
end

# Задача 7


using Plots
include("plane.jl")
using .Vector2Ds
function vacmnog(segments)
    for i in 1:length(segments)-2
        A = norm(segments[i]-segments[i+1])
        B = norm(segments[i+1]-segments[i+2])
        if sin(A,B)<0
            return false
        end
    end
    A = norm(segments[length(segments)-1]-segments[length(segments)])
    B = norm(segments[length(segments)]-segments[length(segments)+1])
    if sin(A,B)<0
        return false
    end
    A = norm(segments[length(segments)]-segments[1])
    B = norm(segments[1]-segments[2])
    if sin(A,B)<0
        return false
    end
    return true
end
