# Dirty tricks

## Extracting the LUMI stack version from an EasyConfig

We do this to warn for packages that are available in the CCPE containers rather than in the
regular LUMI stacks on the system.

-   If the application is compiled with one of the cpe toolchains, it is easy as the toolchain
    should also be part of the name of the EasyConfig, so we can just parse the name and extract
    the CPE version using a regular expression.

-   For SYSTEM packages the situation is a bit more difficult. Some of those packages are really
    meant to be used with multiple stacks so we cannot really warn users if they are only available
    in one of the CCPE containers.

    However, if they are really meant for a particular version of the CPE, one can add the line
    
    ```
    #LUMISTACK yy.mm
    ```

    to the EasyConfig and we can extract that one with some `grep` and `sed` trickery.

This results in the following code fragment:

``` bash
function selecttc() {

    local name="$1"
    local -n lumistack=$2
    local line

    case "$name" in
        # For cpeXXX packages, we can extract the lumi stack number from the toolchain used
        *-cpeGNU-*)  lumistack=$(echo $name | sed 's/.*cpeGNU-\([0-9]\{2\}\.[0-9]\{2\}\).*/\1/') ;;
        *-cpeCray-*) lumistack=$(echo $name | sed 's/.*cpeCray-\([0-9]\{2\}\.[0-9]\{2\}\).*/\1/') ;;
        *-cpeAOCC-*) lumistack=$(echo $name | sed 's/.*cpeAOCC-\([0-9]\{2\}\.[0-9]\{2\}\).*/\1/') ;;
        *-cpeAMD-*)  lumistack=$(echo $name | sed 's/.*cpeAMD-\([0-9]\{2\}\.[0-9]\{2\}\).*/\1/') ;;
        # For other packages, we check if there is a #LUMISTACK line in the EasyConfig and use that one
        *)           if line=$(egrep '^#LUMISTACK' $name)  
                     then lumistack=$(egrep '^#LUMISTACK' $name | sed 's/.*\([0-9]\{2\}\.[0-9]\{2\}\).*/\1/') 
                     else lumistack='unknown' 
                     fi
                     ;;
    esac

}
```

The routine takes two arguments:

-   The name of the EasyConfig (including the path from the current directory)

-   The name of the variable that receives the result of the function.

    For this we use bash functionality that needs at least bash 4.3 (which is more recent thant the one
    offered in macOS but should not be an issue on any recent Linux machine).


## Checking if a string is in a list of strings

We do this to check if a LUMI stack version that we extracted from an EasyConfig is in the list
of versions that are only available as a container.

Code fragment:

``` bash
if [[ " ${ccpeonly[*]} " =~ " $lumi_stack_version " ]]
then ccpe_label='(CCPE container only) '
else ccpe_label=''
fi
```

`" ${ccpeonly[*]} "` creates a single string from the list of version numbers, all 
separated by a space and with a space at the start and end of the string (likely not needed
in this case as the stack version will never be a subset of a string in the list),
and then we test if the LUMI stack version (also with a space in front and at the end) matches
part of that string.

