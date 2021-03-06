# nvim
My personal editor

## For Big Norms

1. Install neovim

- Install build dependencies

```bash
$ sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
$ pip install cmake
```

- Clone neovim source code into chosen directory (I use Source directory)

```bash
$ mkdir ~/Source && cd Source
$ git clone https://github.com/neovim/neovim.git
```

- Make neovim binary

```bash
$ cd neovim
$ make CMAKE_BUILD_TYPE=RelWithDebInfo
$ sudo make install
```

- Check neovim correcltly installed

```bash
$ nvim --version
```

2. Clone repo into  `~/.config`

```bash
$ cd ~/.config && git clone https://github.com/bkesby/nvim.git
```

3. Setup some options before loading neovim. Use vim or another editor and open `lua/rc.lua`. Go down to line 121 and change path python paths
to point to your python installations. I would obviously recommend you create a virtualenv specifically for these but thats your provocative.
You can choose to remove the python2 path if you don't have a python2 install by removing path within the quotes.

```lua
python2_path = "",
python3_path = "/usr/bin/python"
```

4. Install pynvim into the python instance you pointed to above, along with venv

```bash
$ pip install pynvim
$ sudo apt install --yes -- python3-venv
```

5. Initialize neovim first time

```bash
$ nvim +PackerSync
```

(Let it do its thing here, it may throw some warnings just ignore until the last message is something about treesitter)

6. Back out and reload into nvim `:q` ;) Everything should be working.

7. To get autocomplete all working for each language you need to install the correct language server. Lucky for you I've done the hard work
so all you have to do is use `nvim-lsp-installer`. Within neovim enter the command `:LspInstallInfo` which will open a menu to select lsp servers
to install (Press i to install). For python you want pyright, and I recommend you also install sumneko_lua for configuring lua neovim files.

7a. Turns out you need node.js for pyright server to work. Not a big deal just install a version of node >> 15.0:
  
```bash
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt-get install -y nodejs
```


BONUS. To change to theme, and all settings for the most part (atleast to start with) open up `rc.lua` and go to line 14 and change quote
to "monokai"
