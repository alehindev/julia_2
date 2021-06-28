function evaldiffdpoly2(x,A)
    Q2 = 0
    Q′=0
    Q=0
    for a in @view A[1:end]
        Q2 = Q2*x+2Q′
        Q′= Q′*x+Q
        Q = Q*x+a
    end
    return Q2
end

# Задача 2

function evaldiffdpoly3(x,A)
    Q3 = 0
    Q2 = 0
    Q′=0
    Q=0
    for a in @view A[1:end]
        Q3 = Q3*x+3Q2
        Q2 = Q2*x+2Q′
        Q′= Q′*x+Q
        Q = Q*x+a
    end
    return Q3
end

# Задача 3

function evaldiffpolyk(x,A,k)
    q=zeros(Int64,k-1)
    Q=0
    for a in A
        i=k-1
        while i>1
            q[i]=q[i]*x+q[i-1]
            i=i-1
        end
        q[1]=q[1]*x+Q
        Q=Q*x+a
    end
    n=1
    for i in 1:k-1
        q[i]=q[i]*n
        n=n*(n+1)
    end
    return Q,q
end

# Задача 4

import Pkg
Pkg.add("Polynomials")
using Polynomials
using .Polynoms
function diff(p::Polynomialx,x; ord=2)
    Q = eval_poly(x,p)
    Qn = eval_polyN(x,p,ord)
    return Q-Qn
end

function eval_poly(x,A)
    Q = first(A)
    for a in @view A[2:end]
        Q=Q*x+a
    end
    return Q
end

# Задача 5

function divrem(a,b)
    q=[]
    r=copy(a)
    while length(r)>=length(b)
        k=length(r)-length(b)
        c=vcat(b,zeros(Int64,k))
        push!(q,r[1])
        r=r-r[1]*c
        deleteat!(r,1)
    end
    return q,r
end

# Задача 6

function %(p::Polynom, b)
    coeff=zeros(Rational{Int}, size(p))
    coeffs=p.coeff
    for i in eachindex(p.coeff)
        coeff[i]=coeffs[i]%b
    end
    return Polynom(coeff)
end

function ÷(p::Polynom, b)
    coeff=zeros(Rational{Int}, size(p))
    coeffs=p.coeff
    for i in eachindex(p.coeff)
        coeff[i]=coeffs[i]÷b
    end
    return Polynom(coeff)
end

# Задача 7

function diffpoly(a)
    for i in 1:length(a)-2
        a[i]=a[i]*(length(a)-i)
    end
    deleteat!(a,lastindex(a))
    return a
end

function intpoly(a)
    coeff=zeros(Rational{Int}, length(a)+1)
    for i in 1:length(a)-1
        coeff[i]=a[i]//(length(a)+1-i)
    end
    coeff[lastindex(a)]=a[lastindex(a)]
    return coeff
end

# Задача 8

function dispersion(series)
    S¹ = eltype(series)(0)
    S² = eltype(series)(0)
    D, M = 0, 0
    for (n,a) in enumerate(series)
        S¹ += a
        S² += a^2
        M = S¹/n
        D = S²/n-M^2
    end
    return D, M
end

function currentstd(series, n::Int)
    a = series[1:n]
    D, l = dispersion(a)
    return D
end

function test_currentstd()
    series = randn(Float64, 50)
    D = currentstd(series, 50)
    plot(series)
    return D
end

# Задача 9

function maxpartsum(a)
    sum=0
    mins = 0
    answer = 0
    for i in 1:lastindex(a)
        sum= sum+a[i]
        answer = max(answer, sum - mins )
        mins = min(sum, mins)
    end
    return answer
end

# Задача 10

function maxpartsum_in(a)
    sum=0
    mins = 0
    answer = 0
    k=0
    m=0
    min_p =0
    for i in 1:lastindex(a)
        sum= sum+a[i]
        curr = sum - mins
        if curr > answer
            answer = curr
            k = min_p +1
            m = i
        end
        if sum < mins
            mins = sum
            min_p = i
        end
    end
    return k, m
end