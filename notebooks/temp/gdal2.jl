using NCDatasets

"""
Define the dimension with the name NAME and the length LEN in the
dataset NCID.  The id of the dimension is returned
"""
function nc_def_dim(ncid::Integer,name,len::Integer)
    idp = Vector{Cint}(undef,1)

    check(ccall((:nc_def_dim,libnetcdf),Cint,(Cint,Cstring,Cint,Ptr{Cint}),ncid,name,len,idp))
    return idp[1]
end

"""
Define the dimension with the name NAME and the length LEN in the
dataset NCID.  The id of the dimension is returned
"""
function nc_def_dim(ncid::Integer, name, len::Integer, val::Vector{Cint})
    # idp = Vector{Cint}(undef,1)
    check(ccall((:nc_def_dim,libnetcdf),Cint,(Cint,Cstring,Cint,Ptr{Cint}),ncid,name,len,val))
    return idp[1]
end
