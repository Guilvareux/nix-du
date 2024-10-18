{ config, pkgs, lib, ... }:
{

	nix = {

		};
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	nix.extraOptions = ''
		experimental-features = nix-command
	'';
	
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

	#users.defaultUserShell = pkgs.fish;
	#environment.shells = [ pkgs.fish ];		
	environment.systemPackages = with pkgs; [
		vim
		curl
		unzip
		git
		openvswitch
		gcc
		iputils
	];

	networking.firewall.allowedTCPPorts = [ 22 80 443 5000 ];

	services = {
		openssh = {
			enable = true;
			settings = {
				PasswordAuthentication = lib.mkForce true;
				PermitRootLogin = lib.mkForce "yes";
			};
		};

		prometheus.exporters.node = lib.mkDefault {
			enable = true;
			user = "nix";
			port = 5000;
			#enabledCollectors = [];
			#disabledCollectors = [];
		};
	};
}
