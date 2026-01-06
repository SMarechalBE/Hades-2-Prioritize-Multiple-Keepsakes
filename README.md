# Random Starting Keepsake – Hades II Mod

A small quality-of-life mod for **Hades II** that improves how prioritized keepsakes work at the start of a run.

## Important!
The mod has not been fully tested yet and there may be some bugs. 
But don't worry, worst case scenario would be a game crash.

## Motivation

Hades II allows prioritizing a single keepsake so it is automatically equipped when a run starts.
In practice, this has a few drawbacks:
- You often forget to switch back after testing another keepsake
- It encourages always starting with the same one
- It doesn’t work well if you want to rotate between several god keepsakes

*This mod removes that friction by letting you set up multiple favorites once and letting the game handle the rest.*

## Behavior changes

Multiple keepsakes can be marked as **prioritized**

![Keepsake rack](https://github.com/SMarechalBE/Hades-2-Prioritize-Multiple-Keepsakes/raw/main/img/KeepsakeRack.png)

When a run starts:
- One prioritized keepsake is **chosen at random**
- The keepsake selected on the previous run is **excluded**, preventing repeats
- Prioritized keepsakes and the last selected one are **persisted between runs**

**No game save or progression data is ever modified !**

*The result is a "set up once and forget it" workflow: you naturally cycle through your favorite starting keepsakes without manual switching.*

## Setup
- This mod uses the mod loader [Hell2Modding](https://thunderstore.io/c/hades-ii/p/Hell2Modding/Hell2Modding/). 
- Go to the mod manager [r2modman](https://thunderstore.io/c/hades-ii/p/ebkr/r2modman/) page and follow the installation procedure.
- Launch the game & Enjoy

## Configuration
Once the game has been launched once, you can modify prioritized list through the game interface.
You can also directly modify the configuration from: 
- **r2modman** interface, look for the *Config editor* side tab,
- **Hell2Modding** in-game interface (default key is *insert*) then go to the **config** menu,
- the file itself located (on Windows) at `%AppData%/r2modmanPlus-local/HadesII/profiles/<YourProfile>/ReturnOfModding/config/SMarBe-Random_Starting_Keepsake.cfg`

## Compatibility
- This mod should be compatible with any mod that don't affect keepsake selection.
- Any mod adding new keepsakes will work with this one as well.

## Mod suggestions
Check out my others *QoL* mods, those are all cross-compatible and meant to be used together:
- [Improved Boon Info UI](https://thunderstore.io/c/hades-ii/p/SMarBe/Improved_Boon_Info_UI/): improves boon information by adding a smart filtering system based on your currently picked boons. 
- [Run Boon Overview](https://thunderstore.io/c/hades-ii/p/SMarBe/Run_Boon_Overview/): aggregates all your currently available boons into Melinoë's Codex page.

## Issues and Feedback

Feel free to reach out to me on the official Hades modding [Discord](https://discord.com/invite/KuMbyrN) and/or add an issue on the [repository](https://github.com/SMarechalBE/Hades-2-Prioritize-Multiple-Keepsakes) for any encountered bugs or suggested improvements.
