# MENO GAG2 Load (key-locked)

Public encrypted scripts. Source stays private.

## Run UI

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-ui.lua", true))("YOUR_KEY")
```

## Other

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-send.lua", true))("YOUR_KEY")
loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-explore.lua", true))("YOUR_KEY")
loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-dump-mail.lua", true))("YOUR_KEY")
```

Files are saved under executor workspace folder `MENO-GAG2/`.

Wrong key => decrypt/compile error.
