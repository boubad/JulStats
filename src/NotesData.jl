module NotesData
# ===================
using CSV
using DataFrames
using Random
using Statistics
using StatsBase
# ====================
export NotesData
export get_notes_dataframe
export convert_to_ranks
export remove_outliers!
export remove_all_outliers!
# =================
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
# =================
# end module
end

