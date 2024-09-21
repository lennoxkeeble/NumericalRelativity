module Multipoles

const levi_civita_table = Dict(
    (1, 2, 3) => 1,
    (2, 3, 1) => 1,
    (3, 1, 2) => 1,
    (3, 2, 1) => -1,
    (2, 1, 3) => -1,
    (1, 3, 2) => -1
)

function ε(i::Int, j::Int, k::Int)::Int
    return get(levi_civita_table, (i, j, k), 0)
end

δ(x::Int, y::Int)::Int = x == y ? 1 : 0

# define mass-ratio parameter
η(q::Float64) = q/((1+q)^2)   # q = mass ratio

# define multipole moments

Mass_quad_prefactor(m::Float64, M::Float64) = η(m/M) * (1.0 + m)

Mij(xH::AbstractArray, i::Int, j::Int) = -0.3333333333333333*(δ(i,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2)) + xH[i]*xH[j]

Mij(xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int) = Mij(xH, i, j) * Mass_quad_prefactor(m, M);

ddotMij(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, i::Int, j::Int) = 2*vH[i]*vH[j] - (2*δ(i,j)*(vH[1]^2 + vH[2]^2 + vH[3]^2 + xH[1]*aH[1] + xH[2]*aH[2] + xH[3]*aH[3]))/3. + xH[j]*aH[i] + xH[i]*aH[j]

ddotMij(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int) = ddotMij(aH, vH, xH, i, j) * Mass_quad_prefactor(m, M)

Mass_oct_prefactor(m::Float64, M::Float64) = -η(m/M) * (1.0 - m)

Mijk(xH::AbstractArray, i::Int, j::Int, k::Int) = -(xH[i]*xH[j]*xH[k]) + ((xH[1]^2 + xH[2]^2 + xH[3]^2)*(δ(j,k)*xH[i] + δ(i,k)*xH[j] + δ(i,j)*xH[k]))/5.

Mijk(xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int, k::Int) = Mijk(xH, i, j, k) * Mass_oct_prefactor(m, M)

ddotMijk(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, i::Int, j::Int, k::Int) = (4*(xH[1]*vH[1] + xH[2]*vH[2] + xH[3]*vH[3])*(δ(j,k)*vH[i] + δ(i,k)*vH[j] + δ(i,j)*vH[k]) - 10*vH[i]*(xH[k]*vH[j] + xH[j]*vH[k]) + 2*(δ(j,k)*xH[i] + δ(i,k)*xH[j] + δ(i,j)*xH[k])*(vH[1]^2 + vH[2]^2 + vH[3]^2 + xH[1]*aH[1] + xH[2]*aH[2] + xH[3]*aH[3]) -
5*xH[j]*xH[k]*aH[i] + (xH[1]^2 + xH[2]^2 + xH[3]^2)*(δ(j,k)*aH[i] + δ(i,k)*aH[j] + δ(i,j)*aH[k]) - 5*xH[i]*(2*vH[j]*vH[k] + xH[k]*aH[j] + xH[j]*aH[k]))/5.

ddotMijk(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int, k::Int)  = ddotMijk(aH, vH, xH, i, j, k) * Mass_oct_prefactor(m, M)

Mass_hex_prefactor(m::Float64, M::Float64) = η(m/M) * (1.0 + m)

Mijkl(xH::AbstractArray, i::Int, j::Int, k::Int, l::Int) = ((δ(i,l)*δ(j,k) + δ(i,k)*δ(j,l) + δ(i,j)*δ(k,l))*(xH[1]^2 + xH[2]^2 + xH[3]^2)^2)/35. + xH[i]*xH[j]*xH[k]*xH[l] - ((xH[1]^2 + xH[2]^2 + xH[3]^2)*(δ(k,l)*xH[i]*xH[j] + δ(j,l)*xH[i]*xH[k] + δ(i,l)*xH[j]*xH[k] + (δ(j,k)*xH[i] + δ(i,k)*xH[j] + δ(i,j)*xH[k])*xH[l]))/7.

Mijkl(xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int, k::Int, l::Int) = Mijkl(xH, i, j, k, l) * Mass_hex_prefactor(m, M)

