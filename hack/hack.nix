{ config, pkgs, lib, ... }:
{
	#system.stateVersion = "22.05";
	nix = {
		settings.experimental-features = [ "nix-command" "flakes" ];
		extraOptions = ''
			experimental-features = nix-command
		'';
	};

	nixpkgs.config.allowUnfree = true;
	time.timeZone = "Europe/London";
	networking.hostName = "nixguest";
	networking.networkmanager.enable = true;

	environment.variables.EDITOR = "nvim";
	users.users.nix = {
		isNormalUser = true;
		initialPassword = "password123";
		#shell = pkgs.fish;
		extraGroups = [ "wheel" ];
		openssh.authorizedKeys.keys = [
		];
	};

	environment.systemPackages = with pkgs; [
		vim
		curl
		unzip
		git
		openvswitch
		gcc
		iputils
		rustscan
		openvpn
	];

	#networking.firewall.allowedTCPPorts = [ 22 80 443 5000 ];

	services = {
		openssh = {
			enable = true;
			settings = {
				PasswordAuthentication = lib.mkForce true;
				PermitRootLogin = lib.mkForce "yes";
			};
		};
		xserver = {
			enable = true;
			desktopManager = {
				xterm.enable = false;
				xfce = {
					enable = true;
				};
			};
			displayManager.defaultSession = "xfce";
		};
	};
}
