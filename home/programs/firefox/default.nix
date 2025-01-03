{ pkgs, config, user, ... }:

{
  home = {
    sessionVariables = {
      BROWSER = "firefox";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
  programs.firefox = {
    enable = true;
    policies = {
      DisplayBookmarksToolbar = true;
      Preferences = {
        # "browser.toolbars.bookmarks.visibility" = "never";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "full-screen-api.warning.timeout" = 0;
        # "browser.tabs.insertAfterCurrent" = true;
        "browser.download.lastDir" = "/home/${user}/Downloads/";
        "ui.key.menuAccessKey" = false;
        "font.name-list.emoji" = "Noto Color Emoji";
      };
    };
    profiles.default = {
      settings = {
        # "browser.startup.homepage" = "file://${homepage}";
      };
      userChrome = ''
        #context-inspect-a11y,
         #context-inspect,
         #context-inspect + menuseparator,
         /* #inspect-separator, */
         #context-viewsource,
         #context-viewinfo,
         #context-sep-viewsource,
         #context-savelinktopocket,
         #context-pocket,
         #context-bookmarklink,
         #context-openlink,
         #context-take-screenshot,
         #context-openlinkprivate,
         #context-sendimage,
         #context-sendbackground,
         #context-sendlinktodevice,
         #context-sendlinktodevice + menuseparator,
         #context-copylink,
         #context-stripOnShareLink,
         #context-savelink,
         #context-sep-screenshots {
         display:none!important;
         }
      '';
      userContent = ''
          /* show nightly logo instead of default firefox logo in newtabpage */
          .search-wrapper .logo-and-wordmark .logo {
          background: url("${./logo.png}") no-repeat center !important;
          background-size: 82px !important;
          display: inline-block !important;
          height: 82px !important;
          width: 82px !important;
          }
        }
      '';
    };
  };

}
