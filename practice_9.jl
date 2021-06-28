function cosx(x, n)
    an = 1
    sn = 0
    m = 2
    sqrX = x^2
    for i in 0:(n+1)
        sn += an
        an = - an * sqrX /(m-1)/m
        m += 2
    end

    return sn
end

# Задача 2

function accurate_cosx(x)
    an = 1
    sqrX = x^2
    sn = 0
    m = 2
    while abs(an) > eps()
        sn += an
        an = - an * sqrX /(m-1)/m
        m += 2
    end
    return sn
end

# Задача 3

using Plots
function makeCosPlots()
    x = 0:0.01:1.00
    yn2, yn4, yn8, yn16 = [], [], [], []
    for i in x
        push!(yn2, cosx(i, 2))
    end
    for i in x
        push!(yn4, cosx(i, 4))
    end
    for i in x
        push!(yn8, cosx(i, 8))
    end
    for i in x
        push!(yn16, cosx(i, 16))
    end
    p = plot(x, yn2)
    plot!(p, x, yn4)
    plot!(p, x, yn8)
    plot!(p, x, yn16)
    display(p)
end

# Задача 4

function ln(x)
    sn = 0
    k = 0
    bk =  -(1 - x)
    while abs(bk) > eps()
        ak  = bk / (k+1)
        k += 1
        sn += ak
        bk *= (1-x)
    end

    return sn
end

function row2(x)
    sn = 1
    ak = -0.5 * x
    k = 1
    while abs(ak) > eps()
        sn += ak
        ak *= (x - k)*x
        k += 1
        ak = ak / k
    end

    return sn
end

function row3(x)
    uk = -x*x
    vk = 1
    wk = 1
    sn = 0
    k = 1
    while abs(uk*(vk + wk)) > eps()
        sn += uk*(vk + wk)
        uk = -uk * x * x
        vk = vk /(k + 1)
        wk = wk /2k/(2k + 1)
        k += 1
    end

    return sn
end

function test_rows()
    println(ln(0.5), " ", log(0.5))
    println(row2(0.5), " ", 1/sqrt(1.5))
    println(row3(0.5), " ", 0.5*sin(0.5) - exp(-0.25))
end

# Задача 5

function besselj(m, x)
    sn = 0
    an = 1/factorial(m)
    k = 0
    while abs(an) > eps()
        sn += an
        an = -an * x * x/4/(k+1)/(k+m+1)
        k += 1
    end

    sn *= (x/2)^m

    return sn

end

function besselj_plots()
    x = 0:0.02:20
    y1, y2, y3, y4, y5, y6 =[], [], [], [], [], []
    for i in x
        push!(y1, besselj(0, i))
        push!(y2, besselj(1, i))
        push!(y3, besselj(2, i))
        push!(y4, besselj(3, i))
        push!(y5, besselj(4, i))
        push!(y6, besselj(5, i))
    end
    p = plot(x, y1)
    plot!(p, x, y2)
    plot!(p, x, y3)
    plot!(p, x, y4)
    plot!(p, x, y5)
    plot!(p, x, y6)
    display(p)

end

# Задача 6

function linsolve(A, b)
    x = similar(b)
    for k in lastindex(b):-1:firstindex(b)
        x[k] = (b[k] - sum(A[k, k+1:lastindex(A, 2)].*x[k+1:lastindex(x)]))/A[k,k]
    end

    return x
end

# Задача 7

isapproxzero(a) = isapprox(a, 0.0; atol = 1e-8)

function findMaxAbsInColumn(A::Matrix, k)
    rows, _ = size(A)
    maxPosition = k
    for i in k+1:rows
        if abs(A[i, k]) > abs(A[maxPosition, k])
            maxPosition = i
        end
    end

    return maxPosition
end

function column_to_zeroes!(A, k, maxPosition)
    if maxPosition != k
        A[k, :], A[maxPosition, :] = A[maxPosition, :], A[k, :]
    end

    if isapproxzero(A[k,k])
        for i in k:lastindex(A,1)
            A[i, k] = 0
            return
        end
    end

    for i in k+1:(lastindex(A, 1))
        if isapproxzero(A[i,k])
            A[i,k] = 0
            continue
        end
        t = -A[i,k]/A[k,k]
        A[i, i:end] += t *(A[k, i:end])
        A[i,k] = 0
    end
