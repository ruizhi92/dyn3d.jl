module SpatialAlgebra

export TransMatrix, Mfcross

# use registered packages
using DocStringExtensions

"""
 This module contain several linear algebra functions used in 6d spatial
 linear algebra.
"""

#-------------------------------------------------------------------------------
# using 6d vector v[theta_x, theta_y, theta_z, x, y, z], get transformation
# matrix X
function TransMatrix(v::Vector{T}) where T <: AbstractFloat
    # check input size
    if length(v) != 6 error("TransMatrix method need input vector length 6") end

    # rotation
    θ = v[1:3]; r = v[4:6]
    E₁ = eye(T,3); E₂ = eye(T,3); E₃ = eye(T,3)

    if θ[1] != 0.
        E₁ = [1. 0. 0.; 0. cos(θ[1]) sin(θ[1]); 0. -sin(θ[1]) cos(θ[1])]
    end
    if θ[2] != 0.
        E₂ = [cos(θ[2]) 0. -sin(θ[2]); 0. 1. 0.; sin(θ[2]) 0. cos(θ[2])]
    end
    if θ[3] != 0.
        E₃ = [cos(θ[3]) sin(θ[3]) 0.; -sin(θ[3]) cos(θ[3]) 0.; 0. 0. 1.]
    end
    E = E₃*E₂*E₁

    # translation
    rcross = [0. -r[3] r[2]; r[3] 0. -r[1]; -r[2] r[1] 0.]

    # combine, return X
    X = [E zeros(T,3,3); zeros(T,3,3) E]*
        [eye(T,3) zeros(T,3,3); -rcross eye(T,3)]
end

#-------------------------------------------------------------------------------
# 6d motion vector m cross 6d force vector f
function Mfcross(m::Vector{T}, f::Vector{T}) where T <: AbstractFloat
    ω = m[1:3]; v = m[4:6]
    ωcross = [0. -ω[3] ω[2]; ω[3] 0. -ω[1]; -ω[2] ω[1] 0.]
    vcross = [0. -v[3] v[2]; v[3] 0. -v[1]; -v[2] v[1] 0.]
    p = Vector{T}(6)
    p[1:3] = ωcross*f[1:3] + vcross*f[4:6]
    p[4:6] = ωcross*f[4:6]
    return p
end



end