module NotesData
# ===================
using CSV
using DataFrames
using Random
using Statistics
using StatsBase
# ====================
export NotesData
# ===========
function remove_outliers!(xdf::DataFrame, colindex::Int64)
    q1 = quantile(xdf[!, colindex], 0.25)
    q3 = quantile(xdf[!, colindex], 0.75)
    iqr = q3 - q1
    lower_bound = q1 - 1.5 * iqr
    upper_bound = q3 + 1.5 * iqr
    xdf = xdf[xdf[!, colindex].<upper_bound, :]
    xdf = xdf[xdf[!, colindex].>lower_bound, :]
end
# ===================
function remove_all_outliers!(xdf::DataFrame)
    for colindex in 1:ncol(xdf)
        column_type = eltype(xdf[:, colindex])
        if column_type <: Union{Missing,Number}
            remove_outliers!(xdf, colindex)
        end
    end
    return xdf
end
# =================
function value_to_int(x)
    if ismissing(x)
        return missing
    else
        return Int64(x)
    end
end
function convert_to_ranks(x::DataFrame)::DataFrame
    z = copy(x)
    for i in 1:ncol(z)
        if eltype(z[:, i]) <: Union{Missing,Number}
            z[:, i] = competerank(z[:, i])
            z[:, i] = value_to_int.(z[:, i])
        end
    end
    return z
end
function get_notes_dataframe(;
    filepath::String="../data/notes_all.csv",
    missingstring::String="NA",
    sep::String=",",
    drop::Bool=false,
    ranks::Bool=false)::DataFrame
    # =========
    df = DataFrame(CSV.File(filepath, missingstring=missingstring, delim=sep))
    df.TP7 = Float64.(df.TP7)
    # =========
    if drop == true
        df = dropmissing(df)
    end
    # ==================
    if ranks == true
        for i in 2:ncol(df)
            df[:, i] = competerank(df[:, i])
            df[:, i] = value_to_int.(df[:, i])
        end
    end
    # ==================
    # Suffle the rows
    shuffle!(df)
    return df
end
# ===============
function discretize_notes(x)::Vector{Int64}
    n = length(x)
    result = zeros(Int64, n)
    for i in 1:n
        vx = x[i]
        if vx < 5
            result[i] = 1
        elseif vx < 8
            result[i] = 2
        elseif vx < 12
            result[i] = 3
        elseif vx < 17
            result[i] = 4
        else
            result[i] = 5
        end
    end
    return result
end
# =================
function compute_occurences(x1::Vector{Int64}, x2::Vector{Int64}; nc::Int64=5)
    occurences = zeros(Float64, nc, nc)
    ntotal = 0
    for i in 1:length(x1)
        xi = x1[i]
        if xi < 1 || xi > nc || i > length(x2)
            continue
        end
        xj = x2[i]
        if xj < 1 || xj > nc
            continue
        end
        occurences[xi, xj] += 1
        ntotal += 1
    end
    # Normalize the occurences matrix
    if ntotal > 0
        occurences ./= ntotal
    end
    # round the values to 2 decimal places
    occurences = round.(occurences, digits=4)
    # return result
    return occurences
end
# =================
# end module
end

