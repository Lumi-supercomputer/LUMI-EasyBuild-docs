#! /usr/bin/env bash
#
# This is a script to build the markdown pages for the documentation
# of the software stack.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
repodir=$PWD
repo=${PWD##*/}

gendoc='docs-generated'
userinfo='USER.md'
stack_module_preamble="To access module help and find out for which stacks and partitions the module is\n\
installed, use \`module spider <name>/<version>\`.\n\n\
EasyConfig:\n"
contrib_module_preamble="Install with the EasyBuild-user module:\n\
\`\`\`\`\n\
eb <easyconfig> -r\n
\`\`\`\`\n\
To access module help after installation and get reminded for which stacks and partitions the module is\n\
installed, use \`module spider <name>/<version>\`.\n\n\
EasyConfig:\n"
container_module_preamble="Install with the EasyBuild-user module in \`partition/container\`:\n\
\`\`\`\`\n\
module load LUMI partition/container EasyBuild-user
eb <easyconfig>\n
\`\`\`\`\n\
The module will be available in all versions of the LUMI stack and in the CrayEnv stack.\n
To access module help after installation use \`module spider <name>/<version>\`.\n\n\
EasyConfig:\n"
container_docker_preamble="Docker definition file \`<dockerfile>\`\n\
for the container provided by the module \`<name>/<version>\`.\n\n\
Note that the majority of these definition files cannot be used as they are,\n\
as they require access to specially set-up servers providing licensed components needed during the build.\n\n\
Docker file:\n"
stack_archived_module_preamble="This software is archived in the\n\
[LUMI-SoftwareStack](https://github.com/Lumi-supercomputer/LUMI-SoftwareStack) GitHub repository as\n\
[easybuild/easyconfigs/\_\_archive\_\_/<file_with_prefix>](https://github.com/Lumi-supercomputer/LUMI-SoftwareStack/blob/main/easybuild/easyconfigs/__archive__/<file_with_prefix>).\n\
The corresponding module would be <name>/<version>."
contrib_archived_module_preamble="This software is archived in the\n\
[LUMI-EasyBuild-contrib](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib) GitHub repository as\n\
[easybuild/easyconfigs/\_\_archive\_\_/<file_with_prefix>](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib/blob/main/easybuild/easyconfigs/__archive__/<file_with_prefix>).\n\
The corresponding module would be <name>/<version>."
container_archived_module_preamble="This software is archived in the\n\
[LUMI-EasyBuild-container](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-container) GitHub repository as\n\
[easybuild/easyconfigs/\_\_archive\_\_/<file_with_prefix>](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib/blob/main/easybuild/easyconfigs/__archive__/<file_with_prefix>).\n\
The corresponding module would be <name>/<version>. The containers are likely no longer available on LUMI though."
other_info_label="Issues"
whatsnew_label="New"

#
# Search priorities
# These seem to be multipliers: multiply the number of occurrences on a page with this factor
# to get the actual priority of a page.
#
# EasyConfigs are excluded from the search to avoid building a too large and impractical
# search index. (Alternative: give them a very low priority such as 0.01, but this still
# creates a large search database.) 
#
search_packagelist='0.5'
#search_new='1'     # Hard-coded in whats_new.md
#search_issues='2'  # Hard-coded in known_issues.md
search_package='10'

>&2 echo "Working in repo $repo in $repodir."

#
# Some functions and variables for this section
#

function die () {

    echo "$*" 1>&2
    exit 1

}

#
# create_link
#
# Links a file but first tests if the target already exists to avoid error messages.
#
# Input arguments:
#   + First input argument: The source file
#   + Second and mandatory argument: The target file
#
create_link () {

    #echo "Linking (source file): $1"
    #echo "Linking to (name of the link): $2"
    #test -s "$2" && echo "File $2 found."
    #test -s "$2" || echo "File $2 not found."
    test -s "$2" || ln -s "$1" "$2" || die "Failed to create a $2 (target) linking to $1 (source)."

}

#
# Print a string and indent.
#

indent() {

    # The first call to perl is a trick to remove trailing newlines.
    # The second call to perl adds the indentation to all but the first line.
    echo -e "$2$1" | perl -pe 'chomp if eof' | perl -pe "s|\n|\n$2|" 

}

#
# Extract docs
#
extract_docs() {

    #egrep '#DOC' $1 | sed -e 's|#DOC *||' | tr '\n' ' '
    egrep '#DOC' $1 | sed -e 's|#DOC *||'

}

#
# Print the EasyConfig docs (if any)
#
add_easyconfig_docs () {

    # Input parameters:
    # $1: The (path to the) EasyConfig file
    # $2: The file to print to
    # $3: The indent.

    doccomment="$(extract_docs $1)"
    if [ -n "$doccomment" ]
    then

        # Add the documentation text with 4 spaces of indent.
        indent "$doccomment" "$3" >>$2
        # Then add a newline and empty line
        printf "\n\n"             >>$2

    fi

}

#
# Create a markdown document for an EasyConfig.
#
easyconfig_to_md () {

    # Input arguments:
    # - $1: The (path to the) EasyConfig file
    # - $2: The (path to the) markdown file. This file will be created or overwritten.
    # - $3: The preamble to be used

    local work
    local easyconfig
    local package
    local package_group
    local version
    local preamble

    easyconfig="${1##*/}"        # Remove everything up to and including the last /
    work="${1%/$easyconfig}"     # work is the relative path to $easyconfig
    package="${work##*/}"        # Extract the last part of that path, the package name.
    work="${work%/$package}"     # Now also remove the package name from the path.
    package_group="${work##*/}"  # Extract again the last part of the path.
    work="${easyconfig%%.eb}"    # work is $easyconfig without the extension,
    version="${work##$package-}" # so we can remove the package name part to get the version

    preamble="${3//<name>/$package}"                 # Substitute the package in the preamble
    preamble="${preamble//<version>/$version}"       # Substitute the version in the preamble
    preamble="${preamble//<easyconfig>/$easyconfig}" # Substitute the easyconfig in the preamble
    preamble="${preamble//<file_with_prefix>/$package_group/$package/$easyconfig}"
    
    #
    # Generate the easyconfig file for $package/$version
    #

    echo -e "---\ntitle: $package/$version ($easyconfig) - $package"     >$2
    echo -e "search:\n  exclude: true"                                  >>$2
    echo -e "hide:\n- navigation\n- toc\n---\n"                         >>$2
    echo -e "[[$package]](index.md) [[package list]](../../index.md)\n" >>$2
    echo -e "# $package/$version ($easyconfig)\n"                       >>$2
    echo -e "$preamble\n"                                               >>$2
    echo -e '``` python'                                                >>$2
    cat $1                                                              >>$2
    echo -e '\n```\n'                                                   >>$2
    echo -e "[[$package]](index.md) [[package list]](../../index.md)"   >>$2
    # Note the extra \n in front of the last ``` as otherwise files that do not end
    # with a newline would cause trouble.

}

