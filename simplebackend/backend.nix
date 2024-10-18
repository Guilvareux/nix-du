{ config, pkgs, ... }:
{
	imports = 
	[
		./hardware-configuration.nix
	];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	nix.extraOptions = ''
		experimental-features = nix-command
	'';
	
	boot.loader.grub.enable = true;
	boot.loader.grub.version = 2;
	boot.loader.grub.device = "/dev/sda";
	
	nixpkgs.config.allowUnfree = true;
	
	time.timeZone = "Europe/London";
	
	networking.hostName = "nixguest";
	networking.networkmanager.enable = true;
	
	users.defaultUserShell = pkgs.fish;
	environment.shells = [ pkgs.fish ];		
	environment.variables.EDITOR = "nvim";
	users.users.nix = {
		isNormalUser = true;
		initialPassword = "password123";
		shell = pkgs.fish;
		extraGroups = [ "wheel" ];
		openssh.authorizedKeys.keys = [
		];
	};

	environment.systemPackages = with pkgs; [
		vim
		curl
		unzip
		git
		fish
		openvswitch
		gcc
	];

	networking.firewall.allowedTCPPorts = [ 22 80 443 ];

	services.openssh = {
		enable = true;
		passwordAuthentication = true;
		permitRootLogin = "no";
	};

	services.nginx = {
		enable = true;
		virtualHosts."localhost" = {
			default = true;
			locations."/" = {
				root = "/var/www";
				index = "index.html index.htm";
			};
			listen = [ { addr = "*"; port = 80; ssl = false; } ];
		};
	};
}
