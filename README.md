# MENO GAG2 Load (key-locked)

Public encrypted scripts. Source stays private.

## Automatic delivery (team worker accounts)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-fleet.lua", true))("YOUR_KEY")
```

Run Fleet once in every Roblox account used for automatic delivery. It starts inventory, Pet support, batch gifts, queue agents, and anti-AFK. Do not start those components separately.

## Manual Control Center (owner/tester)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-ui.lua", true))("YOUR_KEY")
```

The UI provides manual sends, move-all, settings, and logs. It starts Anti-AFK automatically and does not start the automatic order worker. If one account needs both roles, start Fleet first and then the UI.

`gag2-ui-v4.lua` is an alias for the same current Control Center. Prefer the shorter `gag2-ui.lua` URL.

## Diagnostics only

`gag2-explore.lua` and `gag2-dump-mail.lua` are troubleshooting tools, not normal startup commands. All sender, inventory, Pet, batch-agent, and anti-AFK scripts are internal components loaded by Fleet or the UI.

Files are saved under executor workspace folder `MENO-GAG2/`.

Wrong key => decrypt/compile error.
