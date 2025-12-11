# Dirty tricks

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

