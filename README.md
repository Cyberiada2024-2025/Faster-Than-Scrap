# Faster-Than-Scrap

Please follow these naming convention in the project:

## Godot Naming Conventions

Summarized from Godot Docs.

For more detailed information, see: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html

### Naming Conventions


|     Type     |   Convention  |           Example           |
|:-------------|:--------------|:----------------------------|
| File names   | snake_case    | `yaml_parser.gd`            |
| Class names  | PascalCase    | `class_name YAMLParser`     |
| Node names   | PascalCase    | `Camera3D, Player`          |
| Functions    | snake_case    | `func load_level():`        |
| Variables    | snake_case    | `var particle_effect`       |
| Signals      | snake_case    | `signal door_opened` (always in past tense)        |
| Constants    | CONSTANT_CASE | `const MAX_SPEED = 200`     |
| Enum names   | PascalCase    | `enum Element`              |
| Enum members | CONSTANT_CASE | `{EARTH, WATER, AIR, FIRE}` |

*Prepend a single underscore (_) to virtual methods, functions the user must override, private functions, and private variables.

### Code Order

We suggest to organize GDScript code this way:

    01. @tool, @icon, @static_unload
    02. class_name
    03. extends
    04. ## doc comment

    05. signals
    06. enums
    07. constants
    08. static variables
    09. @export variables
    10. remaining regular variables
    11. @onready variables

    12. _static_init()
    13. remaining static methods
    14. overridden built-in virtual methods:
        1. _init()
        2. _enter_tree() 
        3. _ready()
        4. _process()
        5. _physics_process()
        6. remaining virtual methods
    15. overridden custom methods
    16. remaining methods
    17. subclasses

And put the class methods and variables in the following order depending on their access modifiers:
  
    1. public
    2. private



## Autoformatter

The [Format on Save](https://godotengine.org/asset-library/asset/2340) extension is enabled in this project. All modified `.gd` files will be automatically formatted.

This plugin requires Python and gdtoolkit to work correctly.

Setup:
1. Download Python from here: https://www.python.org/downloads/
2. After installing Python, run: `python -m pip install gdtoolkit==4.3.3`

> **Note:** It is recommended to download Python from the official website (link above).
> 
> If Python is installed from another source (such as Microsoft Store), the provided setup may not work correctly.