ddotMijkl(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, i::Int, j::Int, k::Int, l::Int) = 2*(xH[j]*vH[i] + xH[i]*vH[j])*(xH[l]*vH[k] + xH[k]*vH[l]) - (4*(xH[1]*vH[1] + xH[2]*vH[2] + xH[3]*vH[3])*(δ(k,l)*(xH[j]*vH[i] + xH[i]*vH[j]) + xH[l]*(δ(j,k)*vH[i] + δ(i,k)*vH[j] + δ(i,j)*vH[k]) + δ(j,l)*(xH[k]*vH[i] + xH[i]*vH[k]) + δ(i,l)*(xH[k]*vH[j] + xH[j]*vH[k]) +
(δ(j,k)*xH[i] + δ(i,k)*xH[j] + δ(i,j)*xH[k])*vH[l]))/7. - (2*(δ(k,l)*xH[i]*xH[j] + δ(j,l)*xH[i]*xH[k] + δ(i,l)*xH[j]*xH[k] + (δ(j,k)*xH[i] + δ(i,k)*xH[j] + δ(i,j)*xH[k])*xH[l])*(vH[1]^2 + vH[2]^2 + vH[3]^2 + xH[1]*aH[1] + xH[2]*aH[2] + xH[3]*aH[3]))/7. + ((δ(i,l)*δ(j,k) + δ(i,k)*δ(j,l) + δ(i,j)*δ(k,l))*(8*(xH[1]*vH[1] + xH[2]*vH[2] + xH[3]*vH[3])^2 + 4*(xH[1]^2 +
xH[2]^2 + xH[3]^2)*(vH[1]^2 + vH[2]^2 + vH[3]^2 + xH[1]*aH[1] + xH[2]*aH[2] + xH[3]*aH[3])))/35. + xH[k]*xH[l]*(2*vH[i]*vH[j] + xH[j]*aH[i] + xH[i]*aH[j]) + xH[i]*xH[j]*(2*vH[k]*vH[l] + xH[l]*aH[k] + xH[k]*aH[l]) - ((xH[1]^2 + xH[2]^2 + xH[3]^2)*(2*δ(i,l)*vH[j]*vH[k] + 2*δ(j,k)*vH[i]*vH[l] + 2*δ(i,k)*vH[j]*vH[l] + 2*δ(i,j)*vH[k]*vH[l] + δ(j,k)*xH[l]*aH[i] +
δ(i,l)*xH[k]*aH[j] + δ(i,k)*xH[l]*aH[j] + δ(k,l)*(2*vH[i]*vH[j] + xH[j]*aH[i] + xH[i]*aH[j]) + δ(i,l)*xH[j]*aH[k] + δ(i,j)*xH[l]*aH[k] + δ(j,l)*(2*vH[i]*vH[k] + xH[k]*aH[i] + xH[i]*aH[k]) + (δ(j,k)*xH[i] + δ(i,k)*xH[j] + δ(i,j)*xH[k])*aH[l]))/7.

ddotMijkl(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int, k::Int, l::Int) = ddotMijkl(aH, vH, xH, i, j, k, l) * Mass_hex_prefactor(m, M)

Current_quad_prefactor(m::Float64, M::Float64) = -η(m/M) * (1.0 - m)

Sij(xH::AbstractArray, x_H::AbstractArray, vH::AbstractArray, i::Int, j::Int) = (-3*((ε(1,1,j)*xH[1] + ε(2,1,j)*xH[2] + ε(3,1,j)*xH[3])*xH[i] + (ε(1,1,i)*xH[1] + ε(2,1,i)*xH[2] + ε(3,1,i)*xH[3])*xH[j])*vH[1] - 3*((ε(1,2,j)*xH[1] + ε(2,2,j)*xH[2] + ε(3,2,j)*xH[3])*xH[i] + (ε(1,2,i)*xH[1] + ε(2,2,i)*xH[2] + ε(3,2,i)*xH[3])*xH[j])*vH[2] - 3*((ε(1,3,j)*xH[1] +
ε(2,3,j)*xH[2] + ε(3,3,j)*xH[3])*xH[i] + (ε(1,3,i)*xH[1] + ε(2,3,i)*xH[2] + ε(3,3,i)*xH[3])*xH[j])*vH[3] + 2*δ(i,j)*(xH[1]^2*(ε(1,1,1)*vH[1] + ε(1,2,1)*vH[2] + ε(1,3,1)*vH[3]) + xH[2]^2*(ε(2,1,2)*vH[1] + ε(2,2,2)*vH[2] + ε(2,3,2)*vH[3]) + xH[2]*xH[3]*((ε(2,1,3) + ε(3,1,2))*vH[1] + (ε(2,2,3) + ε(3,2,2))*vH[2] + (ε(2,3,3) + ε(3,3,2))*vH[3]) + xH[3]^2*(ε(3,1,3)*vH[1] +
ε(3,2,3)*vH[2] + ε(3,3,3)*vH[3]) + xH[1]*(xH[2]*((ε(1,1,2) + ε(2,1,1))*vH[1] + (ε(1,2,2) + ε(2,2,1))*vH[2] + (ε(1,3,2) + ε(2,3,1))*vH[3]) + xH[3]*((ε(1,1,3) + ε(3,1,1))*vH[1] + (ε(1,2,3) + ε(3,2,1))*vH[2] + (ε(1,3,3) + ε(3,3,1))*vH[3]))))/6.

