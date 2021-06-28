function newton(r::Function, x; ε_x=1e-16, ε_y=1e-16, nmaxiter=20)
    x1 = x
    x2 = x + 2 * ε_x
    for i in 1:nmaxiter
        if (abs(x1 - x2) < ε_x || r(x1) < ε_y) && i > 1
            return x1
        end
        x2 = x1
        x1 = x1 - r(x1)
    end
    if abs(x1 - x2) < ε_x || r(x1) < ε_y
        return x1
    end
    return nothing
end

# Задача 2

newton_cosx() = newton(x -> (-cos(x)/sin(x)), 0.5)

# Задача 3

newton(ff::Tuple{Function,Function}, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20) = newton(x->ff[1](x)/ff[2](x), x;ε_x, ε_y, nmaxiter )

# Задача 4

newton(x) = newton((x->x - cos(x), x->sin(x)), x)

# Задача 5

newton1(ff, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)= newton(x->(y=ff(x); y[1]/y[2]), x; ε_x, ε_y, nmaxiter)

# Задача 6

newton2() = newton(x->(x - cos(x), x-> sin(x)), 0.5)

# Задача 7

using  Polynomials

function find_deriative(P::Polynomial)::Polynomial
    coeffs = P.coeffs
    if length(coeffs) <= 1
        return Polynomial([0])
    end
    newcoeffs = Vector{Number}(undef, 0)
    for i in 2:length(coeffs)
        push!(newcoeffs, (coeffs[i] * (i-1)))
    end
    return Polynomial(newcoeffs)
end

function count_polynom(x::Number, p::Polynomial)::Number
    coeffs = copy(p.coeffs)
    reverse!(coeffs)
    result = coeffs[1]
    for i in 2:length(coeffs)
        result *= x
        result += coeffs[i]
    end
    return result
end

function newton_pol(polynom_coeff::AbstractVector, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)
    x1 = x
    x2 = x + 2 * ε_x
    p = Polynomial(polynom_coeff)
    p1 = find_deriative(copy(p))
    f = count_polynom(x1, p)
    for i in 1:nmaxiter
        if (abs(x1 - x2) < ε_x || f < ε_y) && i > 1
            return x1
        end
        x2 = x1
        f = count_polynom(x1, p)
        f1 = count_polynom(x1, p1)
        x1 = x1 - f/f1
    end
    if abs(x1 - x2) < ε_x || f < ε_y
        return x1
    end
    return nothing
end

# Задача 8

using Plots

function newton(z, root, ε,nmaxiter)
    n=length(root)
    for k in 1:nmaxiter
        z -= (z - 1/z^(n-1))/n
        root_index = findfirst(r->abs(r-z) <= ε, root)
        if !isnothing(root_index)
            return root_index
        end
    end
    return nothing
end

function visualisation(D, colors; markersize, backend::Function)
    backend()
    p=plot()
    for i in 1:length(colors)
        plot!(p, real(D[i]), imag(D[i]),
            seriestype = :scatter,
            markersize = markersize,
            markercolor = colors[i])
    end
    plot!(p; ratio = :equal, legend = false)
end

function visualisation(D, colors; markersize, backend::Function)
    backend()
    p=plot()
    for i in 1:length(colors)
        plot!(p, real(D[i]), imag(D[i]),
            seriestype = :scatter,
            markersize = markersize,
            markercolor = colors[i])
    end
    plot!(p; ratio = :equal, legend = false)
end

function kelliproblem(; colors = [:red,:green,:blue],
               nmaxiter = 40,
               ε = 0.5,
               numpoints = 10_000_000,
               squaresize = 500,
               markersize = 0.01,
               backend::Function = pyplot
            )
    n = length(colors)
    root = [exp(im*2π*k/n) for k in 0:n-1]
    D = []
    for i in 1:n
        push!(D, [])
    end
    for i in 1:numpoints
        z = complex(rand() -0.5,rand()- 0.5) * squaresize
        m = newton(z, root, ε, nmaxiter)
        if m != nothing
            push!(D[m], z)
        end
    end
    visualisation(D, colors; markersize =  markersize, backend = backend)
end
