{
	description = "Nixos Flake";

	inputs = {
		utils.url = "flake-utils";
		nixpkgs.url = "nixpkgs/nixpkgs-unstable";
		nixos-generators = {
			url = "github:nix-community/nixos-generators";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		vms.url = "git+ssh://git@github.com/Guilvareux/nix-vm?ref=main";
	};

	outputs = { self, nixpkgs, vms, utils, nixos-generators, ... }: 
	let 
		pkgs = import nixpkgs {
			system = "x86_64-linux";
			config = { allowUnfree = true; };
		};

		ozSBE = pkgs.stdenv.mkDerivation {
			name = "ozSBE";
			src = "${vms}/caddy";
			installPhase = ''
				mkdir -p $out
				cp -r $src/* $out
			'';
		};
		ozVLB = pkgs.stdenv.mkDerivation {
			name = "ozSBE";
			src = "${vms}/caddy";
			installPhase = ''
				mkdir -p $out
				cp -r $src/* $out
			'';
		};

	in {
		packages.x86_64-linux = {

			sbe-native = ozSBE;
			vlb-native = ozVLB;

			hack = nixos-generators.nixosGenerate {
				system = "x86_64-linux";
				modules = [
					./hack/hack.nix
				];
				format = "qcow";
			};
			
			sbe-vm = nixos-generators.nixosGenerate {
				system = "x86_64-linux";
				modules = [
					./caddy/base.nix
					./caddy/sBE.nix
				];
				format = "qcow";
			};

			vlb-vm = nixos-generators.nixosGenerate {
				system = "x86_64-linux";
				modules = [
					./caddy/base.nix
					./caddy/vLB.nix
				];
				format = "qcow";
			};

			sbe-oci = pkgs.dockerTools.buildLayeredImage {
				name = "sbe-oci";
				contents = with pkgs; [
					dockerTools.usrBinEnv
					dockerTools.binSh
					dockerTools.caCertificates
					dockerTools.fakeNss
					nginx
					ozSBE
				];
				config = {
					Cmd = [ "/bin/sh" "-c" "nginx -g 'daemon off;'"];
					ExposedPorts = {
						"8000/tcp" = {};
					};
				};
			};

			vlb-oci = pkgs.dockerTools.buildLayeredImage {
				name = "vlb-oci";
				contents = with pkgs; [
					dockerTools.usrBinEnv
					dockerTools.binSh
					dockerTools.caCertificates
					dockerTools.fakeNss
					nginx
					ozVLB
				];
				config = {
					Cmd = [ "/bin/sh" "-c" "nginx -g 'daemon off;'"];
					ExposedPorts = {
						"8000/tcp" = {};
					};
				};
			};
		};
	};
}
