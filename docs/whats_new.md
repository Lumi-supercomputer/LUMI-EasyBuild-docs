---
title: What's new in the LUMI software stack
search:
  boost: 1
hide:
- navigation
---

# What's new in the LUMI software stack

## Release 20240709

-   `LUMI/23.09` is now the default version of the `LUMI` module.
-   Some updated EasyConfigs for the containers for 
    [PyTorch](p/PyTorch/index.md) and [TensorFlow](t/TensorFlow/index.md).
-   Updated EasyConfig for [Siesta](s/Siesta/index.md)


## Release 20240607

-   EasyBuild-user module enhanced to enable running EasyBuild in a container to install
    software outside of the container. This feature is mostly meant for LUST and some 
    projects that get test versions of compilers.
-   Warnings when using `LUMI/22.08` and `LUMI/22.12` as their end-of-life is approaching
    fast and they will not be supportable after the August 2024 system update.

    LUST will do its best to keep `LUMI/23.09` running after the update, but even there 
    recompilation may be required, or switching to newer compilers. However, helping users
    who are already on 23.09 will have a higher priority than helping those who postponed
    using the newer toolchain.

-   Security fixes to the processing behind the LUMI Software Library and corrections to
    the fortune messages shown at login.


## Release 20240524

-   Improved [lumi-tools](l/lumi-tools/index.md) with bug fixes to `lumi-ldap-userinfo`
    and `lumi-ldap-projectinfo` and the new `lumi-ldap-projectlist` command for LUST.
-   Support for [Score-P](s/Score-P/index.md) on LUMI-G with `cpeCray` and `cpeAMD`,
    though with some restrictions mentioned in 
    [the documentation in the LUMI Software Library](s/Score-P/index.md#user-documentation-user-installation)
-   [PyTorch](p/PyTorch/index.md): 
    [Additional containers](p/PyTorch/index.md#singularity-containers-with-modules-for-binding-and-extras), 
    including one with vLLM


## Release 20240517

-   [OpenFOAM.org 10](o/OpenFOAM/index.md) EasyConfig for the GNU compilers in 23.09.
-   Improved EasyConfig for [GROMACS 2024.01 on GPU](g/GROMACS/index.md),
    using ROCm 5.4.6 which is a better choice on the LUMI AMD GPU driver at this
    moment.
-   JSC PerfTools [Score-P 8.4](s/Score-P/index.md), which also requires 
    [Scalasca 2.6.1](s/Scalasca/index.md), 
    [libbfd 2.42](l/libbfd/index.md),
    [OTF2 3.0.3](o/OTF2/index.md),
    [OPARI2 2.0.8](o/OPARI2/index.md),
    [CubeLib 4.8.2](c/CubeLib/index.md) and
    [CubeWriter 4.8.2](c/CubeWriter/index.md).
    Currently only LUMI-C is supported.


## Release 20240412

-   [singularity-bindings](s/singularity-bindings/index.md) EasyConfig to be used while 23.09 is 
    the system default version of the HPE Cray Programming Environment, and improved
    documentation for this module.
-   [lumi-training-tools](l/lumi-training-tools/index.md) EasyConfig to install software
    used in the course notes and exercises of the Amsterdam course given by LUST in
    May 2024. 


## Release 20240329

-   A new [PyTorch container](p/PyTorch/index.md)
-   Much extended documentation for the [PyTorch container](p/PyTorch/index.md)
    and [rocm container](r/rocm/index.md)
-   The `proot` command is now included in [`systools/23.09`](s/systools/index.md)
    available in LUMI/23.09 and CrayEnv. This is useful for using so-called
    "unprivileged `proot` builds" in SingularityCE.


## Release 20240322

-   [CP2K 2024.1](c/CP2K/index.md) with GPU support for LUMI/23.09
-   Improvement to a [PETSc](p/PETSc/index.md) EasyConfig
-   [ROCm container for 5.6.0](r/rocm/index.md)


## Release 20240308

-   `rocm/5.4.6` module in `CrayEnv` and `LUMI/23.09 partition/G` as we notice too
    much problems with `rocm/5.6.1` on the current driver version. ROCm 5.4.x is the last
    supported ROCm version on the driver that we have, but that does not mean that 
    5.4.x will always work correctly with the HPE Cray PE as that one is mostly tested
    with ROCm 5.2 on the current OS version of LUMI and ROCm 5.5 on SUSE 15 SP5.
-   EasyBuild module for `LUMI/23.09` now also loads 
    [EasyBuild-tools](e/EasyBuild-tools/index.md) with extra tools that might be needed 
    for some EasyConfigs.
-   [JAX](j/jax/index.md): Containers made available through EasyBuild-generated modules
-   Improved documentation for the [PyTorch containers](p/PyTorch/index.md), 
    and initial steps to offer containers that support a Python virtual environment for 
    adding packages out-of-the-box.
-   [Quantum ESPRESSO](q/QuantumESPRESSO/index.md),
    [GROMACS 2024.1](g/GROMACS/index.md) and
    [NAMD 2.14](n/NAMD/index.md): EasyConfigs for `LUMI/23.09`.
    An initial effort to compile [NAMD 3.0b6](n/NAMD/index.md) with GPU support is also included.
    Due to the beta nature of this package, problems are to be expected.
-   New EasyConfig for a GPU-enabled [PETSc](p/PETSc/index.md) with the Cray toolchain  


## Release 20240301

-   [VASP](v/VASP/index.md): VASP 6.4.2 for cpeGNU/23.09.
-   Fixes for the binding issues in the [rocm containers](r/rocm/index.md)
-   New documentation feature: We can now add some documentation to individual EasyConfigs
    to make it more clear which EasyConfig offers what features. See, e.g., 
    [PyTorch](p/PyTorch/index.md).


## Release 20240207

-   [SCOTCH 7](s/SCOTCH/index.md) for cpeCray
-   Updated documentation for [HyperQueue](h/HyperQueue/index.md), 
    [GROMACS](g/GROMACS/index.md), [CP2K](c/CP2K/index.md)
-   New [PyTorch 2.2.0 container with flash-attention](p/PyTorch/index.md) 
    and new snapshots of the other containers.


## Release 20240129

-   New package: [Magma](m/magma/index.md) for cpeGNU, cpeCray and cpeAMD.
-   Updated EasyConfig for [openFOAM](o/OpenFOAM/index.md)
-   ROCm 5.7.1 container, and re-generated versions of the other ROCm containers.


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
