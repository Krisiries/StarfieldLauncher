# Starfield Launcher
Simple PowerShell-based helper program to disallow starfield from using every CPU core.

As with all my scripts, this is provided AS-IS with no plans for future additions.


# First Time Setup
<ol>
  <li>Download the PowerShell or precompiled exe</li>
  <li>Optional - use PS2Exe to convert the script to an executable: https://github.com/MScholtes/PS2EXE</li>
  <li>Run the script or exe the initial settings file <b>as administrator</b></li>
  <li>If the script cannot find your starfield install, it will prompt you to move it to the install folder</li>
  <li>If you wish to change from the default settings, open the csv created in notepad and change "111" as covered below in the example. <b>1 means Starfield cannot access a core, 0 means Starfield can</b></li>
  <ol>
    <li>Example:</li>
    <li>Open task manager</li>
    <li>Go to the Performance tab</li>
    <li>Read the number of logical processors</li>
    <li>I disable around 1/4 of them, for example if you have 16 logical processors, I disable 4</li>
    <li>Type 1s and 0s where 1 disables a core, and 0 leaves it for starfield.</li>
    <li>In the following example, I disable the first 4 of the 16 available logical processors</li>
    <li>HIGH CORE NUMBER       LOW CORE NUMBER</li>
    <li>"Affinity","0000000000001111"
    <li>Any leading 0s can be dropped by default. Default settings will disable 3 cores</li>
  </ol>
</ol>

# Subsequent Launch
Run the script or program, and your programs will be started! Script will delay to show errors and confirmations.
You can redirect the Starfield shortcut to the exe, if you do, the settings will be <i>in your starfield install folder</i>

# FAQ
## This launcher does...:
<ul>
  <li>searches the registry and its own folder for starfield's executable</li>
  <li>reduces the number of logical cores starfield can use</li>
  <li>help fix system stuttering with starfield in certain scenarios</li>
  <li>allow customization for other games, no support will be provided</li>
</ul>
## This launcher does not...:
<ul>
  <li>change anything about starfield's own code</li>
  <li>fix starfield's priority issues on alt tab</li>
  <li>provide a magic fix for hardware below program spec</li>
</ul>