#
# Create a markdown document for an EasyConfig.
#
dockerfile_to_md () {

    # Input arguments:
    # - $1: The (path to the) EasyConfig file
    # - $2: The dockerfile, without path
    # - $3: The (path to the) markdown file. This file will be created or overwritten.
    # - $4: The preamble to be used

    local work
    local easyconfig
    local prefix
    local package
    local package_group
    local version
    local preamble

    easyconfig="${1##*/}"        # Remove everything up to and including the last /
    prefix="${1%/$easyconfig}"   # prefix is the relative path to $easyconfig
    package="${prefix##*/}"      # Extract the last part of that path, the package name.
    work="${prefix%/$package}"   # Now also remove the package name from the path.
    package_group="${work##*/}"  # Extract again the last part of the path.
    work="${easyconfig%%.eb}"    # work is $easyconfig without the extension,
    version="${work##$package-}" # so we can remove the package name part to get the version

    preamble="${4//<name>/$package}"                 # Substitute the package in the preamble
    preamble="${preamble//<version>/$version}"       # Substitute the version in the preamble
    preamble="${preamble//<easyconfig>/$easyconfig}" # Substitute the easyconfig in the preamble
    preamble="${preamble//<file_with_prefix>/$package_group/$package/$easyconfig}"
    preamble="${preamble//<dockerfile>/$2}"          # Substitute the dockerfile in the preamble 

    echo -e "---\ntitle: $2 for $package/$version - $package"            >$3
    echo -e "search:\n  exclude: true"                                  >>$3
    echo -e "hide:\n- navigation\n- toc\n---\n"                         >>$3
    echo -e "[[$package]](index.md) [[package list]](../../index.md)\n" >>$3
    echo -e "# $2 for $package/$version ($easyconfig)\n"                >>$3
    echo -e "$preamble\n"                                               >>$3
    echo -e '``` docker'                                                >>$3
    cat $prefix/$2                                                      >>$3
    echo -e '\n```\n'                                                   >>$3
    echo -e "[[$package]](index.md) [[package list]](../../index.md)"   >>$3
    # Note the extra \n in front of the last ``` as otherwise files that do not end
    # with a newline would cause trouble.

}

#
# Make sure the working directory exists.
#
mkdir -p $gendoc || die "Failed to create the working directory $repodir/$gendoc."

#
# Prepare the structure:
# - Copy the template for the mkdocs.yml file
# - Make the docs subdirectory
# - Link the stylesheets to the docs subdirectory.
# - TO CONSIDER: We may have overrides in the future also. 
# 
[[ -f $gendoc/mkdocs.yml ]] && /bin/rm -f $gendoc/mkdocs.yml
/bin/cp -f config/mkdocs.tmpl.yml $gendoc/mkdocs.yml || die "Failed to copy mkdocs.yml from the template."
echo -e "\nnav:" >>$gendoc/mkdocs.yml

mkdir -p $gendoc/docs

[[ -h $gendoc/mkdocs_lumi ]]      || create_link $repodir/mkdocs_lumi      $repodir/$gendoc/mkdocs_lumi
[[ -h $gendoc/docs/assets ]]      || create_link $repodir/docs/assets      $repodir/$gendoc/docs/assets
[[ -h $gendoc/docs/stylesheets ]] || create_link $repodir/docs/stylesheets $repodir/$gendoc/docs/stylesheets

echo "Searching for files in repo doc."
for file in $(find docs -maxdepth 1 -name "*.md")
do
    echo "Found file $file."
    [[ -h $gendoc/$file ]] || create_link $repodir/$file $repodir/$gendoc/$file
done

#
# Where do we find the EasyConfig files and other documentation?
#
prefix_stack="${repodir%%$repo}LUMI-SoftwareStack/easybuild/easyconfigs"
prefix_contrib="${repodir%%$repo}LUMI-EasyBuild-contrib/easybuild/easyconfigs"
prefix_container="${repodir%%$repo}LUMI-EasyBuild-containers/easybuild/easyconfigs"
prefix_other="$repodir/docs/other_packages"

>&2 echo "Software stack easyconfig directory:  $prefix_stack"
>&2 echo "Contributed easyconfig directory:     $prefix_contrib"
>&2 echo "Other packages information directory: $prefix_other"

