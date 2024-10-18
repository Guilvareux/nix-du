{
	description = "Backend Flake";

	inputs = {
		utils.url = "github:numtide/flake-utils";
		unstablepkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixos-generators = {
			url = "github:nix-community/nixos-generators";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, utils, nixos-generators, ... }: {
		packages.x86_64-linux = {
			virtualbox = nixos-generators.nixosGenerate {
				system = "x86_64-linux";
				modules = [
					./backend.nix
				];
				format = "openstack";
			};
		};
	};
}
