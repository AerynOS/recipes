## Kernel packaging process on AerynOS

This is intended as an introduction to one way of doing kernel maintainenance on AerynOS.

We expect kernel maintainers to know their way around patches and kernel configuration in general.

Use e.g. https://kernelconfig.io to look up definitions of what kernel options do.


### 1. Update the upstream version and tarball

As with any package, update your `stone.yaml` to point to the latest tarball.

```
grep http stone.yaml
# (output elided)
# use this output to create a `boulder recipe update` invocation
boulder recipe update --ver <the version> --upstream <the matching upstream uri>
```

### 2. Check if the kernel builds

As with every other package, you build the kernel with `just build`.

Every build runs `make oldconfig` to ensure that new kernel options get picked up.

If you receive no questions and the kernel build finishes like you expect, congratulations,
you're done updating the kernel.


### 3. The build asks `make oldconfig` configuration questions

This is an indication that you need to update the kernel configuration in `pkg/config-x86_64`.

This is done inside the kernel chroot:

setup section before:

```

    %install_file %(pkgdir)/config-x86_64 .config
    %make CC=%(cc) LD=%(ld) ARCH=x86_64 LLVM=1 LLVM_IAS=1 WERROR=0 oldconfig || exit 1
```

setup section that has been prepared for doing a `make oldconfig` run inside the build chroot:

```
  
    %install_file %(pkgdir)/config-x86_64 .config

    # show the command to run this correctly in the chroot
    echo "%make CC=%(cc) LD=%(ld) ARCH=x86_64 LLVM=1 LLVM_IAS=1 WERROR=0 oldconfig || exit 1"

    # exit the chroot when exiting the chroot shell, failing the build
    %break_exit
```

Exchange `oldconfig` with `nconfig` if you need to make more in-depth adjustments to the kernel config.

Note that previous kernel configuration experience is assumed.

#### How to smuggle the new config out of the guest buildroot

The newly updated kernel `.config` in `%(workdir)` needs to be smuggled out from the build container to the host and saved.

This is done by opening a new tab/shell on the host, navigating to the l/linux-desktop dir, and doing a copy operation that looks akin to this:

    cp -v ~/.cache/boulder/build/linux-desktop-<version>-<source-release>/x86_64/linux-<version>.tar.xz/.config pkg/config-x86_64

At that point, all that's left is to run `git diff .` to check that everything looks sane.

Finally, exit the chroot and restart the build.


### 4. Some patches fail to apply

The recipe has been set up to enable you to comment out individual patches from the `pkg/patches/series` file.

Simply repeatedly run `just build` with more and more failing patches commented out until the setup phase completes.

You can optionally replace `%break_exit` with `%break_continue` in the last step, which will make the build continue after you exit the chroot shell.


### 5. Kernel rebuild story

When submitting a PR, it is important to also remember to either update or `just bump`, then `just build` the `nvidia-open-gpu-kernel-modules` with the kernel added to your local repo.

If you update the `nvidia-open-gpu-kernel-modules` rather than just bumping it, you will also need to ensure that the nvidia-graphics-driver is in sync.


### Conclusion

Once the kernel builds and you have tested that it boots and works on your local machine, you can submit a PR.

Best of luck on your kernel maintenance journey. ^^'


