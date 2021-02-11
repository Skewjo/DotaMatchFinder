# DotaMatchFinder

## Overview
This "app"/extension currently works as 2 pieces, though I hope to add quite a bit of functionality and combine the functionalities very, very soon.

The first piece is the chrome extension that provides a text box for you to input a 10 digit match ID. The extension will then download the zipped ".dem" file for the match using the OpenDota API.

The second piece is a powershell script that will 
 - find and unzip the demo file in your downloads folder
 - move that file to your dota folder
 - write/overwrite your autoexec.cfg file with the console command to play the particular demo
 - start up Dota & auto play the demo
(This script currently has to be kicked off manually)

## Platforms

I thought this project would end up being Windows only, but it turns out that [Powershell can run on Linux and MacOS!](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1)
There are definitely paths that won't work on other platforms, but a couple of minor changes should fix it right up.

## Getting Started
1. Clone the repo
2. Add the entire repo folder as an "unpacked extension" in chrome(very, very easy - google should help you here, but I may add some detailed instructions for this if necessary)
3. Use the extension to download your first match by typing in a 10 digit match id in the blank text box, and hit the "download match" button(if you're prompted on where to place the downloaded file, just put it in your normal download directory) 
4. Once you've used the extension to download a first match, attempt to run the "unzip_move_run.ps1" powershell script manually.
  - This is where you may hit snags. Common issues will be listed below.
    - Powershell initial setup

Please let me know if you run into any snags getting it to work! I can't fix bugs if I am unaware of them. :)
