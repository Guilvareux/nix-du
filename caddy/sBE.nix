{ config, pkgs, ... }:
{
	services.caddy = {
		enable = true;
		user = "nix";
		extraConfig = ''
			:80
			respond "Hello, world!"
		'';
		#extraConfig = ''
		#	:80
		#	root * /var/www
		#	file_server
		#'';

		globalConfig = ''
			debug
			auto_https off
		'';
	};
}
