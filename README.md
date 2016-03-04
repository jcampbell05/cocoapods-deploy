# cocoapods-deployment

Cocoapods Deployment is a plugin which tries to mimic the behaviour of bundlers `--deplyment` mode.

The goal is to download and install the specific dependency versions from the `Podfile.lock` without having to pull down the full Cocoapods specs repo.

## Installation

    $ gem install cocoapods-deployment

## Usage

    $ pod spec deployment POD_NAME
