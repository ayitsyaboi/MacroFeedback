# 🐢 MacroFeedback (TurtleWoW Addon)

MacroFeedback is a lightweight addon for TurtleWoW that shows customizable floating text on your screen when you execute macros. This was initially developed for Hunter pet macros to have visual feedback of macros being run, especially useful in large mob packs when trying to make the pet stay within the pack to quickly switch targets and stay in the fight.

## 🔧 Features

- Floating combat-style feedback for macros
- Customizable font size, outline, and shadow
- Adjustable screen position 
- Configurable display duration 
- Live control panel with sliders and checkboxes

## 📦 Installation

1. Copy and paste the URL for this repository into the addons tab of the TurtleWoW launcher (this will automatically keep it up-to-date). Alternatively, extract the contents of this .zip into your interface/addons folder. This will need to be updated manually. 
3. Launch TurtleWoW and type `/mfb` to configure the addon.

## 🧙 Usage

Inside a macro, call:

```lua
/run MacroFeedback("Your Message Here", r, g, b)
```
To change the color of the text change r (red), g (green), and b (blue) respectively. Values of 0 to 1 are supported in .1 incriments.

If omitted the text color will default to green. 

## 📜 License
MIT – Do what you want. Just don’t sell it to a murloc without a receipt.