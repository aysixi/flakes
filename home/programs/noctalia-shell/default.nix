{
  pkgs,
  inputs,
  mi,
  ...
}:
{
  # configure options
  programs.noctalia-shell = {
    enable = false;
    settings = {
      # configure noctalia here; defaults will
      # be deep merged with these attributes.
      colorSchemes.predefinedScheme = "Catppuccin";
      general = {
        avatarImage = "/home/${mi.userName}/Pictures/GxGb5-1aYAAJlaI-kitte2.png";
        radiusRatio = 0.2;
      };
      location = {
        name = "Tokyo";
        weatherEnabled = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
      };
    };
    # this may also be a string or a path to a JSON file,
    # but in this case must include *all* settings.
  };
}
