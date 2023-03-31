---
title: Known issues with the LUMI software stacks
hide:
- navigation
---

# Known issues with the LUMI software stacks

## Issues with 22.12 and 23.03.

-   Some SUSE-provided tools may not work when the `ncurses` module is loaded.

    This is because SUSE delivers a heavily customised `ncurses` library and we do
    not know how they did the customisations. It also contains some versioned symbols
    info for ancient versions that is not included automatically anymore with more
    present `ncurses` libraries, even when asked to include versioned symbols in the
    shared objects.

    For `gdb` a workaround is to start it using

    ```
    LD_PRELOAD=/lib64/libncursesw.so.6 gdb
    ```

    which forces `gdb` to use the `libncursesw` from the system and keeps it happy.


## Issues with older versions of the LUMI stack

This documentation was not yet developed when those older stacks were build.

