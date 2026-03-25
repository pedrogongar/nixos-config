---
name: nix-language
description: >
  Sintaxis del lenguaje Nix, patrones de módulos, funciones builtin, string interpolation,
  attribute sets, imports, mkIf/mkMerge, derivaciones, let/in, with, rec.
  Trigger: Cuando se escriba o edite cualquier archivo .nix, se depure errores de
  evaluación Nix, o se necesite entender la sintaxis.
metadata:
  author: occulta
  version: "1.0"
---

# Lenguaje Nix — Referencia para configuración NixOS

Documentación oficial: https://nix.dev/manual/nix/latest/language/

## Tipos de datos

```nix
# Strings
"hello world"
''
  multi
  línea
''

# Integers / Floats
42
3.14

# Booleans
true
false

# Null
null

# Paths (sin comillas)
./relative/path
/absolute/path

# Lists (sin comas)
[ 1 2 3 "hello" true ]

# Attribute sets (con punto y coma)
{ name = "pedro"; age = 30; }

# Recursive attribute sets (pueden referenciarse entre sí)
rec { x = 1; y = x + 1; }
```

## let / in

Variables locales. Solo existen dentro del `in`:

```nix
let
  nombre = "pedro";
  saludo = "hola ${nombre}";
in
  saludo  # → "hola pedro"
```

## String interpolation

```nix
let
  pkg = "kitty";
in
  "ejecutar ${pkg}"  # → "ejecutar kitty"

# Con expresiones
"hay ${toString (1 + 2)} items"  # → "hay 3 items"

# En multiline (dentro de scripts de shell)
''
  echo "${nombre}"
  hyprctl dispatch workspace ${toString ws}
''

# Escapar $ en shell scripts dentro de Nix
''
  TMP=$(mktemp)          # $ de shell — Nix lo deja pasar
  echo "''${VARIABLE}"   # Escapar ${ para que Nix no interpole
''
```

## Funciones

```nix
# Función de un argumento
x: x + 1

# Función con pattern matching (destructuring)
{ name, age }: "me llamo ${name}"

# Con valor por defecto
{ name, age ? 25 }: "tengo ${toString age} años"

# Con argumentos extra (... = resto)
{ name, ... }: "hola ${name}"

# Llamada a función (sin paréntesis para un argumento)
(x: x + 1) 5  # → 6

# Llamada con attrset
({ name, ... }: name) { name = "pedro"; extra = true; }  # → "pedro"
```

## import

```nix
# Importar un archivo .nix (ejecuta y devuelve su valor)
import ./colores.nix        # Si colores.nix devuelve un attrset

# Importar con argumentos (si el archivo es una función)
import ./modulo.nix { inherit pkgs; }

# Patrón típico en config NixOS
let
  c = import ./colores.nix;
in
  c.oro  # Acceder a un color
```

## inherit

Atajo para `x = x`:

```nix
let
  name = "pedro";
  age = 30;
in {
  inherit name age;
  # Equivale a:
  # name = name;
  # age = age;
}

# inherit from — extraer de otro attrset
let
  config = { host = "nixos"; user = "occulta"; };
in {
  inherit (config) host user;
  # Equivale a:
  # host = config.host;
  # user = config.user;
}
```

## with

Trae un attrset al scope:

```nix
# Sin with
[ pkgs.git pkgs.vim pkgs.curl ]

# Con with
with pkgs; [ git vim curl ]

# CUIDADO: with no sobreescribe variables locales
let x = 1; in with { x = 2; }; x  # → 1 (el let gana)
```

## Módulos NixOS

### Estructura de un módulo

```nix
{ config, pkgs, lib, ... }:
{
  # Opciones que este módulo define
  options = { ... };

  # Configuración que este módulo aplica
  config = { ... };

  # Imports de otros módulos
  imports = [ ./otro-modulo.nix ];
}

# Forma simplificada (solo config, sin options)
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ git vim ];
}
```

### Módulo Home Manager típico

```nix
{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-portatil";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
```

## Funciones útiles de lib

```nix
# mkIf — config condicional
config = lib.mkIf config.services.nginx.enable {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
};

# mkMerge — combinar configs
config = lib.mkMerge [
  { environment.systemPackages = [ pkgs.git ]; }
  (lib.mkIf useDocker { virtualisation.docker.enable = true; })
];

# mkDefault — valor por defecto (sobreescribible)
services.openssh.enable = lib.mkDefault true;

# mkForce — forzar valor (no sobreescribible)
services.openssh.enable = lib.mkForce false;
```

## Builtins útiles

```nix
builtins.substring 1 6 "#ff0000"   # → "ff0000" (strip #)
builtins.toString 42                 # → "42"
builtins.concatStringsSep ", " ["a" "b" "c"]  # → "a, b, c"
builtins.map (x: x * 2) [1 2 3]    # → [2 4 6]
builtins.filter (x: x > 2) [1 2 3 4]  # → [3 4]
builtins.attrNames { a = 1; b = 2; }  # → ["a" "b"]
builtins.hasAttr "name" { name = "x"; }  # → true
builtins.readFile ./archivo.txt      # Lee archivo como string
```

## Overlays

```nix
# En flake.nix o configuration.nix
nixpkgs.overlays = [
  (final: prev: {
    mi-paquete = prev.mi-paquete.override {
      configuracion = true;
    };
  })
];
```

**Con useGlobalPkgs = true**: overlays van en la config de NixOS que crea Home Manager, NO en home.nix.

## Errores comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `infinite recursion` | Attrset se referencia a sí mismo | Usar `rec {}` o reestructurar |
| `attribute missing` | Falta argumento en función | Añadir `...` o el argumento |
| `is not a function` | Intentar llamar algo que no es función | Verificar el tipo del import |
| `syntax error, unexpected` | Falta `;` en attrset o string mal cerrado | Revisar puntos y coma |
| `undefined variable` | Variable no existe en scope | Verificar let/in, inherit, with |

## Debugging

```bash
# Evaluar una expresión
nix eval --expr 'builtins.substring 1 6 "#ff0000"'

# Evaluar un atributo del flake
nix eval .#nixosConfigurations.nixos-portatil.config.services.openssh.enable

# REPL interactivo
nix repl
:l <nixpkgs>
pkgs.kitty.meta.description

# Mostrar qué va a construir sin construir
nixos-rebuild build --flake /etc/nixos#nixos-portatil --dry-run
```
