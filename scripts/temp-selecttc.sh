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
