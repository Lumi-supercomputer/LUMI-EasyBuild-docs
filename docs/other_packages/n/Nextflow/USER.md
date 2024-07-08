# Test page for Nextflow documentation.

-   [Nextflow web site](https://www.nextflow.io/index.html)

-   [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html)

-   [CSC Nextflow documentation](https://docs.csc.fi/apps/nextflow/) (and pointer to a module in the local
    software stack of CSC)


## General Information

Nextflow is a workflow system for creating scalable, portable and reproducible workflows.
It is based on the dataflow programming model, which greatly simplifies the writing of parallel and distributed pipelines, allowing you to focus on the flow of data and computation.
Nextflow can deploy workflows on a variety of execution platforms, including your local machine, HPC schedulers, AWS Batch, Azure Batch, Google cloud Batch, and Kubernetes.
It also supports many ways to manage your software dependencies, including Conda, Spack, Docker, Podman, Singularity, and more.


## Installing Nextflow

Nextflow needs Java, but Java is already installed in the system image on LUMI.
Other versions of Java can be installed via the 
[LUMI Software Library](../../j/Java), but keep in mind that some Java packages may
still select the system one over the one installed as a module.

Nextflow is not very well suited for traditional package managers as it tends to write in its
own directories (trying to update itself) and also puts part of the installation in the
`~/.nextflow` subdirectory of your home directory so any central installation is also incomplete.
However, installation instructions that should
work on LUMI are easily found in the 
[Nextflow documentation, "Installation section"](https://www.nextflow.io/docs/latest/getstarted.html#installation).

Assuming an installation in the directory `/project/project-46YXXXXXX/software`, the following worked at the time
of writing:

-   Install Nextflow

    ```bash
    cd /project/project-46YXXXXXX/software

    curl -s https://get.nextflow.io | bash
    ```
    This will create the `nextflow` executable in the current directory.
    
    It will however also download a lot of files that will be stored in the hidden directory
    `~/.nextflow` (in your home directory) so it will eat from 
    your quota and you may have to move that directory to a different filesystem and link to it if it
    becomes too large!

-   Make Nextflow executable

    ```bash
    chmod +x nextflow
    ```

-   Set the executable path for using Nextflow.

    *Note: You will also need to set the path in the bash script that you use to submit the job*

    ```bash
    export PATH=/project/project-46YXXXXXX/software:$PATH
    ```

-   Confirm that Nextflow is installed correctly

    ```bash
    nextflow info
    ```

Note that if you use the CSC-provided module, the `nextflow` command will still trigger the download of
a lot of files to the hidden directory `~/.nextflow` (in your home directory) so it will eat from 
your quota and you may have to move that directory to a different filesystem and link to it if it
becomes too large!
