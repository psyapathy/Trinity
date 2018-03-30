# Trinity
WIP Qt5 QML Matrix client

## Features
* Basic messaging capabilities
  * Sending and recieving markdown messages, formatting can be disabled
  * Typing notifications
* Per-room notification settings
* Listing and joining public rooms
  * Inviting other members and accepting other people's invites
* Start direct chats with other members
* Custom emote support

## Screenshots

![Screenshot](https://raw.githubusercontent.com/invghost/Trinity/master/misc/screenshot.png)

## Dependencies
* Qt5
* CMark

## Packages
Arch Linux
[Link to AUR](https://aur.archlinux.org/packages/trinity-matrix-git/)

## Building
Make sure to install ALL of the dependencies listed above!!

Create a build directory and enter it:
`mkdir build && cd build`

Invoke CMake:
`cmake ..`

Compile using the chosen build system (in this case, make):
`make`

## License
Trinity's source is distributed under the GPLv3 license. See the `LICENSE` file for more details.

`background.jpg` shown on the login page is from Death to Stock.
