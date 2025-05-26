---
title: What's new in the LUMI software stack
search:
  boost: 1
hide:
- navigation
---

# What's new in the LUMI software stack

## Release 20250526

-   Containers with the Cray Programming Environment version 24.11 and 25.03: 
    [ccpe](c/ccpe/index.md).

    Note that these containers are only meant for users who understand very well
    how the programming environment works and how environments and modules work
    on an HPC system. They are not meant for beginners. Features and support are 
    limited. 25.03 is also not fully functional on the GPU nodes as it requires
    ROCm(tm) 6.3 which is not supported by the current driver.

-   The remark on the availability of GPU support in
    [QuantumESPRESSO](q/QuantumESPRESSO/index.md) has been updated in the 
    documentation page.

-   Corrected the name of a [TensorFlow](t/TensorFlow/index.md) EasyConfig.

-   Some bugfixes in the visibility of modules.


## Release 20250521

-   [Score-P 9.0](s/Score-P/index.md) and a bugfix release of
    [Scalasca](s/Scalasca/index.md).

-   As `htop` was broken in `systools/24.03-1`, this module is replaced with
    [`systools/24.03-2`](s/systools/index.md) which still contains `pbzip2`

-   Software stack for LUMI-D, provided in `partition/D`.
    Some packages take a lot of time to compile. Yet because so many different
    configurations are possible and full testing is not possible with the size
    of LUST, they are offered as user-installable packages. Some base packages
    are pre-installed though in a standard configuration that should fit most
    work on LUMI.

    Visualisation packages include [ParaView](p/ParaView/index.md), 
    [VisIt](v/VisIt/index.md) and the [VTK libraries](v/VTK/index.md).

    As we have no upstream support for most of these tools, they can only be offered
    "as-is" with no guarantee that we can solve all issues. Often one may be better
    served by containerised visualisation software, but there are cases where those cannot
    be used and we want to focus on those use cases. So these packages are not meant to
    be a replacement of the packages offered in the LUMI web interface.


## Release 20250429

-   [Vampir](v/Vampir/index.md) has been upgraded to version 10.6.1. 
    The [VampirServer](v/VampirServer/index.md) recipes will be ported on request.
-   [systools](s/systools/index.md) update to `systools/24.03-1`, which now
    also includes `pbzip2`, a parallel implementation of bzip2 compression.

    Note that `pbzip2` is unmaintained software, so we cannot guarantee that we
    can keep offering this tool.

-   [GROMACS 2024.3](g/GROMACS/index.md) with CP2K QM/MM support.

## Release 20250415

-   Updated containers for [PyTorch](p/PyTorch/index.md) and [jax](j/jax/index.md).

    The PyTorch 2.6 container modules now also provide wrappers similar to the CSC 
    modules.
    
-   [ESMF](e/ESMF/index.md) with support for MPI and PIO
-   [OpenFOAM 12](o/OpenFOAM/index.md) with [ParMETIS](p/ParMETIS/index.md)
-   [fpocket](f/fpocket/index.md)


## Release 20250331