#
# Set up the package list file
#
package_list="$gendoc/docs/index.md"

echo -e "---\ntitle: Package overview"                                                                                          >$package_list
echo -e "search:\n  boost: ${search_packagelist}"                                                                              >>$package_list
echo -e "hide:\n- navigation\n---\n"                                                                                           >>$package_list
echo -e "# Package list\n"                                                                                                     >> $package_list
if (( $# == 1 ))
then
    echo -e "Lumi software stack release: $1\n"                                                                                >> $package_list
else
    echo -e "Last processed: $(date -u)\n"                                                                                     >> $package_list
fi
echo -e "<span class='lumi-software-smallbutton-userdoc'></span>: Specific user documentation available\n"                     >> $package_list
echo -e "<span class='lumi-software-smallbutton-techdoc'></span>: Technical documentation available\n"                         >> $package_list
echo -e "<span class='lumi-software-smallbutton-archive'></span>: Archived application\n"                                      >> $package_list
echo -e "<span class='lumi-software-smallbutton-container'></span>: Singularity container to run using singularity commands\n" >> $package_list

#
# Some initialisations
#
last_group='.'

#
# Loop over all packages
#
# Below: Letter p and all special packages as then we have a bit of everything to test.
#for package_dir in $(/bin/ls -1 $prefix_stack/p/*/*.eb $prefix_stack/__archive__/p/*/*.eb $prefix_contrib/p/*/*.eb $prefix_contrib/__archive__/p/*/*.eb $prefix_container/p/*/*.eb $prefix_container/__archive__/p/*/*.eb $prefix_other/*/*/*.md | sed -e 's|.*/easyconfigs/\(.*/.*\)/.*\.eb|\1|' | sed -e 's|__archive__/||' sed -e 's|.*/other_packages/\(.*/.*\)/.*\.md|\1|' | sort -uf)
for package_dir in $(/bin/ls -1 $prefix_stack/*/*/*.eb $prefix_stack/__archive__/*/*/*.eb \
                                $prefix_contrib/*/*/*.eb $prefix_contrib/__archive__/*/*/*.eb \
                                $prefix_container/*/*/*.eb $prefix_container/__archive__/*/*/*.eb \
                                $prefix_other/*/*/*.md \
                     | sed -e 's|.*/easyconfigs/\(.*/.*\)/.*\.eb|\1|' | sed -e 's|__archive__/||' \
                     | sed -e 's|.*/other_packages/\(.*/.*\)/.*\.md|\1|' \
                     | sort -uf)
do

	>&2 echo "Processing $package_dir..." 

	# Extract the first letter and the name of the package.
	package=${package_dir##[0-9a-z]/}   # Name of the package.
	group=${package_dir%%/$package}     # A single letter or number, the first subdirectory in which the package subdirectory resides
	
	>&2 echo "Identified group $group, package $package"

    #
    # Check the nature of the package
    #
    is_readme=0    # Variable: Will be set to 1 if a README.md file is available
    is_user=0      # Variable: Will be set to 1 if a USER.md file is available
    is_license=0   # Variable: Will be set to 1 if a LICENSE.md file is available
    package_type=0 # Variable: Counts the number of ways the package is offered: pre-installed, user-installable EasyBuild, singularity, instructions for own installation

    is_stack_package=0              # Variable: Set to 1 if any information about this package is found in LUMI-SoftwareStack
    is_stack_readme=0               # Variable: Set to 1 if a README file is found in LUMI-SoftwareStack for this package
    is_stack_user=0                 # Variable: Set to 1 if a USER file is found in LUMI-SoftwareStack for this package
    is_stack_license=0              # Variable: Set to 1 if a license file is found in LUMI-SoftwareStack for this package
    is_stack_easyconfig=0           # Variable: Set to 1 if there are active EasyConfigs in LUMI-SoftwareStack for this package
    is_stack_archived_easyconfig=0  # Variable: Set to 1 if there are archived EasyConfigs in LUMI-SoftwareStack for this package
    if [ -d $prefix_stack/$package_dir ]
    then
        [ -f $prefix_stack/$package_dir/README.md ]                      && is_stack_readme=1     && is_readme=$(($is_readme + 1))
        [ -f $prefix_stack/$package_dir/$userinfo ]                      && is_stack_user=1       && is_user=$(($is_user + 1))  
        [ -f $prefix_stack/$package_dir/LICENSE.md ]                     && is_stack_license=1    && is_license=$(($is_license + 1))
        (( $(find $prefix_stack/$package_dir -name "*.eb" | wc -l) ))    && is_stack_easyconfig=1
        package_type=$((package_type+1))
    fi
    if [ -d $prefix_stack/__archive__/$package_dir ]
    then
        (( $(find $prefix_stack/__archive__/$package_dir -name "*.eb" | wc -l) )) && is_stack_archived_easyconfig=1
    fi
    (( $is_stack_readme || $is_stack_user || $is_stack_easyconfig || $is_stack_archived_easyconfig  )) && is_stack_package=1
    >&2 echo "$package: stack package:   $is_stack_package, README: $is_stack_readme, USER: $is_stack_user, LICENSE: $is_stack_license, EB: $is_stack_easyconfig, archived EB: $is_stack_archived_easyconfig."

    is_contrib_package=0              # Variable: Set to 1 if any information about this package is found in LUMI-EasyBuild-contrib
    is_contrib_readme=0               # Variable: Set to 1 if a README file is found in LUMI-EasyBuild-contrib for this package
    is_contrib_user=0                 # Variable: Set to 1 if a USER file is found in LUMI-EasyBuild-contrib for this package
    is_contrib_license=0              # Variable: Set to 1 if a license file is found in LUMI-EasyBuild-contrib for this package
    is_contrib_easyconfig=0           # Variable: Set to 1 if there are active EasyConfigs in LUMI-EasyBuild-contrib for this package
    is_contrib_archived_easyconfig=0  # Variable: Set to 1 if there are archived EasyConfigs in LUMI-EasyBuild-contrib for this package
    if [ -d $prefix_contrib/$package_dir ]
    then
        [ -f $prefix_contrib/$package_dir/README.md ]                          && is_contrib_readme=1     && is_readme=$(($is_readme + 1))
        [ -f $prefix_contrib/$package_dir/$userinfo ]                          && is_contrib_user=1       && is_user=$(($is_user + 1))
        [ -f $prefix_contrib/$package_dir/LICENSE.md ]                         && is_contrib_license=1    && is_license=$(($is_license + 1))
        (( $(find $prefix_contrib/$package_dir -name "*.eb" | wc -l) ))        && is_contrib_easyconfig=1
        package_type=$((package_type+1))
    fi
    if [ -d $prefix_contrib/__archive__/$package_dir ]
    then
        (( $(find $prefix_contrib/__archive__/$package_dir -name "*.eb" | wc -l) )) && is_contrib_archived_easyconfig=1
    fi
    (( $is_contrib_readme || $is_contrib_user || $is_contrib_easyconfig || $is_contrib_archived_easyconfig )) && is_contrib_package=1
    >&2 echo "$package: contrib package: $is_contrib_package, README: $is_contrib_readme, USER: $is_contrib_user, LICENSE: $is_contrib_license, EB: $is_contrib_easyconfig, archived EB: $is_contrib_archived_easyconfig."

    is_container_package=0              # Variable: Set to 1 if any information about this package is found in LUMI-EasyBuild-container
    is_container_readme=0               # Variable: Set to 1 if a README file is found in LUMI-EasyBuild-container for this package
    is_container_user=0                 # Variable: Set to 1 if a USER file is found in LUMI-EasyBuild-container for this package
    is_container_license=0              # Variable: Set to 1 if a license file is found in LUMI-EasyBuild-container for this package
    is_container_easyconfig=0           # Variable: Set to 1 if there are active EasyConfigs in LUMI-EasyBuild-container for this package
    is_container_archived_easyconfig=0  # Variable: Set to 1 if there are archived EasyConfigs in LUMI-EasyBuild-container for this package
    if [ -d $prefix_container/$package_dir ]
    then
        [ -f $prefix_container/$package_dir/README.md ]                          && is_container_readme=1     && is_readme=$(($is_readme + 1))
        [ -f $prefix_container/$package_dir/$userinfo ]                          && is_container_user=1       && is_user=$(($is_user + 1))
        [ -f $prefix_container/$package_dir/LICENSE.md ]                         && is_container_license=1    && is_license=$(($is_license + 1))
        (( $(find $prefix_container/$package_dir -name "*.eb" | wc -l) ))        && is_container_easyconfig=1 
        package_type=$((package_type+1))
    fi
    if [ -d $prefix_container/__archive__/$package_dir ]
    then
        (( $(find $prefix_container/__archive__/$package_dir -name "*.eb" | wc -l) )) && is_container_archived_easyconfig=1
    fi
    (( $is_container_readme || $is_container_user || $is_container_easyconfig || $is_container_archived_easyconfig )) && is_container_package=1
    >&2 echo "$package: container package: $is_container_package, README: $is_container_readme, USER: $is_container_user, LICENSE: $is_container_license, EB: $is_container_easyconfig, archived EB: $is_container_archived_easyconfig."

    is_archived=0  # Variable: Set to 1 if the package is archived, i.e., no active easyconfigs in neither LUMI-SoftwareStack nor LUMI-EasyBuild-contrib nor LUMI-EasyBuild-container
    (( (! is_stack_easyconfig && ! is_contrib_easyconfig && ! is_container_easyconfig) && (is_stack_archived_easyconfig || is_contrib_archived_easyconfig || is_container_archived_easyconfig) )) && is_archived=1

    #
    # Now check for packages that are not offered via EasyBuild but for which we have build instructions in LUMI-EasyBuild-docs
    #
    is_other_package=0              # Variable: Set to 1 if any information about this package is found in LUMI-EasyBuild-docs
    is_other_readme=0               # Variable: Set to 1 if a README file is found in LUMI-EasyBuild-docs for this package
    is_other_user=0                 # Variable: Set to 1 if a USER file is found in LUMI-EasyBuild-docs for this package
    is_other_license=0              # Variable: Set to 1 if a license file is found in LUMI-EasyBuild-docs for this package
    if [ -d $prefix_other/$package_dir ]
    then
        [ -f $prefix_other/$package_dir/README.md ]                          && is_other_readme=1     && is_readme=$(($is_readme + 1))
        [ -f $prefix_other/$package_dir/$userinfo ]                          && is_other_user=1       && is_user=$(($is_user + 1))
        [ -f $prefix_other/$package_dir/LICENSE.md ]                         && is_other_license=1    && is_license=$(($is_license + 1))
        package_type=$((package_type+1))
    fi
    (( $is_other_readme || $is_other_user )) && is_other_package=1
    >&2 echo "$package: other package:   $is_other_package, README: $is_other_readme, USER: $is_other_user, LICENSE: $is_other_license."
    >&2 echo "$package: Combined:           README: $is_readme, USER: $is_user, LICENSE: $is_license."

    #
    # Build the package file
    #
    # - Package file header
    #

    mkdir -p $gendoc/docs/$package_dir
    package_file="$gendoc/docs/$package_dir/index.md"

	echo -e "---\ntitle: $package"                 >$package_file
    echo -e "search:\n  boost: ${search_package}" >>$package_file
	echo -e "hide:\n- navigation\n---\n"          >>$package_file
    echo -e "[[package list]](../../index.md)\n"  >>$package_file
	echo -e "# $package\n"                        >>$package_file
    echostring=""
    (( is_stack_easyconfig ))     && echostring="$echostring<span class='lumi-software-button-preinstalled-hover'><span class='lumi-software-button-preinstalled'></span></span>"
    (( is_contrib_easyconfig ))   && echostring="$echostring<span class='lumi-software-button-userinstallable-hover'><span class='lumi-software-button-userinstallable'></span></span>"
    (( is_container_easyconfig )) && echostring="$echostring<span class='lumi-software-button-container-hover'><span class='lumi-software-button-container'></span></span>"
    (( is_archived ))             && echostring="$echostring<span class='lumi-software-button-archivedapp-hover'><span class='lumi-software-button-archivedapp'></span></span>"
    echo -e "$echostring\n"                                    >>$package_file

    #
    # - License (if present), priority to the information in the stack, then contrib and finally other_packages
    #
    if (( is_license ))
    then

        echo -e "## License information\n"                                               >>$package_file

        if (( is_stack_license ))
        then
            egrep -v "^# " "$prefix_stack/$package_dir/LICENSE.md" | sed -e 's|^##|###|'   >>$package_file
        elif (( is_contrib_license ))
        then
            egrep -v "^# " "$prefix_contrib/$package_dir/LICENSE.md" | sed -e 's|^##|###|' >>$package_file
         elif (( is_container_license ))
        then
            egrep -v "^# " "$prefix_container/$package_dir/LICENSE.md" | sed -e 's|^##|###|' >>$package_file
        elif (( is_other_license ))
        then
            egrep -v "^# " "$prefix_other/$package_dir/LICENSE.md" | sed -e 's|^##|###|'   >>$package_file
        fi

        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                                    >>$package_file

    fi

    #
    # - Software stack user information (if present)
    #
    if (( is_stack_user ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## User documentation\n"                                     >>$package_file
        else
            echo -e "## User documentation (central installation)\n"              >>$package_file
        fi
        egrep -v "^# " "$prefix_stack/$package_dir/$userinfo" | sed -e 's|^##|###|' >>$package_file

        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                             >>$package_file

        # If there is a files subdirectory, copy the content to the files subdirectory in
        # in the $gendoc tree.
        if [ -d "$prefix_stack/$package_dir/files" ]
        then
            >&2 echo "Subdirectory $prefix_stack/$package_dir/files detected, copying data."
            mkdir -p "$gendoc/docs/$package_dir/files" || die "Failed to create $gendoc/docs/$package_dir/files."
            # Note that using quotes below with the * does not work as it turns globbing off
            /bin/cp -r $prefix_stack/$package_dir/files/* "$gendoc/docs/$package_dir/files/" || 
                die "Failed to copy files from $prefix_stack/$package_dir/files to $gendoc/docs/$package_dir/files."
        fi
    fi

    #
    # - Contrib user information (if present)
    #
    if (( is_contrib_user ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## User documentation\n"                                       >>$package_file
        else
            echo -e "## User documentation (user installation)\n"                   >>$package_file
        fi
        egrep -v "^# " "$prefix_contrib/$package_dir/$userinfo" | sed -e 's|^##|###|' >>$package_file

        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                             >>$package_file

        # If there is a files subdirectory, copy the content to the files subdirectory in
        # in the $gendoc tree.
        if [ -d "$prefix_contrib/$package_dir/files" ]
        then
            >&2 echo "Subdirectory $prefix_contrib/$package_dir/files detected, copying data."
            mkdir -p "$gendoc/docs/$package_dir/files" || die "Failed to create $gendoc/docs/$package_dir/files."
            # Note that using quotes below with the * does not work as it turns globbing off
            /bin/cp -r $prefix_contrib/$package_dir/files/* "$gendoc/docs/$package_dir/files/" || 
                die "Failed to copy files from $prefix_contrib/$package_dir/files to $gendoc/docs/$package_dir/files."
        fi
    fi

    #
    # - Container user information (if present)
    #
    if (( is_container_user ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## User documentation\n"                                         >>$package_file
        else
            echo -e "## User documentation (singularity container)\n"                 >>$package_file
        fi
        egrep -v "^# " "$prefix_container/$package_dir/$userinfo" | sed -e 's|^##|###|' >>$package_file

        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                             >>$package_file

        # If there is a files subdirectory, copy the content to the files subdirectory in
        # in the $gendoc tree.
        if [ -d "$prefix_container/$package_dir/files" ]
        then
            >&2 echo "Subdirectory $prefix_container/$package_dir/files detected, copying data."
            mkdir -p "$gendoc/docs/$package_dir/files" || die "Failed to create $gendoc/docs/$package_dir/files."
            # Note that using quotes below with the * does not work as it turns globbing off
            /bin/cp -r $prefix_container/$package_dir/files/* "$gendoc/docs/$package_dir/files/" || 
                die "Failed to copy files from $prefix_container/$package_dir/files to $gendoc/docs/$package_dir/files."
        fi
    fi

    #
    # - Other_package user information (if present)
    #
    if (( is_other_user ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## User documentation\n"                                       >>$package_file
        else
            echo -e "## User documentation (manual installation)\n"                 >>$package_file
        fi
        egrep -v "^# " "$prefix_other/$package_dir/$userinfo" | sed -e 's|^##|###|' >>$package_file

        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                               >>$package_file

        # If there is a files subdirectory, copy the content to the files subdirectory in
        # in the $gendoc tree.
        if [ -d "$prefix_other/$package_dir/files" ]
        then
            >&2 echo "Subdirectory $prefix_other/$package_dir/files detected, copying data."
            mkdir -p "$gendoc/docs/$package_dir/files" || die "Failed to create $gendoc/docs/$package_dir/files."
            # Note that using quotes below with the * does not work as it turns globbing off
            /bin/cp -r $prefix_other/$package_dir/files/* "$gendoc/docs/$package_dir/files/" || 
                die "Failed to copy files from $prefix_other/$package_dir/files to $gendoc/docs/$package_dir/files."
        fi
    fi

    #
    # - Centrally installed modules
    #
    if (( is_stack_easyconfig ))
    then

        prefix="$prefix_stack/$package_dir"

        #
        # Title of the section
        #

        echo -e "## Pre-installed modules (and EasyConfigs)\n" >>$package_file
        
        work=${stack_module_preamble/<name>/$package}
        echo -e "$work\n"                                      >>$package_file

        #
        # List the modules / EasyConfigs.
        #

        for file in $(/bin/ls -1 $prefix/*.eb | sort -f)
	    do

            easyconfig="${file##$prefix/}"
		    easyconfig_md="$gendoc/docs/$package_dir/${easyconfig/.eb/.md}"

            work=${easyconfig%%.eb}
            version=${work##$package-}

		    >&2 echo "Processing $package/$version, generating $easyconfig_md..."

            #
            # Generate the easyconfig file for $package/$version
            #

            easyconfig_to_md "$file" "$easyconfig_md" "$stack_module_preamble"

            #
            # Add the module / easyconfig to the package file:
            #
            # - Link to the EasyConfig page
            echo -e "-   [$package/$version (EasyConfig: $easyconfig)](${easyconfig/.eb/.md})\n" >>$package_file
            # - #DOC lines, if any
            add_easyconfig_docs $file $package_file "    "

        done # for file in ...

        # Add empty lines at the end of the section
        printf "\n\n"  >>$package_file

    fi # end of if (( is_stack_easyconf ))

    #
    # - User-installable modules
    #
    if (( is_contrib_easyconfig ))
    then

        prefix="$prefix_contrib/$package_dir"

        #
        # Title of the section
        #

        echo -e "## User-installable modules (and EasyConfigs)\n" >>$package_file
        
        work=${contrib_module_preamble/<name>/$package}
        echo -e "$work\n"                                         >>$package_file

        #
        # List the modules / EasyConfigs.
        #

        for file in $(/bin/ls -1 $prefix/*.eb | sort -f)
	    do

            easyconfig="${file##$prefix/}"
		    easyconfig_md="$gendoc/docs/$package_dir/${easyconfig/.eb/.md}"

            work=${easyconfig%%.eb}
            version=${work##$package-}

		    >&2 echo "Processing $package/$version, generating $easyconfig_md..."

            #
            # Generate the easyconfig file for $package/$version
            #
            easyconfig_to_md "$file" "$easyconfig_md" "$contrib_module_preamble"

            #
            # Add the module / easyconfig to the package file
            #
            # - Link to the EasyConfig page
            echo -e "-   [EasyConfig $easyconfig, will build $package/$version](${easyconfig/.eb/.md})\n" >>$package_file
            # - #DOC lines, if any
            add_easyconfig_docs $file $package_file "    "

        done # for file in ...

        # Add empty lines at the end of the section
        printf "\n\n"  >>$package_file

    fi # end of if (( is_contrib_easyconf ))

    #
    # - Container modules
    #
    if (( is_container_easyconfig ))
    then

        prefix="$prefix_container/$package_dir"

        #
        # Title of the section
        #

        echo -e "## Singularity containers with modules for binding and extras\n" >>$package_file
        
        work=${container_module_preamble/<name>/$package}
        echo -e "$work\n"                                       >>$package_file

        #
        # List the modules / EasyConfigs.
        #

        for file in $(/bin/ls -1 $prefix/*.eb | sort -f)
	    do

            easyconfig="${file##$prefix/}"
		    easyconfig_md="$gendoc/docs/$package_dir/${easyconfig/.eb/.md}"
            easyconfig_docker_md="$gendoc/docs/$package_dir/${easyconfig/.eb/-docker.md}"

            work=${easyconfig%%.eb}
            version=${work##$package-}

		    >&2 echo "Processing $package/$version, generating $easyconfig_md..."

            #
            # Generate the easyconfig file for $package/$version
            #

            easyconfig_to_md "$file" "$easyconfig_md" "$container_module_preamble"

            #
            # Add the module / easyconfig to the package file
            #

            echo -e "-   [EasyConfig $easyconfig, will provide $package/$version](${easyconfig/.eb/.md})" >>$package_file

            #
            # Can we find a .docker file via the EasyConfig? If so, process.
            #
            docker_line=$(egrep -e '^local_docker[[:space:]]*=' $file | sed -e 's|[ \t]*=[ \t]*|=|')
            local_docker=""
            eval $docker_line

            if [ -n "$local_docker" ]
            then

                # Generate the markdown version of the dockerfile
                dockerfile_to_md "$file" "$local_docker" "$easyconfig_docker_md" "$container_docker_preamble"

                # And add a link to it in the list of EasyConfigs.
                echo -e "    (with [docker definition](${easyconfig/.eb/-docker.md}))" >>$package_file

            fi # if [ -n $local_docker ]

            #
            # Add an empty line
            #
            echo >>$package_file

            #
            # Are there any #DOC lines to add?
            #
            add_easyconfig_docs $file $package_file "    "

        done # for file in ...

    fi # end of if (( is_container_easyconf ))

    #
    # - Software stack technical information (if present)
    #
    if (( is_stack_readme ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## Technical documentation\n"                                >>$package_file
        else
            # We have two or more README files
            echo -e "## Technical documentation (central installation)\n"         >>$package_file
        fi
        egrep -v "^# " "$prefix_stack/$package_dir/README.md" | sed -e 's|^#|##|' >>$package_file
        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                             >>$package_file
    fi

    #
    # - Contrib technical information (if present)
    #
    if (( is_contrib_readme ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## Technical documentation\n"                                    >>$package_file
        else
            # We have two or more README files
            echo -e "## Technical documentation (user EasyBuild installation)\n"      >>$package_file
       fi
        egrep -v "^# " "$prefix_contrib/$package_dir/README.md" | sed -e 's|^##|###|' >>$package_file
        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                                 >>$package_file
    fi

    #
    # - Container technical information (if present)
    #
    if (( is_container_readme ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## Technical documentation\n"                                      >>$package_file
        else
            # We have two or more README files
            echo -e "## Technical documentation (singularity container)\n"              >>$package_file
       fi
        egrep -v "^# " "$prefix_container/$package_dir/README.md" | sed -e 's|^##|###|' >>$package_file
        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                                   >>$package_file
    fi

    #
    # - Other package technical information (if present)
    #
    if (( is_other_readme ))
    then
        if (( $package_type == 1 ))
        then
            echo -e "## Technical documentation\n"                                  >>$package_file
        else
            # We have two or more README files
            echo -e "## Technical documentation (non-EasyBuild)\n"                  >>$package_file
        fi
        egrep -v "^# " "$prefix_other/$package_dir/README.md" | sed -e 's|^##|###|' >>$package_file
        # Make sure there is an empty line at the end of the text added by this block to avoid
        # wrong formatting of subsequent text.
        printf "\n\n"                                                               >>$package_file
    fi

    #
    # - Add a list of the archived EasyConfigs
    #
    if (( is_stack_archived_easyconfig || is_contrib_archived_easyconfig || is_container_archived_easyconfig ))
    then

        #
        # Title of the section
        #

        echo -e "## Archived EasyConfigs\n" >>$package_file

        if (( is_archived))
        then
            # Text if the package is archived
            echo -e "The EasyConfigs below are not directly available on the system for installation."  >>$package_file
            echo -e "They are however still a useful source of information if you want to port the"     >>$package_file
            echo -e "the install recipe to the currently available environments on LUMI.\n"             >>$package_file
        else
            # Text if the package is still available in other configurations.
            echo -e "The EasyConfigs below are additional easyconfigs that are not directly available"  >>$package_file
            echo -e "on the system for installation. Users are advised to use the newer ones and these" >>$package_file
            echo -e "archived ones are unsupported. They are still provided as a source of information" >>$package_file
            echo -e "should you need this, e.g., to understand the configuration that was used for"     >>$package_file
            echo -e "earlier work on the system.\n"                                                     >>$package_file
        fi

    fi # end of block to add the title and introduction for the archived easyconfigs.


    #
    # - Archived EasyConfigs from LUMI-SoftwareStack
    #
    if (( is_stack_archived_easyconfig ))
    then

        prefix="$prefix_stack/__archive__/$package_dir"
        >&2 echo "Checking for archived easyconfigs in $prefix..."

        #
        # Title of the section
        #

        echo -e "-   Archived EasyConfigs from [LUMI-SoftwareStack](https://github.com/lumi-supercomputer/LUMI-SoftwareStack/blob/main/easybuild/easyconfigs/__archive__/$package_dir) - previously centrally installed software" >>$package_file
        
        #
        # List the modules / EasyConfigs.
        #

        for file in $(/bin/ls -1 $prefix/*.eb | sort -f)
	    do

            easyconfig="${file##$prefix/}"  # Extract the filename of the eacyconfig out of the $prefix/*.eb name.
		    easyconfig_md="$gendoc/docs/$package_dir/${easyconfig/.eb/.md}" # Compute the location and name for the matching markdonw file.

            work=${easyconfig%%.eb}      # Drop the .eb filename extension
            version=${work##$package-}   # Drop the package name part from the extensionless easyconfig file name to compute the version.

		    >&2 echo "Processing $package/$version, generating $easyconfig_md..."

            #
            # Generate the easyconfig file for $package/$version
            #

            easyconfig_to_md "$file" "$easyconfig_md" "$stack_archived_module_preamble"

            #
            # Add the module / easyconfig to the package file
            #
            # - Link to the EasyConfig page
            echo -e "    -   [EasyConfig $easyconfig, with module $package/$version](${easyconfig/.eb/.md})\n" >>$package_file
            # - #DOC lines, if any
            add_easyconfig_docs $file $package_file "        "

        done # for file in ...

    fi # end of if (( is_stack_archived_easyconfig ))


    #
    # - Archived EasyConfigs from LUMI-EasyBuild-contrib
    #
    if (( is_contrib_archived_easyconfig ))
    then

        prefix="$prefix_contrib/__archive__/$package_dir"
        >&2 echo "Checking for archived easyconfigs in $prefix..."

        #
        # Title of the section
        #

        echo -e "-   Archived EasyConfigs from [LUMI-EasyBuild-contrib](https://github.com/lumi-supercomputer/LUMI-EasyBuild-contrib/blob/main/easybuild/easyconfigs/__archive__/$package_dir) - previously user-installable software" >>$package_file
        
        #
        # List the modules / EasyConfigs.
        #

        for file in $(/bin/ls -1 $prefix/*.eb | sort -f)
	    do

            easyconfig="${file##$prefix/}"  # Extract the filename of the eacyconfig out of the $prefix/*.eb name.
		    easyconfig_md="$gendoc/docs/$package_dir/${easyconfig/.eb/.md}" # Compute the location and name for the matching markdonw file.

            work=${easyconfig%%.eb}      # Drop the .eb filename extension
            version=${work##$package-}   # Drop the package name part from the extensionless easyconfig file name to compute the version.

		    >&2 echo "Processing $package/$version, generating $easyconfig_md..."

            #
            # Generate the easyconfig file for $package/$version
            #

            easyconfig_to_md "$file" "$easyconfig_md" "$contrib_archived_module_preamble"

            #
            # Add the module / easyconfig to the package file
            #
            # - Link to the EasyConfig page
            echo -e "    -   [EasyConfig $easyconfig, with module $package/$version](${easyconfig/.eb/.md})\n" >>$package_file
            # - #DOC lines, if any
            add_easyconfig_docs $file $package_file "        "

        done # for file in ...

    fi # end of if (( is_contrib_archived_easyconfig ))

    #
    # - Archived EasyConfigs from LUMI-EasyBuild-container
    #
    if (( is_container_archived_easyconfig ))
    then

        prefix="$prefix_container/__archive__/$package_dir"
        >&2 echo "Checking for archived easyconfigs in $prefix..."

        #
        # Title of the section
        #

        echo -e "-   Archived EasyConfigs from [LUMI-EasyBuild-containers](https://github.com/lumi-supercomputer/LUMI-EasyBuild-containers/blob/main/easybuild/easyconfigs/__archive__/$package_dir) - previously available singularity containerised software" >>$package_file
        
        #
        # List the modules / EasyConfigs.
        #

        for file in $(/bin/ls -1 $prefix/*.eb | sort -f)
	    do

            easyconfig="${file##$prefix/}"  # Extract the filename of the eacyconfig out of the $prefix/*.eb name.
		    easyconfig_md="$gendoc/docs/$package_dir/${easyconfig/.eb/.md}" # Compute the location and name for the matching markdown file.
            easyconfig_docker_md="$gendoc/docs/$package_dir/${easyconfig/.eb/-docker.md}" # Compute the location and name for the markdown file for the matching Docker definition. 

            work=${easyconfig%%.eb}      # Drop the .eb filename extension
            version=${work##$package-}   # Drop the package name part from the extensionless easyconfig file name to compute the version.

		    >&2 echo "Processing $package/$version, generating $easyconfig_md..."

            #
            # Generate the easyconfig file for $package/$version
            #

            easyconfig_to_md "$file" "$easyconfig_md" "$container_archived_module_preamble"

            #
            # Add the module / easyconfig to the package file
            #

            echo -e "    -   [EasyConfig $easyconfig, with module $package/$version](${easyconfig/.eb/.md})" >>$package_file

            #
            # Can we find a .docker file via the EasyConfig? If so, process.
            #
            docker_line=$(egrep -e '^local_docker[[:space:]]*=' $file | sed -e 's|[ \t]*=[ \t]*|=|')
            local_docker=""
            eval $docker_line

            if [ -n "$local_docker" ]
            then

                # Generate a markdown page for the dockerfile
                dockerfile_to_md "$file" "$local_docker" "$easyconfig_docker_md" "$container_docker_preamble"

                # And add a link to it in the list of EasyConfigs.
                echo -e " (with [docker definition](${easyconfig/.eb/-docker.md}))" >>$package_file

            fi # if [ -n $local_docker ]

            #
            # Add an empty line
            #
            echo >>$package_file

            #
            # Are there any #DOC lines to add?
            #
            add_easyconfig_docs $file $package_file "        "

        done # for file in ...

    fi # end of if (( is_container_archived_easyconfig ))

    #
    # Update the package list
    #
    [[ $group != $last_group ]] && echo -e "## $group\n" >>$package_list
    package_string="-   [$package](${package_file#$gendoc/docs/})"
    (( is_user ))              && package_string="$package_string <span class='lumi-software-smallbutton-userdoc-hover'><span class='lumi-software-smallbutton-userdoc'></span></span>"
    (( is_readme ))            && package_string="$package_string <span class='lumi-software-smallbutton-techdoc-hover'><span class='lumi-software-smallbutton-techdoc'></span></span>"
    (( is_archived ))          && package_string="$package_string <span class='lumi-software-smallbutton-archive-hover'><span class='lumi-software-smallbutton-archive'></span></span>"
    (( is_container_package )) && package_string="$package_string <span class='lumi-software-smallbutton-container-hover'><span class='lumi-software-smallbutton-container'></span></span>"
    echo -e "$package_string\n"                          >>$package_list

    #
    # Add a navigation item if needed.
    #
    [[ $group != $last_group ]] && echo "- $group: index.html#$group" >>$gendoc/mkdocs.yml

    # Set last_group
    last_group=$group

done

#
# Add a navigation items for the other information such as issues and what's new.
#

echo "- $other_info_label: known_issues.md"  >>$gendoc/mkdocs.yml
echo "- $whatsnew_label: whats_new.md"  >>$gendoc/mkdocs.yml
