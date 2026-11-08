# Contributing to SCP: Critical Failure Game

First thing, thank you for being interested in the game enough to even read the `CONTRIBUTING.md` file!
You're welcome whether you're just fixing bugs, adding ideas to `TO-DO.md`, providing assets like models, images, sounds, shaders, or code, documenting code, or even just fixing spelling mistakes.
Anyways, straight to the point.

## Rules / Guidelines

For people who want to contribute to the source code ( such as fixing bugs, adding new features, reworking stuff, etc. ):
1. **Clean Code:** Please maintain a clean codebase ( not a strict rule, but very welcome ). More info on the [official Godot docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
2. **Credits:** Remember to credit yourself in `credits/people.json` and `credits/credits.json`. ( If you don't have an icon, just use `"res://texture/icon/credits/no_icon.png"`. Also, please use the right category in `credits.json`. if one doesn't exist, you can make one. )

## How do I contribute?

Actually quite simple:

1. Fork the project (somewhere on the top right there should be a button).
2. Download your fork (for example using git: `git clone https://github.com/yourname/link_to_your_fork`).
3. If you're making big changes or adding new features, it's better to make a new branch (for example using git: `git branch feature-name` or `git checkout -b feature-name`).
4. open it in godot ( when choosing file, just click the project.godot) and modify it
5. Commit and push your changes.
6. Open a Pull Request in the original repo. ( target the master branch also they will be merged via Squash for keeping the commit history clean)

Thanks for reading this file ;)

if you're intrested in helping with coding but don't have idea on what to add / change, check the TODO.md or ISSUES tab on github
or if you don't know coding, you can suggest ideas on discord ( will be made soon )

If you need help with the structure of the project:
- `res://abstract_classes/{YOUR_CUSTOM_CLASS}` - Used for classes that are meant to be extended and not used directly (like `camera_effects`). It is also recommended to put all classes that extend from the abstract classes in this folder just for organization.
- `res://assets/` - Mainly used for misc stuff, assets you can reuse / place on the map like player, doors, keypads, keycards, liquids, props, etc.
- `res://components/` - Used for Composition-style class nodes that are meant to be used with something else.
- `res://credits/` - Credits stuff.
- `res://custom_classes/` - For custom classes.
- `res://custom_resources/` - For custom classes that extend the `Resource` class instead of `Node`.
- `res://dev_textures/` - Icons for scripts / classes / resources (generally icons for scripts in the editor).
- `res://fonts/{font-name}/` - For font files.
- `res://models/` - For models.
- `res://music/` - For music.
- `res://scenes/` - For scenes like dev place or menu.
- `res://scripts/` - For scripts that aren't custom classes.
- `res://script_templates/` - Mainly for abstract_classes (stores templates for them).
- `res://sfx/` - Sound effects like button press or UI.
- `res://shaders/` - For shaders.
- `res://textures/` - Contains textures, BUT **NOT** materials.
- `res://ui/` - Stores UI stuff.
- `res://TODO.md/` - todo list

If you're making a new folder, please document it here. Thanks!
