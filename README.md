# Anchor Binder

A sml/nj CM tool, for automagically binding anchors from a directory.

## Usage

Add to your sources.cm

```
libs/anchorbind/anchorbind-tool.cm : tool
libs : anchor_dir
```

Every subdirectory of libs/ will now be bound to an anchor of with its name
For instance, if you have a subdirectory `libs/foo/` which contains a file `foo.cm`
With the above setup, you can now refer to this file like:

```
$foo/foo.cm
```
