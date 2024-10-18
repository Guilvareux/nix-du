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

	users.users.http = {
		isNormalUser = true;
		extraGroups = [ "http" ];
	};
	users.groups.http = {};
	
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

	systemd.tmpfiles.rules = [ "d /run/haproxy 0750 http http -" ];

	services.openssh = {
		enable = true;
		passwordAuthentication = false;
		permitRootLogin = "no";
	};

	virtualisation = {
		podman = {
			enable = true;
			dockerCompat = true;
		};
	};

	services.haproxy.enable = true;
	services.haproxy.user = "http";
	services.haproxy.group = "http";
	services.haproxy.config = ''
		global
			maxconn 4096
			user http
			group http
			daemon

		defaults
			log			global
			mode		http
			option		httplog
			option		dontlognull
			retries		3
			option		redispatch
			maxconn		2000
			timeout connect		5000
			timeout client		50000
			timeout server		50000
			log			127.0.0.1 local0
			log			127.0.0.1 local7 debug
			option httpchk
			stats enable
			stats realm Haproxy\ Statistics
			stats uri /hpstats

		frontend wodan_frontend
			mode http
			bind 0.0.0.0:80
			default_backend wodan_backend

		backend wodan_backend
			mode http
			balance leastconn
			server s1 10.0.2.15:80
	'';
}
