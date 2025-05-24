{ pkgs, ... }: {
  # We don't manage passwords here as Gmail requires weird OAuth anyways.
  # and I use them for other internal purposes too
  accounts.email.accounts = {
    "matthiesbe@gmail.com" = {
      primary = true;
      address = "matthiesbe@gmail.com";
      realName = "Ben Matthies";
      flavor = "gmail.com";
      # TODO: Configure GPG.
      # TODO: Configure signature.
      thunderbird = {
        enable = true;
        settings = id: {
          # More sane archive location than Gmail "All messages"
          "mail.identity.id_${id}.archive_folder" = "imap://matthiesbe%40gmail.com@imap.gmail.com/Archiv";
        };
      };
    };

    "ben.matthies@mps-ki.de" = {
      address = "ben.matthies@mps-ki.de";
      realName = "Ben Matthies";
      userName = "ben.matthies";
      smtp = {
        host = "mps-ki.de";
        port = 465;
      };
      imap = {
        host = "mps-ki.de";
        port = 993;
      };
      # TODO: Configure signature.
      thunderbird.enable = true;
    };

    "ben.matthies@stu.uni-kiel.de" = {
      address = "ben.matthies@stu.uni-kiel.de";
      realName = "Ben Matthies";
      userName = "stu249890";
      smtp = {
        host = "smtps.mail.uni-kiel.de";
        port = 465;
      };
      imap = {
        host = "imap.mail.uni-kiel.de";
        port = 993;
      };
      # TODO: Configure signature.
      thunderbird.enable = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-bin;
    # TODO: Install extensions, dictionary
    profiles.default = {
      isDefault = true;
    };
  };
}
