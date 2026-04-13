{
  description = "Docker/Colima Dev Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            docker
            colima
            docker-compose
            kubectl
            minikube
          ];

          shellHook = ''
            # Ensure Colima is running
            if ! colima status >/dev/null 2>&1; then
              echo "Starting Colima..."
              colima start
            fi

            # Set the Docker Host socket
            export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
          '';
        };
      });
}
