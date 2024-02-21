# homebrew-ngscopeclient

Homebrew formulae that allow the installation of [`ngscopeclient`](https://github.com/ngscopeclient/scopehal-apps) through the [Homebrew](https://brew.sh/) package manager.

At the moment, the only formula provided is the one for `ngscopeclient`, and as `ngscopeclient` is under heavy development, this formula is head-only

## Installation

```
brew tap ngscopeclient/ngscopeclient
brew install --HEAD ngscopeclient
```

## Update

As this is a head-only formula, it will not automatically update, so you will need to reinstall it:
```
brew reinstall ngscopeclient
```


## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh/)

Bugs related to the Homebrew packaging should be filed here; bugs related to the various subprojects should be filed at their respective repositories.