end

function convert!(A)
    rows, columns = size(A)
    for k in 1:rows
        imax = findMaxAbsInColumn(A, k)
        column_to_zeroes!(A, k, imax)
    end
end

# Задача 8

function issingular_convert!(A)
    rows, columns = size(A)
    for k in 1:columns
        imax = findMaxAbsInColumn(A, k)
        column_to_zeroes!(A, k, imax)
        if A[k, k] == 0
            return false
        end
    end
    return true
end

function det(A)
    isntDegenerate = issingular_convert!(A)
    if isntDegenerate == false
        return eltype(A)(0)
    else
        det = eltype(A)(1)
        for i in 1:lastindex(A, 1)
            det *= A[i, i]
        end
        return det
    end
end

# Задача 9

function inv(A)
    hasInv = issingular_convert!(copy(A))
    if hasInv == false
        return nothing
    end
    rows, columns = size(A)
    E = A^0
    D = Matrix{eltype(A)}(undef, rows, 2columns)
    for i in 1:rows
        D[i, :] = append!(copy(A[i, :]), E[i, :])
    end
    convert!(D)
    for i in 1:rows
        E[i, :] = D[i, rows+1:2rows]
    end

    return E
end

# Задача 10

function rang(A; isStep = false)::Int
    if isStep == false
        convert!(A)
    end
    rows, _ = size(A)
    for i in 1:rows
        if A[i, i] == 0
            return i-1
        end
    end
    return rows
end

# Задача 11

function solveSLAE(A)
    rangA = rang(A, isStep = true)
    rows, columns = size(A)
    if rangA == rows
        return zeros(rows)
    end
    k = 0
    for i in rows:-1:1
        if A[i, i] != 0
            k = i
            break
        end
    end

    A[k, k:columns] = A[k, k:columns]/A[k,k]
    for i in k-1:-1:firstindex(b)
        for j in columns:-1:i+1
            if isapproxzero(A[i, j])
                A[i,j] = 0
                continue
            end
            A[i, j:columns] = A[i, j:columns] - A[j, j:columns]/A[j,j]* A[i,j]
        end
        A[i, i:columns] = A[i, i:columns] / A[i,i]
    end

    c = []
    for i in 1:columns-k
        push!(c, "c"*"$i")
    end
    FRS = []
    for i in k:-1:1
        newline = "x$i = "
        for j in k+1:columns
            b = A[i,j]
            if b > 0
                newline = newline * " - $b *" *c[j-k]
            elseif  b < 0
                b *= -1
                newline = newline * " + $b * "*c[j-k]
            end
        end
        if newline == "x$i = "
            newline = newline * "0"
        end
        push!(FRS, newline)
    end
    for i in k+1:columns
        pushfirst!(FRS, "x$i = " * c[i - k])
    end
    return FRS
end

# Задача 12

function solveNSLAE(D)
    basic_numbers = []
    rows, columns = size(D)

    if D[rows, columns] != 0
        for i in (columns-1):-1:1
            if D[rows, i] != 0
                break
            end

            if i == 1
                return nothing
            end
        end
    end

    for i in 1:rows
        for j in (columns - 1):-1:1
            if j == 1
                push!(basic_numbers, 1)
                break
            end
            if D[i, j] == 0
                push!(basic_numbers, j-1)
                break
            end
        end
    end

    D[rows, :] = D[rows, :]/D[rows,basic_numbers[1]]
    rows -= 1
    for k in 2:lastindex(basic_numbers)
        for i in 1:k
            D[rows, i:columns] = D[rows, i:columns] - D[rows, i] * D[rows + i, i:columns]
        end
        D[rows, :] = D[rows, :] / D[rows, basic_numbers[k]]
        rows -= 1
    end
    x = D[:, columns]
    return x
end
