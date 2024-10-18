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
	nixpkgs.config.allowUnfree = true;

	boot.loader.grub.enable = true;
	boot.loader.grub.version = 2;
	boot.loader.grub.device = "/dev/sda";

	time.timeZone = "Europe/London";
	networking.hostName = "nixguest";
	networking.networkmanager.enable = true;
	
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
		git
	];

	services.openssh = {
		enable = true;
		passwordAuthentication = false;
		permitRootLogin = "no";
	};
}
