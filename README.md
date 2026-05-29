# LOREIN COMMUNITY BRIDGE

Welcome to the public and open-core space of the Lorein ecosystem.
This repository acts as the development kit (SDK) and integration gateway for the international community.

## PROJECT PHILOSOPHY

- Absolute frugality ($0 platform operational expenditure).
- Local-First approach (designed to run entirely offline).
- Hardened security and data integrity.

## REPOSITORY STRUCTURE

This project leverages Git submodules to orchestrate its public components:

- `.github`: Centralization of automations and community configurations.
- `submodules/gov-work-registry`: Public audit and transparency registry.
- `submodules/gov-work-templates`: Official layout and typography templates.

## CLONING AND LOCAL INITIALIZATION

To retrieve this project along with all its active submodules on your local machine, execute the following command in your terminal:

```bash
git clone --recurse-submodules https://github.com/Lorein-org/community-bridge.git
```

If you already cloned the repository without the submodules, initialize them manually using:

```bash
git submodule update --init --recursive
```
