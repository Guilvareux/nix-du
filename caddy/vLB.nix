{ config, pkgs, ... }:
{
	services.caddy = {
		enable = true;
		extraConfig = ''
		:80 {
			reverse_proxy / wodan-test-SBE_0-wodanSBE-0 wodan-test-SBE_1-wodanSBE-0 {
				lb_policy least_conn
				health_path /ok
				health_interval 10s
			}
		}
		'';
	};
}
