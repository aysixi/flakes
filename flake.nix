{
  description = "Description for the project";

  outputs =
    inputs@{ self, ... }:
    let
      selfPkgs = import ./pkgs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [ "x86_64-linux" ];
      imports =
        [
          ./hosts
          ./home/profiles/home-manager.nix
          # To import a flake module
          # 1. Add foo to inputs
          # 2. Add foo as a parameter to the outputs function
          # 3. Add here: foo.flakeModule

        ]
        ++ [
          inputs.flake-root.flakeModule
          inputs.treefmt-nix.flakeModule
        ];
      flake = {
        overlays.default = selfPkgs.overlay;
      };
      # systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          # NOTE: These overlays apply to the Nix shell only. See `modules/nix.nix` for system overlays.
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              #inputs.foo.overlays.default
            ];
          };

          treefmt.config = {
            inherit (config.flake-root) projectRootFile;
            flakeCheck = true;
            settings = {
              global.excludes = [
                "*.png"
                "*.conf"
                "*.rasi"
                "*.fish"
                "justfile"
                "*.dae"
              ];
            };
            package = pkgs.treefmt;
            programs.nixfmt-rfc-style.enable = true;
            programs.prettier.enable = true;
            programs.taplo.enable = true;
            programs.shfmt.enable = true;
            programs.stylua = {
              enable = true;
              settings = {
                indent_type = "Spaces";
                indent_width = 2;
              };
            };
          };

          devShells = {
            # run by `nix devlop` or `nix-shell`(legacy)
            # Temporarily enable experimental features, run by`nix develop --extra-experimental-features nix-command --extra-experimental-features flakes`
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                git
                neovim
                sbctl
                just
              ];
              inputsFrom = [
                config.flake-root.devShell
              ];
            };
            # run by `nix develop .#<name>`
            # NOTE: Here are some of the steps I documented, see `https://github.com/Mic92/sops-nix` for more details
            # ```
            # mkdir -p ~/.config/sops/age
            # age-keygen -o ~/.config/sops/age/keys.txt
            # age-keygen -y ~/.config/sops/age/keys.txt
            # sudo mkdir -p /var/lib/sops-nix
            # sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/keys.txt
            # nvim $FLAKE_ROOT/.sops.yaml
            # mkdir $FLAKE_ROOT/secrets
            # sops $FLAKE_ROOT/secrets/secrets.yaml
            # ```
            secret = pkgs.mkShell {
              name = "secret";
              nativeBuildInputs = with pkgs; [
                sops
                age
                neovim
                ssh-to-age
              ];
              shellHook = ''
                export $EDITOR=nvim
                export PS1="\[\e[0;31m\](Secret)\$ \[\e[m\]"
              '';
              inputsFrom = [
                config.flake-root.devShell
              ];
            };
          };
          # used by the `nix fmt` command
          formatter = config.treefmt.build.wrapper;
        };
    };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    disko.url = "github:nix-community/disko";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-misskey.url = "github:NixOS/nixpkgs?rev=25607567b9bb5c02b2ab9ae79bf7cfb6d07e9a78";
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hycov = {
    #   url = "github:DreamMaoMao/hycov";
    #   inputs.hyprland.follows = "hyprland";
    # };
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprland-contrib.url = "github:hyprwm/contrib";

    # stylix.url = "github:danth/stylix";
    nixd.url = "github:nix-community/nixd";
    nvim-flake.url = "github:aysixi/nvim-flake";
    # nvim-flake.url = "/home/kotori/Documents/nvim-flake";
    # nvim-flake.url = "github:Ruixi-rebirth/nvim-flake";
    aysixi-sec = {
      url = "git+ssh://git@github.com/aysixi/secrets.git?ref=main&shallow=1";
      flake = false;
    };
    aysixi = {
      url = "github:aysixi/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixyDomains = {
      url = "github:oluceps/nixyDomains";
      flake = false;
    };
    nur.url = "github:nix-community/NUR";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    sops-nix.url = "github:Mic92/sops-nix";
    yazi.url = "github:sxyazi/yazi";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://gomibox.cachix.org"
      "https://cache.garnix.io" # dae
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "gomibox.cachix.org-1:M3V3Xzc+tMCxAMf4GzGkhGebm00Lk3vLEgU7f97JL/8="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
