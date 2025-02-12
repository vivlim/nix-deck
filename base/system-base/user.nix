
{ config, pkgs, options, ... }: {
  users.users.vivlim = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    uid = 1000;
    initialPassword = "secret";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSY5IGCDVT+F1A1FMB7KMwDK2kg8JGVA9gkO8FyfRWR vivlim@id_ed25519_admin"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC52YuRJt540vrVutwAaVHAeUYTUR/OnCYgMeDvW8By1ad5ViFdFto8hgdRTdfQvaAm56IGGug9vaKnPjjwW1eH8YP0PQVSFOdC4LmKRAAhulWfAe6v3MxCso0XjFkdwWl+1VDbHtzmt5mpyN3l5nkFwt6wkDlmGi07lt8y2m6vLqx1x8zPI4LpopyeYL8LeHFfmh9OVFEmUi4ecYg4H8FcegmNQaHtjNoD1e/ASpB9wXzPOp99zWkQZcpYOTyQWp362MyNSNvLLB4F3VTqfI9C1WKDpgHwasTL8ib1vRkgihWtOzuvfIz2A13Bs6u077nXGYSVMOTEqiPlZsDC6DiXz31Z6usA5H9GPNkVPngtnasXw5jC4TWj+RErm/xPPpbY8+mUk4Wh5DUAny0CXvH9q+cBI0+bvbOQ7mDKT27l5/xZUOLiI94X5R+ByX+Whv+yIi+4TAXu6v+sUi5fucpsZsFXPFI3KbyJJote9F4oRPTQZtVI+9E4UKdH9dPij6k= vivlim@Vivs-MBP"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDlqliGDspTN9UqUMx4U+6hSkCAAsGmXIZMt84SvaiFuGvJQk7qIhcby7O3fszXr4orP93gDPWhURgjTqpk5jYg0DOZQ2tQYgI7TuMvmXwQfbbVxm7Bz9vKenziDV/M542jR7b4L92jV8HobBy9E226IltMksgXiVYr6OFMYQe4E4tJafwxcjPopFImqMpfyoVU5iUoVaISEhMrc//YTk5yZsUFnasRls7NrumY06lg3H60wrlRmktRxImO05cT1Wtjgg7a4v1qIBZHUW7fSWhrFjtJi+wp8VYphI4KzikYAB2IstcSBFaPybLuDzlK74WkUoGAizB3JajbuIayLgBC8vpcSvYP8dhjc+CChvd2nWZReWcI7QA1ifB6T/75dP+EiNVdBkSrkPcinnvGx0XqmxLh52Um9vBZPPNtjq+Wn5EwTLgK9Za7WGsrt9jiXdzZHAUaAPSEOsvbg1Jwk7cG50b+OMviPHVY07I5002b3t/LjmxGxCIXolBOukXJ0e0= vivlim@vix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBimDyoIZVRhq0qcp0D2TF+PP+xPD22zRuvCSxOGKgIn vivlim@viv-pc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/qJ4Edae5Kmv3VNPYeX8fKsXuN40mGXnnTUDi8pYm7 vivlim@vivtab"
    ];
  };

  users.groups.vivlim = {
    members = ["vivlim"];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSY5IGCDVT+F1A1FMB7KMwDK2kg8JGVA9gkO8FyfRWR vivlim@id_ed25519_admin"
    ];
  };

}