Sij(xH::AbstractArray, x_H::AbstractArray, vH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int) = Sij(xH, x_H, vH, i, j) * Current_quad_prefactor(m, M)

dotSij(aH::AbstractArray, vH::AbstractArray, v_H::AbstractArray, xH::AbstractArray, x_H::AbstractArray, i::Int, j::Int) = (-3*((xH[1]*(ε(1,1,j)*vH[1] + ε(1,2,j)*vH[2] + ε(1,3,j)*vH[3]) + xH[2]*(ε(2,1,j)*vH[1] + ε(2,2,j)*vH[2] + ε(2,3,j)*vH[3]) + xH[3]*(ε(3,1,j)*vH[1] + ε(3,2,j)*vH[2] + ε(3,3,j)*vH[3]))*vH[i] + (xH[1]*(ε(1,1,i)*vH[1] + ε(1,2,i)*vH[2] +
ε(1,3,i)*vH[3]) + xH[2]*(ε(2,1,i)*vH[1] + ε(2,2,i)*vH[2] + ε(2,3,i)*vH[3]) + xH[3]*(ε(3,1,i)*vH[1] + ε(3,2,i)*vH[2] + ε(3,3,i)*vH[3]))*vH[j] + xH[j]*(ε(1,1,i)*vH[1]^2 + ε(2,2,i)*vH[2]^2 + (ε(2,3,i) + ε(3,2,i))*vH[2]*vH[3] + ε(3,3,i)*vH[3]^2 + vH[1]*((ε(1,2,i) + ε(2,1,i))*vH[2] + (ε(1,3,i) + ε(3,1,i))*vH[3]) + ε(1,1,i)*xH[1]*aH[1] + ε(2,1,i)*xH[2]*aH[1] +
ε(3,1,i)*xH[3]*aH[1] + ε(1,2,i)*xH[1]*aH[2] + ε(2,2,i)*xH[2]*aH[2] + ε(3,2,i)*xH[3]*aH[2] + (ε(1,3,i)*xH[1] + ε(2,3,i)*xH[2] + ε(3,3,i)*xH[3])*aH[3]) + xH[i]*(ε(1,1,j)*vH[1]^2 + ε(2,2,j)*vH[2]^2 + (ε(2,3,j) + ε(3,2,j))*vH[2]*vH[3] + ε(3,3,j)*vH[3]^2 + vH[1]*((ε(1,2,j) + ε(2,1,j))*vH[2] + (ε(1,3,j) + ε(3,1,j))*vH[3]) + ε(1,1,j)*xH[1]*aH[1] + ε(2,1,j)*xH[2]*aH[1] +
ε(3,1,j)*xH[3]*aH[1] + ε(1,2,j)*xH[1]*aH[2] + ε(2,2,j)*xH[2]*aH[2] + ε(3,2,j)*xH[3]*aH[2] + (ε(1,3,j)*xH[1] + ε(2,3,j)*xH[2] + ε(3,3,j)*xH[3])*aH[3])) + 2*δ(i,j)*(xH[1]^2*(ε(1,1,1)*aH[1] + ε(1,2,1)*aH[2] + ε(1,3,1)*aH[3]) + xH[2]^2*(ε(2,1,2)*aH[1] + ε(2,2,2)*aH[2] + ε(2,3,2)*aH[3]) + xH[3]*((ε(1,1,3) + ε(3,1,1))*vH[1]^2 + (ε(2,2,3) + ε(3,2,2))*vH[2]^2 +
(ε(2,3,3) + 2*ε(3,2,3) + ε(3,3,2))*vH[2]*vH[3] + 2*ε(3,3,3)*vH[3]^2 + vH[1]*((ε(1,2,3) + ε(2,1,3) + ε(3,1,2) + ε(3,2,1))*vH[2] + (ε(1,3,3) + 2*ε(3,1,3) + ε(3,3,1))*vH[3]) + ε(3,1,3)*xH[3]*aH[1] + ε(3,2,3)*xH[3]*aH[2] + ε(3,3,3)*xH[3]*aH[3]) + xH[1]*(2*ε(1,1,1)*vH[1]^2 + (ε(1,2,2) + ε(2,2,1))*vH[2]^2 + (ε(1,2,3) + ε(1,3,2) + ε(2,3,1) + ε(3,2,1))*vH[2]*vH[3] +
vH[1]*((ε(1,1,2) + 2*ε(1,2,1) + ε(2,1,1))*vH[2] + (ε(1,1,3) + 2*ε(1,3,1) + ε(3,1,1))*vH[3]) + ((ε(1,1,2) + ε(2,1,1))*xH[2] + (ε(1,1,3) + ε(3,1,1))*xH[3])*aH[1] + ((ε(1,2,2) + ε(2,2,1))*xH[2] + (ε(1,2,3) + ε(3,2,1))*xH[3])*aH[2] + (ε(1,3,2) + ε(2,3,1))*xH[2]*aH[3] + (ε(1,3,3) + ε(3,3,1))*(vH[3]^2 + xH[3]*aH[3])) + xH[2]*((ε(1,1,2) + ε(2,1,1))*vH[1]^2 +
2*ε(2,2,2)*vH[2]^2 + (ε(2,2,3) + 2*ε(2,3,2) + ε(3,2,2))*vH[2]*vH[3] + vH[1]*((ε(1,2,2) + 2*ε(2,1,2) + ε(2,2,1))*vH[2] + (ε(1,3,2) + ε(2,1,3) + ε(2,3,1) + ε(3,1,2))*vH[3]) + xH[3]*((ε(2,1,3) + ε(3,1,2))*aH[1] + (ε(2,2,3) + ε(3,2,2))*aH[2]) + (ε(2,3,3) + ε(3,3,2))*(vH[3]^2 + xH[3]*aH[3]))))/6.