-   [GROMACS 2025.1](g/GROMACS/index.md) EasyConfigs
-   [STRUMNPACK 7.0.1](s/STRUMPACK/index.md) EasyConfig ported to 24.03  
-   [libxc](l/libxc/index.md) packages come without a checksum for now 
    as it appears those change over time 
    ([libxc GitLab issue #511](https://gitlab.com/libxc/libxc/-/issues/511)).

## Release 20250321

-   The [`PRoot`](p/PRoot/index.md) module now provides the `proot` command for `partition/container` in
    the LUMI software stacks. Its main use case is to enable the developement of EasyConfigs that modify
    an existing container and install it together with a module file for bindings etc. in 
    `partition/container`. This will, e.g., be used in upcoming recipes for containers with more recent
    or experimental versions of the HPE Cray Programming Environment.
-   [Kokkos](k/Kokkos/index.md) and [Kokkos-kernels](k/Kokkos-kernels/index.md) for 
    cpeGNU and cpeAMD.
-   Modified build recipe for [PETSc](p/PETSc/index.md), now using an external build of Kokkos.


## Release 20250227

-   Replaced PLUMED 2.9.2 with [PLUMED 2.9.3](p/PLUMED/index.md#user-installable-modules-and-easyconfigs),
    with updated EasyConfigs for [GROMACS](g/GROMACS/index.md#user-installable-modules-and-easyconfigs) and 
    for one of the [CP2K](c/CP2K/index.md) variants.
-   A bugfix in one of the [PETSc](p/PETSc/index.md) build recipes.
-   Extra development version of [Wannier90](w/Wannier90/index.md) as the released version 3.1.0 has some
    [known issues with GCC 12/13](https://github.com/wannier-developers/wannier90/issues/521).
-   Spack modules are no longer automatically included in the output
    of module spider, to speed up the generation of the Lmod cache
    and make the output of `module spider` less confusing.


## Release 20250214

-   EasyConfig for [Elk 10.3.12](e/Elk/index.md) contributed by Johan Hellsvik (KTH).
-   EasyConfigs for [VASP 6.5.0](v/VASP/index.md) and dependencies.


## Release 20250203

-   User-installable [feh](f/feh/index.md) image viewer, with dependencies
    [Imlib2](i/Imlib2/index.md) and [libexif](l/libexif/index.md)
-   User-installable [singularity-AI-bindings](s/singularity-AI-bindings/index.md)
    module as used in the February 2025 AI training. Please check the documentation as this
    module is meant for some very specific AI software containers and not for just any such
    container!
-   Update to the [VASP](v/VASP/index.md/#tuning-recommendations) documentation, documenting why the STOPCAR
    `LABORT` option should not be used on LUMI and is not turned on in our build
    recipes.
-   Some improvements to the warnings given when loading containers with ROCm versions
    other than the current system version.


## Release 20250115

-   Inclusion of the [HPE HPC Affinity Tracker tool (`hpcat`)](https://github.com/HewlettPackard/hpcat)
    in the [lumi-CPEtools modules](l/lumi-CPEtools/index.md) modules for `LUMI/24.03`.
-   Updated EasyBuild container module recipes for
    [jax](j/jax/index.md), [mpi4py](m/mpi4py/index.md), [PyTorch](p/PyTorch/index.md),
    [rocm](r/rocm/index.md) and [TensorFlow](t/TensorFlow/index.md).
-   EasyConfig for [AdaptiveCpp](a/AdaptiveCpp/index.md) 24.10.0 in `LUMI/24.03`.
-   Corrections to some EasyConfigs for 
    [CP2K](c/CP2K/index.md), [LAMMPS](l/LAMMPS/index.md) and
    [libxsmm](l/libxsmm/index.md).


## Release 20241129

-   Removing the last update of [`cotainr`](c/cotainr/index.md) as it contains an annoying bug.
-   Update of the `lumio-conf` tool in the [lumio](l/lumio/index.md) module. Note that the name
    of the endpoints in the rclone configuration file has changed to align with the names used
    by the credential management web interface config files and those generated by the tools in
    Open OnDemand.
-   [Neko](n/Neko/index.md) for cpeGNU and cpeCray. There is a known issue with cpeGNU though.
-   [VASP](v/VASP/index.md) for LUMI/24.03
-   [CP2K](c/CP2K/index.md) for LUMI/24.03 fix. Re-install if you get suspicious results and 
    make sure you do so from the directory with the EasyConfig 
    (`/appl/lumi/LUMI-EasyBuild-contrib/easybuild/easyconfigs/c/CP2K`) and use the `-f`
    flag to force re-installation.

## Release 20241112

-   Updated version of [`cotainr`](c/cotainr/index.md) with some bug fixes and minor enhancements.
    The [on-line documentation of cotainr](https://cotainr.readthedocs.io/en/2024.10.0/)
    has also been updated to reflect the changes on LUMI after the September 2024 maintenance
    period.
-   A correction to one of the [CP2K with PLUMED](c/CP2K/index.md) recipes.
-   [GPAW](g/GPAW/index.md) recipes for 24.03.
-   Python support for [Amber with AmberTools](a/Amber/index.md)

## Release 20241024

-   Fix for `htop` on `LUMI/24.03` so that it is now in [systools/24.03](s/systools/index.md).

-   [cotainr](c/cotainr/index.md) in `LUMI/24.03` to avoid user confusion as many users
    expect to find the most recent cotainr in the most recent LUMI stack.

-   [hpcat](h/hpcat/index.md) experimental tool to study bindings (Cray compiler only)

-   Updated [singularity-bindings](s/singularity-bindings/index.md)

-   [ELPA](e/ELPA/index.md) for cpeCray and ROCm 6 (some performance degradation observed)

-   Fixes for double linking of LibSci in some [PETSc](p/PETSc/index.md) EasyConfigs

-   [GROMACS+PLUMED](g/GROMACS/index.md) for CPU with full Python support for Cray Python.

## Release 20241004

-   [ROCm 6.2.2 in LUMI/24.03 partition/G](r/rocm/index.md). Note that this module does
    not work well with the CCE compilers prior to version 18 (still in beta and not on
    the system) as the bytecode generated by LLVM 18 used in ROCm 6.2 causes errors
    during linking.

-   Update to [cotainr](c/cotainr/index.md) in CrayEnv.

-   [STAR rna sequencing](s/STAR/index.md) EasyBuild recipe.

-   Fix for the visibility problems in the LUMI stack.


## Release 20241002

-   Extra configuration for [Score-P](s/Score-P/index.md).

-   Configurations of [GROMACS](g/GROMACS/index.md) with [PLUMED](p/PLUMED/index.md).

-   Deprecation warnings for old Spack modules.


## Release 20240927

-   Modules to load the local CSC and quantum computing stacks (`Local-CSC` and `Local-quantum`)

-   Framework to stop indexing the Spack modules and avoid indexing the modules from the local
    stacks unless explicitly requested.

    Do `module help ModuleFullSpider/on` for more information. 


## Release 20240920

-   [lumi-container-wrapper](l/lumi-container-wrapper/index.md) updated with an openSUSE
    LEAP 15.5 image and installed in CrayEnv, LUMI/23.12 and LUMI/24.03.

-   Updated EasyConfigs for [R](r/R/index.md) for LUMI/2024.03

-   [Score-P](s/Score-P/index.md) for LUMI/2024.03, cpeAOCC version missing due to
    instrumentation issues. 


## Release 20240916

-   See the [user update after the august-september 2024 maintenance](https://lumi-supercomputer.github.io/LUMI-training-materials/User-Updates/Update-202409/)
    for a more complete list of changes.

-   New software stacks for the 23.12 and 24.03 versions are provided.

    -   `LUMI/24.03` is our preferred software stack and the only one we can fully support.
        We already provide a lot of user-installable EasyConfigs for this stack.

    -   `LUMI/23.12` is offered as-is. We do not intend to develop much software on top of it
        as it will likely be rather short-lived and as we do not receive upstream support for 
        this stack as it does not officially support ROCm 6.0. As most software versions are 
        the same as in 23.09, it should be easy to update build recipes and give you some
        bug fixes in the GNU and CCE compilers. The AMD compilers in both cpeAOCC and
        cpeAMD though are much newer versions with all consequences this has...

-   Several build recipes for `LUMI/23.09` have been revised to try to work around problems.
    Note however that the preferred solution is to move to `LUMI/24.03`.

-   Several old build recipes that we know do not work properly anymore, have been archived.


## Release 20240909

-   Internal release only as the system was down much longer than expected due to 
    a power delivery issue.

-   The first fixes to be able to use old programming environments again, at
    least to run on LUMI.

-   See the [user update after the august-september 2024 maintenance](https://lumi-supercomputer.github.io/LUMI-training-materials/User-Updates/Update-202409/).


## Release 20240807

-   A fix for problems with [buildtools-python](b/buildtools-python/index.md)
    in the version for Cray Python in LUMI/23.09.

-   New package: [Yambo](y/Yambo/index.md) (CPU-only)

-   [QuEST](q/QuEST/index.md) for LUMI/23.09

-   Warning for the upcoming system maintenance in the message-of-the-day.

## Release 20240718

-   [`cotainr`](c/cotainr/index.md) has been updated in `CrayEnv` to the latest
    version with the images used during the AI course of May 2024, and has been
    made available in `LUMI/23.09`.
    The examples used in the AI course in Copenhagen should now work again
    even without specifying a specific version of the `LUMI` stack though we 
    do discourage that behaviour.

    `cotainr` in the future will be available in `CrayEnv` as it really needs nothing
    from the `LUMI` stacks, and some versions will be available in some `LUMI` stacks.
    The latest version will usually be available in the latest `LUMI` stack, but as
    we only change the default version when that stack is sufficiently populated, the
    default version of the `LUMI` stack may not always contain the latest version of
    `cotainr` or any other software package.

-   [`lumi-container-wrapper`](l/lumi-container-wrapper/index.md) is now available in
    `LUMI/23.09`.

-   An EasyConfig for [GPAW on GPU](g/GPAW/index.md). This is currently not containerised
    so only suitable to run on a moderate number of MPI ranks as otherwise starting GPAW
    could put a very high stress on the file system.

-   Some minor improvements to the [OpenFOAM documentation](o/OpenFOAM/index.md)
    after issues reported on other sides that turned out not to affect our EasyConfigs.


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
