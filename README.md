# Tokenized-data-access-system
TDAS allows people to buy access to data on the blockchain

//RECOMENDED TO USE DEBIAN BASED DISTROS IE (DEBIAN 12, UBUNTU 22.04LTS, UBUNTU 24.04LTS, ETC...) VIA (BARE METAL, VIRTUAL BOX, GNOME BOXES, VM WARE, WSL-1, WSL-2)//

Requirements to deploy contract (Instructions are made for linux only!):

Step 1 (Download NodeJS via NVM & setup shortcut commands)

Firstly, go to NVM's github page here --> https://github.com/nvm-sh/nvm?tab=readme-ov-file#manual-install <--- use their instructions for installations use mine for setup after install!

Secondly, set up command shortcuts to activate nvm and all software related to it on demand via opening the terminal then typing in sudo nano .bashrc

Thirdly, once you are within the .bashrc file go to the verry bottom and type in alias startnvm='export NVM_DIR="$HOME/.nvm" && \. "$NVM_DIR/nvm.sh"' it should look something like this.
<img width="779" height="105" alt="Screenshot from 2025-07-17 09-20-11" src="https://github.com/user-attachments/assets/9ccc7743-a27f-4f43-9a10-fc9038309960" />

Fourthy, press ctrl + x proceed to type in y then press enter.

Step 2 (Download VsCode)

Firstly, go to https://code.visualstudio.com/Download <--- Download vs code from the offical site.

Secondly, go to files on linux this would either be tittled, Files or Dolphin.

Thirdly, once in files navigate to downloads directory right click on .deb or .rpm and use ubuntu app store, gdebi, gnome store or which ever method your distro has to download vscode.
[Screencast from 2025-07-17 10:08:02 AM.webm](https://github.com/user-attachments/assets/71f24e40-7d4c-4167-ba8a-b12ec5221832)

<July 16th 2025>
Update 0.1.4: Updated GPL licensing, requires interface contract in order to mint/purchase tokens, changes when sender contract is registered.