dotSij(aH::AbstractArray, vH::AbstractArray, v_H::AbstractArray, xH::AbstractArray, x_H::AbstractArray, m::Float64, M::Float64, i::Int, j::Int) = dotSij(aH, vH, vH, xH, xH, i, j) * Current_quad_prefactor(m, M)

Current_oct_prefactor(m::Float64, M::Float64) = η(m/M) * (1.0 + m)

Sijk(vH::AbstractArray, xH::AbstractArray, i::Int, j::Int, k::Int) = (xH[1]*(-(δ(j,k)*(ε(1,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] +
ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[k]) + 5*(ε(1,1,i)*xH[j]*xH[k] + xH[i]*(ε(1,1,k)*xH[j] + ε(1,1,j)*xH[k])))*vH[1] + xH[2]*(-(δ(j,k)*(ε(2,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[j]) -
δ(i,j)*(ε(2,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[k]) + 5*(ε(2,1,i)*xH[j]*xH[k] + xH[i]*(ε(2,1,k)*xH[j] + ε(2,1,j)*xH[k])))*vH[1] + xH[3]*(-(δ(j,k)*(ε(3,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) +
2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[k]) + 5*(ε(3,1,i)*xH[j]*xH[k] + xH[i]*(ε(3,1,k)*xH[j] + ε(3,1,j)*xH[k])))*vH[1] + xH[1]*(-(δ(j,k)*(ε(1,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] +
ε(1,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*xH[k]) + 5*(ε(1,2,i)*xH[j]*xH[k] + xH[i]*(ε(1,2,k)*xH[j] + ε(1,2,j)*xH[k])))*vH[2] + xH[2]*(-(δ(j,k)*(ε(2,2,i)*(xH[1]^2 +
xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[k]) + 5*(ε(2,2,i)*xH[j]*xH[k] + xH[i]*(ε(2,2,k)*xH[j] +
ε(2,2,j)*xH[k])))*vH[2] + xH[3]*(-(δ(j,k)*(ε(3,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] +
ε(3,2,3)*xH[3])*xH[k]) + 5*(ε(3,2,i)*xH[j]*xH[k] + xH[i]*(ε(3,2,k)*xH[j] + ε(3,2,j)*xH[k])))*vH[2] + xH[1]*(-(δ(j,k)*(ε(1,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,3,k)*(xH[1]^2 +
xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[k]) + 5*(ε(1,3,i)*xH[j]*xH[k] + xH[i]*(ε(1,3,k)*xH[j] + ε(1,3,j)*xH[k])))*vH[3] + xH[2]*(-(δ(j,k)*(ε(2,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] +
ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,3,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[k]) + 5*(ε(2,3,i)*xH[j]*xH[k] + xH[i]*(ε(2,3,k)*xH[j] + ε(2,3,j)*xH[k])))*vH[3] + xH[3]*(-(δ(j,k)*(ε(3,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[i])) -
δ(i,k)*(ε(3,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,3,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[k]) + 5*(ε(3,3,i)*xH[j]*xH[k] + xH[i]*(ε(3,3,k)*xH[j] + ε(3,3,j)*xH[k])))*vH[3])/15.

Sijk(vH::AbstractArray, xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int, k::Int) = Sijk(vH, xH, i, j, k) * Current_quad_prefactor(m, M)

dotSijk(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, i::Int, j::Int, k::Int) = ((-(δ(j,k)*(ε(1,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] +
ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[k]) + 5*(ε(1,1,i)*xH[j]*xH[k] + xH[i]*(ε(1,1,k)*xH[j] + ε(1,1,j)*xH[k])))*vH[1]^2 + (-(δ(j,k)*(ε(1,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*xH[j]) -
δ(i,j)*(ε(1,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*xH[k]) + 5*(ε(1,2,i)*xH[j]*xH[k] + xH[i]*(ε(1,2,k)*xH[j] + ε(1,2,j)*xH[k])))*vH[1]*vH[2] + (-(δ(j,k)*(ε(2,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) +
2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[k]) + 5*(ε(2,1,i)*xH[j]*xH[k] + xH[i]*(ε(2,1,k)*xH[j] + ε(2,1,j)*xH[k])))*vH[1]*vH[2] + (-(δ(j,k)*(ε(2,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[i])) -
δ(i,k)*(ε(2,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[k]) + 5*(ε(2,2,i)*xH[j]*xH[k] + xH[i]*(ε(2,2,k)*xH[j] + ε(2,2,j)*xH[k])))*vH[2]^2 + (-(δ(j,k)*(ε(1,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] +
ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,3,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[k]) + 5*(ε(1,3,i)*xH[j]*xH[k] + xH[i]*(ε(1,3,k)*xH[j] + ε(1,3,j)*xH[k])))*vH[1]*vH[3] +
(-(δ(j,k)*(ε(3,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[k]) + 5*(ε(3,1,i)*xH[j]*xH[k] +
xH[i]*(ε(3,1,k)*xH[j] + ε(3,1,j)*xH[k])))*vH[1]*vH[3] + (-(δ(j,k)*(ε(2,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,3,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] +
ε(2,3,3)*xH[3])*xH[k]) + 5*(ε(2,3,i)*xH[j]*xH[k] + xH[i]*(ε(2,3,k)*xH[j] + ε(2,3,j)*xH[k])))*vH[2]*vH[3] + (-(δ(j,k)*(ε(3,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,2,k)*(xH[1]^2 + xH[2]^2 +
xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[k]) + 5*(ε(3,2,i)*xH[j]*xH[k] + xH[i]*(ε(3,2,k)*xH[j] + ε(3,2,j)*xH[k])))*vH[2]*vH[3] + (-(δ(j,k)*(ε(3,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[j]) -
δ(i,j)*(ε(3,3,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[k]) + 5*(ε(3,3,i)*xH[j]*xH[k] + xH[i]*(ε(3,3,k)*xH[j] + ε(3,3,j)*xH[k])))*vH[3]^2 + xH[1]*vH[1]*(-2*δ(j,k)*(ε(1,1,i)*xH[1]*vH[1] + ε(1,1,1)*xH[i]*vH[1] + ε(1,1,i)*xH[2]*vH[2] + ε(1,1,2)*xH[i]*vH[2] + ε(1,1,i)*xH[3]*vH[3] + ε(1,1,3)*xH[i]*vH[3] + (ε(1,1,1)*xH[1] +
ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(1,1,j)*xH[1]*vH[1] + ε(1,1,1)*xH[j]*vH[1] + ε(1,1,j)*xH[2]*vH[2] + ε(1,1,2)*xH[j]*vH[2] + ε(1,1,j)*xH[3]*vH[3] + ε(1,1,3)*xH[j]*vH[3] + (ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(1,1,k)*xH[1]*vH[1] + ε(1,1,1)*xH[k]*vH[1] + ε(1,1,k)*xH[2]*vH[2] + ε(1,1,2)*xH[k]*vH[2] + ε(1,1,k)*xH[3]*vH[3] +
ε(1,1,3)*xH[k]*vH[3] + (ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*vH[k]) + 5*(ε(1,1,k)*xH[j]*vH[i] + ε(1,1,j)*xH[k]*vH[i] + ε(1,1,k)*xH[i]*vH[j] + ε(1,1,i)*xH[k]*vH[j] + (ε(1,1,j)*xH[i] + ε(1,1,i)*xH[j])*vH[k])) + xH[1]*vH[2]*(-2*δ(j,k)*(ε(1,2,i)*xH[1]*vH[1] + ε(1,2,1)*xH[i]*vH[1] + ε(1,2,i)*xH[2]*vH[2] + ε(1,2,2)*xH[i]*vH[2] + ε(1,2,i)*xH[3]*vH[3] +
ε(1,2,3)*xH[i]*vH[3] + (ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(1,2,j)*xH[1]*vH[1] + ε(1,2,1)*xH[j]*vH[1] + ε(1,2,j)*xH[2]*vH[2] + ε(1,2,2)*xH[j]*vH[2] + ε(1,2,j)*xH[3]*vH[3] + ε(1,2,3)*xH[j]*vH[3] + (ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(1,2,k)*xH[1]*vH[1] + ε(1,2,1)*xH[k]*vH[1] + ε(1,2,k)*xH[2]*vH[2] +
ε(1,2,2)*xH[k]*vH[2] + ε(1,2,k)*xH[3]*vH[3] + ε(1,2,3)*xH[k]*vH[3] + (ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*vH[k]) + 5*(ε(1,2,k)*xH[j]*vH[i] + ε(1,2,j)*xH[k]*vH[i] + ε(1,2,k)*xH[i]*vH[j] + ε(1,2,i)*xH[k]*vH[j] + (ε(1,2,j)*xH[i] + ε(1,2,i)*xH[j])*vH[k])) + xH[1]*vH[3]*(-2*δ(j,k)*(ε(1,3,i)*xH[1]*vH[1] + ε(1,3,1)*xH[i]*vH[1] + ε(1,3,i)*xH[2]*vH[2] +
ε(1,3,2)*xH[i]*vH[2] + ε(1,3,i)*xH[3]*vH[3] + ε(1,3,3)*xH[i]*vH[3] + (ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(1,3,j)*xH[1]*vH[1] + ε(1,3,1)*xH[j]*vH[1] + ε(1,3,j)*xH[2]*vH[2] + ε(1,3,2)*xH[j]*vH[2] + ε(1,3,j)*xH[3]*vH[3] + ε(1,3,3)*xH[j]*vH[3] + (ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(1,3,k)*xH[1]*vH[1] +
ε(1,3,1)*xH[k]*vH[1] + ε(1,3,k)*xH[2]*vH[2] + ε(1,3,2)*xH[k]*vH[2] + ε(1,3,k)*xH[3]*vH[3] + ε(1,3,3)*xH[k]*vH[3] + (ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*vH[k]) + 5*(ε(1,3,k)*xH[j]*vH[i] + ε(1,3,j)*xH[k]*vH[i] + ε(1,3,k)*xH[i]*vH[j] + ε(1,3,i)*xH[k]*vH[j] + (ε(1,3,j)*xH[i] + ε(1,3,i)*xH[j])*vH[k])) + xH[2]*vH[1]*(-2*δ(j,k)*(ε(2,1,i)*xH[1]*vH[1] +
ε(2,1,1)*xH[i]*vH[1] + ε(2,1,i)*xH[2]*vH[2] + ε(2,1,2)*xH[i]*vH[2] + ε(2,1,i)*xH[3]*vH[3] + ε(2,1,3)*xH[i]*vH[3] + (ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(2,1,j)*xH[1]*vH[1] + ε(2,1,1)*xH[j]*vH[1] + ε(2,1,j)*xH[2]*vH[2] + ε(2,1,2)*xH[j]*vH[2] + ε(2,1,j)*xH[3]*vH[3] + ε(2,1,3)*xH[j]*vH[3] + (ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] +
ε(2,1,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(2,1,k)*xH[1]*vH[1] + ε(2,1,1)*xH[k]*vH[1] + ε(2,1,k)*xH[2]*vH[2] + ε(2,1,2)*xH[k]*vH[2] + ε(2,1,k)*xH[3]*vH[3] + ε(2,1,3)*xH[k]*vH[3] + (ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*vH[k]) + 5*(ε(2,1,k)*xH[j]*vH[i] + ε(2,1,j)*xH[k]*vH[i] + ε(2,1,k)*xH[i]*vH[j] + ε(2,1,i)*xH[k]*vH[j] + (ε(2,1,j)*xH[i] +
ε(2,1,i)*xH[j])*vH[k])) + xH[2]*vH[2]*(-2*δ(j,k)*(ε(2,2,i)*xH[1]*vH[1] + ε(2,2,1)*xH[i]*vH[1] + ε(2,2,i)*xH[2]*vH[2] + ε(2,2,2)*xH[i]*vH[2] + ε(2,2,i)*xH[3]*vH[3] + ε(2,2,3)*xH[i]*vH[3] + (ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(2,2,j)*xH[1]*vH[1] + ε(2,2,1)*xH[j]*vH[1] + ε(2,2,j)*xH[2]*vH[2] + ε(2,2,2)*xH[j]*vH[2] +
ε(2,2,j)*xH[3]*vH[3] + ε(2,2,3)*xH[j]*vH[3] + (ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(2,2,k)*xH[1]*vH[1] + ε(2,2,1)*xH[k]*vH[1] + ε(2,2,k)*xH[2]*vH[2] + ε(2,2,2)*xH[k]*vH[2] + ε(2,2,k)*xH[3]*vH[3] + ε(2,2,3)*xH[k]*vH[3] + (ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*vH[k]) + 5*(ε(2,2,k)*xH[j]*vH[i] + ε(2,2,j)*xH[k]*vH[i] +
ε(2,2,k)*xH[i]*vH[j] + ε(2,2,i)*xH[k]*vH[j] + (ε(2,2,j)*xH[i] + ε(2,2,i)*xH[j])*vH[k])) + xH[2]*vH[3]*(-2*δ(j,k)*(ε(2,3,i)*xH[1]*vH[1] + ε(2,3,1)*xH[i]*vH[1] + ε(2,3,i)*xH[2]*vH[2] + ε(2,3,2)*xH[i]*vH[2] + ε(2,3,i)*xH[3]*vH[3] + ε(2,3,3)*xH[i]*vH[3] + (ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(2,3,j)*xH[1]*vH[1] + ε(2,3,1)*xH[j]*vH[1] +
ε(2,3,j)*xH[2]*vH[2] + ε(2,3,2)*xH[j]*vH[2] + ε(2,3,j)*xH[3]*vH[3] + ε(2,3,3)*xH[j]*vH[3] + (ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(2,3,k)*xH[1]*vH[1] + ε(2,3,1)*xH[k]*vH[1] + ε(2,3,k)*xH[2]*vH[2] + ε(2,3,2)*xH[k]*vH[2] + ε(2,3,k)*xH[3]*vH[3] + ε(2,3,3)*xH[k]*vH[3] + (ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*vH[k]) +
5*(ε(2,3,k)*xH[j]*vH[i] + ε(2,3,j)*xH[k]*vH[i] + ε(2,3,k)*xH[i]*vH[j] + ε(2,3,i)*xH[k]*vH[j] + (ε(2,3,j)*xH[i] + ε(2,3,i)*xH[j])*vH[k])) + xH[3]*vH[1]*(-2*δ(j,k)*(ε(3,1,i)*xH[1]*vH[1] + ε(3,1,1)*xH[i]*vH[1] + ε(3,1,i)*xH[2]*vH[2] + ε(3,1,2)*xH[i]*vH[2] + ε(3,1,i)*xH[3]*vH[3] + ε(3,1,3)*xH[i]*vH[3] + (ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*vH[i]) -
2*δ(i,k)*(ε(3,1,j)*xH[1]*vH[1] + ε(3,1,1)*xH[j]*vH[1] + ε(3,1,j)*xH[2]*vH[2] + ε(3,1,2)*xH[j]*vH[2] + ε(3,1,j)*xH[3]*vH[3] + ε(3,1,3)*xH[j]*vH[3] + (ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(3,1,k)*xH[1]*vH[1] + ε(3,1,1)*xH[k]*vH[1] + ε(3,1,k)*xH[2]*vH[2] + ε(3,1,2)*xH[k]*vH[2] + ε(3,1,k)*xH[3]*vH[3] + ε(3,1,3)*xH[k]*vH[3] +
(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*vH[k]) + 5*(ε(3,1,k)*xH[j]*vH[i] + ε(3,1,j)*xH[k]*vH[i] + ε(3,1,k)*xH[i]*vH[j] + ε(3,1,i)*xH[k]*vH[j] + (ε(3,1,j)*xH[i] + ε(3,1,i)*xH[j])*vH[k])) + xH[3]*vH[2]*(-2*δ(j,k)*(ε(3,2,i)*xH[1]*vH[1] + ε(3,2,1)*xH[i]*vH[1] + ε(3,2,i)*xH[2]*vH[2] + ε(3,2,2)*xH[i]*vH[2] + ε(3,2,i)*xH[3]*vH[3] + ε(3,2,3)*xH[i]*vH[3] +
(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(3,2,j)*xH[1]*vH[1] + ε(3,2,1)*xH[j]*vH[1] + ε(3,2,j)*xH[2]*vH[2] + ε(3,2,2)*xH[j]*vH[2] + ε(3,2,j)*xH[3]*vH[3] + ε(3,2,3)*xH[j]*vH[3] + (ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(3,2,k)*xH[1]*vH[1] + ε(3,2,1)*xH[k]*vH[1] + ε(3,2,k)*xH[2]*vH[2] + ε(3,2,2)*xH[k]*vH[2] +
ε(3,2,k)*xH[3]*vH[3] + ε(3,2,3)*xH[k]*vH[3] + (ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*vH[k]) + 5*(ε(3,2,k)*xH[j]*vH[i] + ε(3,2,j)*xH[k]*vH[i] + ε(3,2,k)*xH[i]*vH[j] + ε(3,2,i)*xH[k]*vH[j] + (ε(3,2,j)*xH[i] + ε(3,2,i)*xH[j])*vH[k])) + xH[3]*vH[3]*(-2*δ(j,k)*(ε(3,3,i)*xH[1]*vH[1] + ε(3,3,1)*xH[i]*vH[1] + ε(3,3,i)*xH[2]*vH[2] + ε(3,3,2)*xH[i]*vH[2] +
ε(3,3,i)*xH[3]*vH[3] + ε(3,3,3)*xH[i]*vH[3] + (ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*vH[i]) - 2*δ(i,k)*(ε(3,3,j)*xH[1]*vH[1] + ε(3,3,1)*xH[j]*vH[1] + ε(3,3,j)*xH[2]*vH[2] + ε(3,3,2)*xH[j]*vH[2] + ε(3,3,j)*xH[3]*vH[3] + ε(3,3,3)*xH[j]*vH[3] + (ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*vH[j]) - 2*δ(i,j)*(ε(3,3,k)*xH[1]*vH[1] +
ε(3,3,1)*xH[k]*vH[1] + ε(3,3,k)*xH[2]*vH[2] + ε(3,3,2)*xH[k]*vH[2] + ε(3,3,k)*xH[3]*vH[3] + ε(3,3,3)*xH[k]*vH[3] + (ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*vH[k]) + 5*(ε(3,3,k)*xH[j]*vH[i] + ε(3,3,j)*xH[k]*vH[i] + ε(3,3,k)*xH[i]*vH[j] + ε(3,3,i)*xH[k]*vH[j] + (ε(3,3,j)*xH[i] + ε(3,3,i)*xH[j])*vH[k])) + xH[1]*(-(δ(j,k)*(ε(1,1,i)*(xH[1]^2 + xH[2]^2 +
xH[3]^2) + 2*(ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,1,1)*xH[1] + ε(1,1,2)*xH[2] + ε(1,1,3)*xH[3])*xH[k]) + 5*(ε(1,1,i)*xH[j]*xH[k] + xH[i]*(ε(1,1,k)*xH[j] +
ε(1,1,j)*xH[k])))*aH[1] + xH[2]*(-(δ(j,k)*(ε(2,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,1,1)*xH[1] + ε(2,1,2)*xH[2] + ε(2,1,3)*xH[3])*xH[k]) +
5*(ε(2,1,i)*xH[j]*xH[k] + xH[i]*(ε(2,1,k)*xH[j] + ε(2,1,j)*xH[k])))*aH[1] + xH[3]*(-(δ(j,k)*(ε(3,1,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,1,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,1,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) +
2*(ε(3,1,1)*xH[1] + ε(3,1,2)*xH[2] + ε(3,1,3)*xH[3])*xH[k]) + 5*(ε(3,1,i)*xH[j]*xH[k] + xH[i]*(ε(3,1,k)*xH[j] + ε(3,1,j)*xH[k])))*aH[1] + xH[1]*(-(δ(j,k)*(ε(1,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] +
ε(1,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,2,1)*xH[1] + ε(1,2,2)*xH[2] + ε(1,2,3)*xH[3])*xH[k]) + 5*(ε(1,2,i)*xH[j]*xH[k] + xH[i]*(ε(1,2,k)*xH[j] + ε(1,2,j)*xH[k])))*aH[2] + xH[2]*(-(δ(j,k)*(ε(2,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,2,j)*(xH[1]^2 +
xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,2,1)*xH[1] + ε(2,2,2)*xH[2] + ε(2,2,3)*xH[3])*xH[k]) + 5*(ε(2,2,i)*xH[j]*xH[k] + xH[i]*(ε(2,2,k)*xH[j] + ε(2,2,j)*xH[k])))*aH[2] + xH[3]*(-(δ(j,k)*(ε(3,2,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] +
ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,2,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,2,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,2,1)*xH[1] + ε(3,2,2)*xH[2] + ε(3,2,3)*xH[3])*xH[k]) + 5*(ε(3,2,i)*xH[j]*xH[k] + xH[i]*(ε(3,2,k)*xH[j] + ε(3,2,j)*xH[k])))*aH[2] +
xH[1]*(-(δ(j,k)*(ε(1,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(1,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(1,3,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(1,3,1)*xH[1] + ε(1,3,2)*xH[2] + ε(1,3,3)*xH[3])*xH[k]) +
5*(ε(1,3,i)*xH[j]*xH[k] + xH[i]*(ε(1,3,k)*xH[j] + ε(1,3,j)*xH[k])))*aH[3] + xH[2]*(-(δ(j,k)*(ε(2,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(2,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(2,3,k)*(xH[1]^2 + xH[2]^2 +
xH[3]^2) + 2*(ε(2,3,1)*xH[1] + ε(2,3,2)*xH[2] + ε(2,3,3)*xH[3])*xH[k]) + 5*(ε(2,3,i)*xH[j]*xH[k] + xH[i]*(ε(2,3,k)*xH[j] + ε(2,3,j)*xH[k])))*aH[3] + xH[3]*(-(δ(j,k)*(ε(3,3,i)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[i])) - δ(i,k)*(ε(3,3,j)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] +
ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[j]) - δ(i,j)*(ε(3,3,k)*(xH[1]^2 + xH[2]^2 + xH[3]^2) + 2*(ε(3,3,1)*xH[1] + ε(3,3,2)*xH[2] + ε(3,3,3)*xH[3])*xH[k]) + 5*(ε(3,3,i)*xH[j]*xH[k] + xH[i]*(ε(3,3,k)*xH[j] + ε(3,3,j)*xH[k])))*aH[3])/15.

dotSijk(aH::AbstractArray, vH::AbstractArray, xH::AbstractArray, m::Float64, M::Float64, i::Int, j::Int, k::Int) = dotSijk(aH, vH, xH, i, j, k) * Current_quad_prefactor(m, M)

end