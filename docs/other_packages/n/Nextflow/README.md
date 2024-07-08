# Nextflow technical documentation.

-   [Nextflow web site](https://www.nextflow.io/index.html)

-   [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html)

-   [Nextflow on GitHub](https://github.com/nextflow-io/nextflow)
   
    -   [GitHub releases](https://github.com/nextflow-io/nextflow/releases)

## What is the problem?

The problem with Nextflow is that even though it claims to install Nextflow, it really
only installs a small shell script while other components are downloaded and put 
outside the installation directory, typically in `~/.nextflow`. Hence what claims to
be a central installation really is not. It is also not clear how reproducible these
downloads are: Are they version-specific or are some or all of those packages always
the newest version?
