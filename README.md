# Trinity
WIP Qt5 QML Matrix client

## Features
* Basic messaging capabilities
  * Send and recieve formatted messages using Markdown
  * Send and recieve image and file attachments
  * Typing notifications
  * Start direct chats with other members
* Desktop notification support
 * Per-room notification settings
* List and join rooms
  * Invite other people and accept invites
* Use custom emotes

## Matrix Module Support

Module| Finished| Notes
--------|-----|------
Instant Messaging|Partially|See [#2](https://github.com/invghost/Trinity/issues/2)
VOIP|Partially|Only recieving calls is supported
Typing Notifications|Yes|
Receipts|Partially|Can't see other user's receipts. See [#8](https://github.com/invghost/Trinity/issues/8)
Presence|No|See [#16](https://github.com/invghost/Trinity/issues/16)
Content repository|Yes|
Device Management|No|
End-to-End Encryption|No|See [#1](https://github.com/invghost/Trinity/issues/1)
Third party invites|No|
Server Side Search|No|
Guest Access|No|
Room Previews|No|
Room Tagging|No|
Server Administration|No|Low priority
Event Context|No|
Direct Messaging|Yes|

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
