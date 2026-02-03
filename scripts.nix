{...}: {
  perSystem = {pkgs, ...}: let
    scripts = {
      dev-hello = pkgs.writeShellApplication {
        name = "dev-hello";
        runtimeInputs = [];
        text = ''
          echo "dev scripts are working"
        '';
      };

      dev-pr-worktree = pkgs.writeShellApplication {
        name = "dev-pr-worktree";
        runtimeInputs = with pkgs; [git direnv];
        text = builtins.readFile ./scripts/pr-worktree.sh;
      };

      dev-branch-worktree = pkgs.writeShellApplication {
        name = "dev-branch-worktree";
        runtimeInputs = with pkgs; [git direnv];
        text = builtins.readFile ./scripts/branch-worktree.sh;
      };
    };
  in {
    packages = scripts;
  };
}
