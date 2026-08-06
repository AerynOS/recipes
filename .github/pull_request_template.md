<!--
SPDX-FileCopyrightText: 2026 AerynOS Developers
SPDX-License-Identifier: MPL-2.0
-->

# aerynOS Recipe Contribution Template

Thank you for contributing to aerynOS! Please fill out this template to help us review your contribution efficiently.

---

## Summary

<!-- Info on what this pull request updates/changes/etc -->

---

## Type of Change

- [ ] New package addition
- [ ] Package update/version bump
- [ ] Bug fix (existing package)
- [ ] Build system/tooling change
- [ ] Documentation update
- [ ] No Functional Change
- [ ] Other (please specify)

---

## For New Package Additions

**If you are adding a new package, all of the following must be completed:**

- [ ] An approved package request issue exists (link: #[issue number])
- [ ] I have confirmed this package was reviewed and approved by the aerynOS Team
- [ ] Dependencies are already in the repository (or included in this PR)
- [ ] I am willing to act as the primary maintainer for this package (optional but recommended)

**If you did NOT link to an approved issue,** please explain why in the description below.

---

## For Package Updates

- [ ] Changelog from upstream has been reviewed
- [ ] No regressions observed compared to previous version
- [ ] Updated version in recipe metadata matches upstream release
- [ ] Build dependencies have been reviewed for changes

---

## Testing Performed

- [ ] `just build` completes successfully
- [ ] Package installs via `moss`
- [ ] Application launches and functions as expected
- [ ] No obvious security or stability concerns
- [ ] The package was tested against the volatile stream

Additional testing notes:
<!-- Describe any additional testing you performed -->

---

## Checklist

- [ ] I have read the [Package Addition Policy](blob/main/PACKAGING_POLICY.md)
- [ ] I have read and conformed to the [Contributing Guidelines](https://aerynos.dev/packaging/)
- [ ] I confirm this work is my own or properly attributed
- [ ] No sensitive credentials, API keys, or secrets are included in this PR
- [ ] This change could gainfully be highlighted in the Stream Update notes once merged

---

## Additional Context

<!-- Any other information that might help reviewers understand your contribution -->

---

## Screenshots / Output (if applicable)

<!-- Paste any terminal output, screenshots, or build logs that demonstrate success -->
