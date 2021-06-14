function merge(A,B)
    C = promote_type(eltype(A), eltype(B))[]
    i, j = 1, 1
    n, m = 1, 1
    while i <= length(A)  || j <= length(B)
        while i <= length(A) && ( A[i] <= B[m] || j > length(B))
            push!(C, A[i])
            i += 1
            n += 1
        end
        if n > length(A)
            n -= 1
        end
        while j <= length(B) && (B[j] <= A[n] || i > length(A))
            push!(C,B[j])
            j += 1
            m += 1
        end
        if m > length(B)
            m -= 1
        end
    end

    return C
end

function merge1(A,B)
    C = Vector{promote_type(eltype(A), eltype(B))}(undef, length(A) + length(B))
    k = 1
    i, j = 1, 1
    n, m = 1, 1
    while i <= length(A)  || j <= length(B)
        while i <= length(A) && ( A[i] <= B[m] || j > length(B))
            C[k] = A[i]
            i += 1
            n += 1
            k += 1
        end
        if n > length(A)
            n -= 1
        end
        while j <= length(B) && (B[j] <= A[n] || i > length(A))
            C[k] = B[j]
            j += 1
            m += 1
            k += 1
        end
        if m > length(B)
            m -= 1
        end
    end

    return C
end

function merge!(A, B, C)
    i, j, k = 1, 1, 1
    D = promote_type(eltype(A), eltype(B),eltype(C))[]
    while i <= length(A) || j <= length(B) || k <= length(C)
        min_El = typemax(promote_type(eltype(A), eltype(B),eltype(C)))
        if i <= length(A) && A[i] <= min_El
            min_El = A[i]
            determinator = 1
        end
        if j <= length(B) && B[j] <= min_El
            min_El = B[j]
            determinator = 2
        end
        if k <= length(C) && C[k] <= min_El
            min_El = C[k]
            determinator = 3
        end
        push!(D, min_El)
        if determinator == 1
            i += 1
        elseif  determinator == 2
            j += 1
        else
            k += 1
        end
    end
    C = D
    return C
end

# Задача 2

function minsort(A,b)
    A1 = (eltype(A))[]
    A2 = (eltype(A))[]
    A3 = (eltype(A))[]
    for i in firstindex(A):lastindex(A)
        if A[i]<b
            push!(A1,A[i])
        elseif A[i]==b
            push!(A2,A[i])
        else
            push!(A3,A[i])
        end
    end
    A=vcat(A1,A2,A3)
    return A
end

function minsort2(A,b)
    A1 = Array{eltype(A)}(undef,length(A))
    A2 = Array{eltype(A)}(undef,length(A))
    A3 = Array{eltype(A)}(undef,length(A))
    j=1
    k=1
    l=1
    for i in firstindex(A):lastindex(A)
        if A[i]<b
            A1[j]=A[i]
            j=j+1
        elseif A[i]==b
            A2[k]=A[i]
            k=k+1
        else
            A3[l]=A[i]
            l=l+1
        end
    end
    A[1:j-1]=A1[1:j-1]
    A[j:j+k-2]=A2[1:k-1]
    A[j+k-1:j+k+l-3]=A3[1:l-1]
    return A
end

function minsort3(A,b)
    i=1
    j=1
    l=lastindex(A)
    k=2
    while k<l
        while A[i]>=b && k<l
            if A[i]==b
                A[k],A[i]=A[i],A[k]
                k=k+1
            end
            if A[i]>b
                A[l],A[i]=A[i],A[l]
                l=l-1
            end
        end
        if j>k
            k=j+1
        end
        j=j+1
        i=i+1
    end
    return A
end

# Задача 3

function particalsort!(A, b)
    l = 1
    r = length(A)
    while l < r
        while A[r] > b
            r -= 1
        end
        while A[l] <= b
            l += 1
        end
        if r > l
            A[l], A[r] = A[r], A[l]
        end
    end
end

# Задача 4

function binomial_coeffs(n::Integer)::Vector{Int}
    if n == 1
        return [1]
    end
    if n == 2
        return [1, 1]
    end
    c = [1, 1]
    for _ in 3:n
        c=[1, (view(c[1:end-1]) .+ view(c[2:end])), 1]
    end
    return c
end

function binomial_coeffs1(n::Integer)
    if n == 1
        return [1]
    end
    if n == 2
        return [1, 1]
    end
    c = [1 , 1]
    m = 2
    for _ in 3:n
        for i in 1:(m - 1)
            c[i] = c[i] + c[i+1]
            m += 1
        end
        pushfirst!(c, 1)
    end
    return c
end

# Задача 5

function C(n, k)
    if k == 0 || k == n
        return 1
    else
        return C(n - 1, k) + C(n-1, k-1)
    end
end

function get_basic_Bernstein(n, x)
    coeffs = []
    for k in 1:n
        push!(coeffs, C(n, k) * x^k * (1 - x)^(n - k))
    end
    return coeffs
end

function Bernstein_polynom(f::Function, n, x)
    coeffs = get_basic_Bernstein(n,x)
    result = 0
    for k in 1:n
        result += f(k/n) * coeffs[k]
    end
    return result
end

function Bernstein_polynom(f, n, x)
    coeffs = get_basic_Bernstein(n, x)
    result = 0
    for k in 1:n
        result += coeffs[k]*f[k]
    end
    return result
end

function test_Bernstein()
    test1 = []
    test2 = []
    for i in 0:100
        k = i / 100
        push!(test1, 2^k)
        push!(test2, Bernstein_polynom(x->2^x, 30, k))
    end
    plot(test1)
    plot(test2)
end