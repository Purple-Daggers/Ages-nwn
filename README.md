# Ages Persistent World
A persistent world inspired by Ricktastrophe's Ages campaign world supported by Neverwinter Nights.

# Build Requirements
You need to install [nasher](https://github.com/squattingmonk/nasher#installation-options), see the Installation Options section.
After this, you can build the module, haks, and tlk with these prompts:
```bash
$ git clone https://github.com/Purple-Daggers/Ages-nwn/
$ cd Ages-nwn
$ nasher pack haks
$ nasher install
```
There are external hak file requirements. Download the following like you would any Neverwinter Nights haks:

[CEP 3.1.4](https://neverwintervault.org/project/nwnee/hakpak/combined/cep-3-community-expansion-pack)

[Complete Rural/City](https://neverwintervault.org/project/nwn1/hakpak/combined/complete-ruralcity)

Following this, you can run the module on Neverwinter Nights whether through the Aurora Toolset or the client.

# Helpful notes for development
If you're contributing to the scripting, I recommend you install VSCode and get the [NWScript: EE Language Server](https://marketplace.visualstudio.com/items?itemName=PhilippeChab.nwscript-ee-language-server) extension.

You can find some useful notes for setting up your workspace at [this nwnlexicon guide](https://nwnlexicon.com/index.php?title=NWN:EE_Script_Editing_Tutorial). Your workspace should include the "Neverwinter Nights\modules\ages" folder. I would recommend skipping Highlighting Setup since the language server extension will take care of that. Also feel free to skip Intellisense Setup, it didn't work for me. Having a copy of "nwscript.nss" somewhere in your workspace will let you ctrl+click to quickly see definitions of useful base functions. You don't need anything from the Advanced additions section.

VSCode's default encoding is UTF-8 but the .nss files used in Neverwinter Nights are packed in the windows-1252 format. Saving in UTF-8 can break colored text and special characters, so make sure you set VSCode's encoding to Western (Windows 1252) under File->Preferences->Settings->Text Editor->Files->Encoding.

After making edits to scripts, you should commit to your branch and run `nasher install` for your scripts to compile and pack. After this their changes should appear in the module.

If you successfully built your module after `nasher install`  but your changes aren't present in the module, do not run `nasher unpack` to check. You could lose your changes. Try deleting all the cached files in the .nasher folder and installing again before unpacking.

When you open the Aurora Toolset and the ages module, it will likely ask if you should open the directory as a module. You should select "yes".

Branch protection is active on this repository. Any changes to master require a pull request. Submit changes on your own branch and then create a pull request for review.

# Workflow
### Updating your branch:
```bash
$ git pull origin master
$ nasher pack haks
$ nasher install
```

### Committing to the repository
```bash
$ nasher unpack
$ git add --all
$ git commit -am "Brief summary of your changes"
$ git push origin NAMEOFYOURBRANCH
```
