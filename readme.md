# Alfred Workflow - Parallels Manager

This is an [Alfred Workflow](https://www.alfredapp.com/) (Alfred 3 & Alfred 4) which is used to manage all of your Parallels VMs (virtual machines). The options available are:

- Start
- Stop
- Restart
- Suspend
- Pause
- Resume

**Note:** You must have `jq` installed in `/usr/local/bin` for this to workflow to run. `jq` is a command-line JSON processor. For more information visit the [jq website](https://stedolan.github.io/jq/).

## How it works

![Alfred Parallels Manager](/docs/alfred-parallels-manager.gif)

## Installation

#### JQ install

As mention above, this worflow requires `jq` to be installed in `/usr/local/bin`. The easiest way to do this is using [homebrew](https://brew.sh/), which is a package manager for MacOS.

1. Ensure homebrew is installed - to do this, follow the instructions on the [homebrew website](https://brew.sh/)
2. Now that you have homebrew installed, launch terminal and run the following command `brew install jq`
3. Wait for jq to install
4. To validate it was installed in the correct location run `ls /usr/local/bin | grep jq`. If the words `jq` are returned then you know it has been installed. If not, jq is not installed in `/usr/local/bin`
5. It is very important you have `jq` installed before proceeding.

#### Alfred workflow

Next is the super easy part, installing the Parallels Manager workflow in Alfred.

1. First you actually need Alfred installed. If you don't have this head over to the [Alfred website](https://www.alfredapp.com/).
2. Clone or downlod this repo. Alternatively right click this [this link](./Parallels%20Manager.alfredworkflow) and select Save as.
3. Double click the `Parallels Manager.alfredworkflow` file
4. This will automatically install the workflow in Alfred

## Usage

To use Alfred Parallels Manager do the following:

1. Launch Alfred via your selected keyboard shortcut (mine is ⌘ + ␣)
2. Type the `xpvm` keyword and select Parallels Manager from the list
3. Parallels Manager will now retrieve a list of your VMs *(this might take a while, especially if Parallels is not yet running)*
4. Select a VM to manage and press `Enter`
5. Select an action to complete on the VM and press `Enter`
6. Enjoy

## Source Code

If you would like to make your own version all of the source code is available in the `src` directory.

## Alfred Version Support

This workflow has been tested successfully on Alfred 3 and Alfred 4.