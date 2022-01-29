# freja-single-space

Roughly, collapse contiguous spaces down to a single space.

## Prerequisites

The [freja editor](https://github.com/saikyun/freja).

## Setup

0. Clone this repository somewhere and cd to the resulting directory
1. Start freja with: `freja ./freja-single-space/freja-single-space.janet`
2. `Control+L` to load the file

## Example Usage

1. In freja's buffer window, type some text with contiguous spaces
   surrounded by non-whitespace characters, e.g.:
    ```
    "hello         there"
    ```

2. With the cursor within the contiguous whitespace, press the key sequence
   `Alt+Space`.

3. Observe the editor buffer content change to:
    ```
    "hello there"
    ```

