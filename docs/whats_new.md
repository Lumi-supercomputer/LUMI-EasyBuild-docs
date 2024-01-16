---
title: What's new in the LUMI software stack
search:
  boost: 1
hide:
- navigation
---

# What's new in the LUMI software stack

## Release 20240116

-   New package: [DL_POLY_4](d/DL_POLY_4/index.md): dl-poly in a basic configuration
-   New package: [QUDA](q/QUDA/index.md)
-   Updates to [Rust](r/Rust/index.md), [HyperQueue](h/HyperQueue/index.md),
    [PETSc](p/PETSc/index.md), [ELPA](e/ELPA/index.md).

## Release 20240110

-   Improved search in the LUMI Software Library, though for performance reasons we've 
    chosen not to search the EasyConfigs themselves too.
-   Some software brought to 23.09, such as [R](r/R/index.md), 
    [GDAL](g/GDAL/index.md), [GEOS](g/GEOS/index.md) and dependencies
-   [KaHIP](k/KaHIP/index.md)
-   [AdaptiveCpp](a/AdaptiveCpp/index.md)
-   [Boost](b/Boost/index.md) for cpeCray/23.09.
  
    Note that a workaround was needed for Boost to avoid a linker problem. See the
    technical documentation on the [Boost page](b/Boost/index.md) to find out what we
    did if you also run into link problems.

## Release 20231215

-   [rocm/5.6.1](r/rocm/index.md) and [amd/5.6.1](a/amd/index.md) 
    modules installed in `CrayEnv` and `LUMI/23.09 partition/G`.
-   Updated user-installable recipes for Java, including [Java/21](j/Java/index.md).
-   User-installable recipe for the [UNICORE UFTP client](u/unicore-uftp/index.md).
-   User-installable recipe for the installation of [SIESTA (CPU version)](s/Siesta/index.md)


## Release 20231208

-   [GROMACS](g/GROMACS/index.md) with [hipSYCL](h/hipSYCL/index.md) and dependencies, including a version with heFFT.
-   [nvtop](n/nvtop/index.md)
-   Extra user-installable version of [SCOTCH](s/SCOTCH/index.md) (64-bit integers)
-   Update of the [aws-ofi-rccl plugin](a/aws-ofi-rccl/index.md)
-   Fix for [ELPA](e/ELPA/index.md)
-   Improved [Open MPI](o/OpenMPI/index.md) with [OSU micro-benchmarks](o/OSU-Micro-Benchmarks/index.md)
    as test code and user-installable adapted versions of [lumi-CPEtools](l/lumi-CPEtools/index.md)
    for checking task and thread distribution and pinning.


## Release 20231121

-   Bug fixes for the module view
-   More container recipes


## Release 20231116

-   Initial release of the `LUMI/23.09` central software stack, including a first
    selection of user-installable build recipes
-   Initial support for creating modules that ease working with containers
    provided on LUMI.
-   New version of the [cotainr](c/cotainr/index.md) module
-   Bug fix for the `lumi-ldap-projectinfo` command.
