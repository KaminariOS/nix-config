{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nheko;

  iniFmt = pkgs.formats.ini { };

  configDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support"
    else
      config.xdg.configHome;

  attrsKeyToSnakeCase =
    let
      camelCaseToSnakeCase =
        replaceStrings upperChars (map (s: "_${s}") lowerChars);

      f = mapAttrs' (k: v: nameValuePair (camelCaseToSnakeCase k) v);
    in
    mapAttrs' (k: v: nameValuePair k (f v));
in
{
  meta.maintainers = [ hm.maintainers.gvolpe ];

  options.programs.nheko = {
    enable = mkEnableOption "Qt desktop client for Matrix";

    package = mkOption {
      type = types.package;
      default = pkgs.nheko;
      example = literalExpression "pkgs.nheko";
      description = "The nheko package to use";
    };

    config = mkOption {
      type = iniFmt.type;
      default = { };
      example = literalExpression ''
        {
          general.disableCertificateValidation = false;
          auth = {
            accessToken = "SECRET";
            deviceId = "MY_DEVICE";
            homeServer = "https://matrix-client.matrix.org:443";
            userId = "@@user:matrix.org";
          };
          settings.scaleFactor = 1.0;
          sidebar.width = 416;
          user = {
            alertOnNotification = true;
            animateImagesOnHover = false;
            "sidebar\\roomListWidth" = 308;
          };
        }
      '';
      description = "Attribute set of Nheko preferences (converted to INI file).";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file."${configDir}/nheko/nheko.conf" = mkIf (cfg.config != { }) {
      text = ''
        ; Generated by Home Manager.

        ${generators.toINI { } (attrsKeyToSnakeCase cfg.config)}
      '';
    };
  };
}

