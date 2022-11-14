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

#
# Where do we find the EasyConfig files?
#
prefix_stack="${repodir%%$repo}LUMI-SoftwareStack/easybuild/easyconfigs"
prefix_contrib="${repodir%%$repo}LUMI-EasyBuild-contrib/easybuild/easyconfigs"

>&2 echo "Software stack easyconfig directory: $prefix_stack"
>&2 echo "Contributed easyconfig directory: $prefix_contrib"

#
# Set up the package list file
#
package_list="$gendoc/docs/index.md"

echo -e "---\ntitle: Package overview\nhide:\n- navigation\n---\n" >$package_list
echo -e "# Package list\n" >>$package_list
echo -e "<span class='lumi-software-button-userdoc'></span>: Specific user documentation available\n" >> $package_list
echo -e "<span class='lumi-software-button-techdoc'></span>: Technical documentation available\n"     >> $package_list

#
# Some initialisations
#
last_group='.'

#
# Loop over all packages
#
#for package_dir in $(/bin/ls -1 $prefix_stack/b/*/*.eb $prefix_contrib/q/*/*.eb | sed -e 's|.*/easyconfigs/\(.*/.*\)/.*\.eb|\1|' | sort -uf)
for package_dir in $(/bin/ls -1 $prefix_stack/*/*/*.eb $prefix_contrib/*/*/*.eb | sed -e 's|.*/easyconfigs/\(.*/.*\)/.*\.eb|\1|' | sort -uf)
do

	>&2 echo "Processing $package_dir..." 

	# Extract the first letter and the name of the package.
	package=${package_dir##[0-9a-z]/}
	group=${package_dir%%/$package}
	
	>&2 echo "Identified group $group, package $package"

    #
    # Check the nature of the package
    #
    is_readme=0
    is_user=0

    is_stack_package=0
    is_stack_readme=0
    is_stack_user=0
    is_stack_easyconfig=0
    if [ -d $prefix_stack/$package_dir ]
    then
        [ -f $prefix_stack/$package_dir/README.md ]                      && is_stack_readme=1     && is_readme=1
        [ -f $prefix_stack/$package_dir/$userinfo ]                      && is_stack_user=1       && is_user=1  
        (( $(find $prefix_stack/$package_dir -name "*.eb" | wc -l) ))    && is_stack_easyconfig=1
        (( $is_stack_readme || $is_stack_user || $is_stack_easyconfig )) && is_stack_package=1
    fi
    >&2 echo "$package: stack package:   $is_stack_package, README: $is_stack_readme, USER: $is_stack_user, EB: $is_stack_easyconfig."

    is_contrib_package=0
    is_contrib_readme=0
    is_contrib_user=0
    is_contrib_easyconfig=0
    if [ -d $prefix_contrib/$package_dir ]
    then
        [ -f $prefix_contrib/$package_dir/README.md ]                          && is_contrib_readme=1     && is_readme=1
        [ -f $prefix_contrib/$package_dir/$userinfo ]                          && is_contrib_user=1       && is_user=1
        (( $(find $prefix_contrib/$package_dir -name "*.eb" | wc -l) ))        && is_contrib_easyconfig=1
        (( $is_contrib_readme || $is_contrib_user || $is_contrib_easyconfig )) && is_contrib_package=1
    fi
    >&2 echo "$package: contrib package: $is_contrib_package, README: $is_contrib_readme, USER: $is_contrib_user, EB: $is_contrib_easyconfig."

    #
    # Build the package file
    #
    # - Package file header
    #

    mkdir -p $gendoc/docs/$package_dir
    package_file="$gendoc/docs/$package_dir/index.md"

	echo -e "---\ntitle: $package\nhide:\n- navigation\n---\n"  >$package_file
    echo -e "[[package list]](../../index.md)\n"               >>$package_file
	echo -e "# $package\n"                                     >>$package_file
    echostring=""
    (( is_stack_package ))   && echostring="$echostring<span class='lumi-software-button-preinstalled-hover'><span class='lumi-software-button-preinstalled'></span></span>"
    (( is_contrib_package )) && echostring="$echostring<span class='lumi-software-button-userinstallable-hover'><span class='lumi-software-button-userinstallable'></span></span>"
    echo -e "$echostring\n"                                    >>$package_file

    #
    # - Software stack user information (if present)
    #
    if (( is_stack_user ))
    then
        if (( is_stack_contrib ))
        then
            echo -e "## User documentation (central installation)\n"              >>$package_file
        else
            echo -e "## User documentation\n"                                     >>$package_file
        fi
        egrep -v "^# " "$prefix_stack/$package_dir/$userinfo" | sed -e 's|^#|##|' >>$package_file

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
        if (( is_contrib_contrib ))
        then
            echo -e "## User documentation (user installation)\n"                   >>$package_file
        else
            echo -e "## User documentation\n"                                       >>$package_file
        fi
        egrep -v "^# " "$prefix_contrib/$package_dir/$userinfo" | sed -e 's|^#|##|' >>$package_file

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

            work=${stack_module_preamble/<name>/$package}
            work=${work/<version>/$version}

            #
            # Generate the easyconfig file for $package/$version
            #

            echo -e "---\ntitle: $package/$version ($easyconfig) - $package"     >$easyconfig_md
            echo -e "hide:\n- navigation\n- toc\n---\n"                         >>$easyconfig_md
            echo -e "[[$package]](index.md) [[package list]](../../index.md)\n" >>$easyconfig_md
            echo -e "# $package/$version ($easyconfig)\n"                       >>$easyconfig_md
            echo -e "$work\n"                                                   >>$easyconfig_md
		    echo -e '``` python'                                                >>$easyconfig_md
		    cat $file                                                           >>$easyconfig_md
		    echo -e '\n```\n'                                                   >>$easyconfig_md
            echo -e "[[$package]](index.md) [[package list]](../../index.md)"   >>$easyconfig_md
            # Note the extra \n in front of the last ``` as otherwise files that do not end
            # with a newline would cause trouble.

            #
            # Add the module / easyconfig to the package file
            #

            echo -e "-   [$package/$version (EasyConfig: $easyconfig)](${easyconfig/.eb/.md})" >>$package_file

        done # for file in ...

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
        echo -e "$work\n"                                       >>$package_file

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

            work=${contrib_module_preamble/<name>/$package}
            work=${work/<version>/$version}
            work=${work/<easyconfig>/$easyconfig}

            #
            # Generate the easyconfig file for $package/$version
            #

            echo -e "---\ntitle: $package/$version ($easyconfig) - $package"     >$easyconfig_md
            echo -e "hide:\n- navigation\n- toc\n---\n"                         >>$easyconfig_md
            echo -e "[[$package]](index.md) [[package list]](../../index.md)\n" >>$easyconfig_md
            echo -e "# $package/$version ($easyconfig)\n"                       >>$easyconfig_md
            echo -e "$work\n"                                                   >>$easyconfig_md
		    echo -e '``` python'                                                >>$easyconfig_md
		    cat $file                                                           >>$easyconfig_md
		    echo -e '\n```\n'                                                   >>$easyconfig_md
            echo -e "[[$package]](index.md) [[package list]](../../index.md)"   >>$easyconfig_md
            # Note the extra \n in front of the last ``` as otherwise files that do not end
            # with a newline would cause trouble.

            #
            # Add the module / easyconfig to the package file
            #

            echo -e "-   [$package/$version (EasyConfig: $easyconfig)](${easyconfig/.eb/.md})" >>$package_file

        done # for file in ...

    fi # end of if (( is_stack_easyconf ))


    #
    # - Software stack technical information (if present)
    #
    if (( is_stack_readme ))
    then
        if (( is_stack_contrib ))
        then
            echo -e "## Technical documentation (central installation)\n"         >>$package_file
        else
            echo -e "## Technical documentation\n"                                >>$package_file
        fi
        egrep -v "^# " "$prefix_stack/$package_dir/README.md" | sed -e 's|^#|##|' >>$package_file
    fi

    #
    # - Contrib technical information (if present)
    #
    if (( is_contrib_readme ))
    then
        if (( is_contrib_contrib ))
        then
            echo -e "## Technical documentation (user installation)\n"              >>$package_file
        else
            echo -e "## Technical documentation\n"                                  >>$package_file
        fi
        egrep -v "^# " "$prefix_contrib/$package_dir/README.md" | sed -e 's|^#|##|' >>$package_file
    fi


    #
    # Update the package list
    #
    [[ $group != $last_group ]] && echo -e "## $group\n" >>$package_list
    package_string="-   [$package](${package_file#$gendoc/docs/})"
    (( is_user ))   && package_string="$package_string <span class='lumi-software-button-userdoc-hover'><span class='lumi-software-button-userdoc'></span></span>"
    (( is_readme )) && package_string="$package_string <span class='lumi-software-button-techdoc-hover'><span class='lumi-software-button-techdoc'></span></span>"
    echo -e "$package_string\n"                          >>$package_list

    #
    # Add a navigation item if needed.
    #
    [[ $group != $last_group ]] && echo "- $group: index.html#$group" >>$gendoc/mkdocs.yml

    # Set last_group
    last_group=$group

done
