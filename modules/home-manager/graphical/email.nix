{ ... }: {
  # We don't manage passwords here as Gmail requires weird OAuth anyways.
  # and I use them for other internal purposes too
  accounts.email.accounts = {
    "matthiesbe@gmail.com" = {
      primary = true;
      address = "matthiesbe@gmail.com";
      realName = "Ben Matthies";
      flavor = "gmail.com";
      gpg = {
        key = "015E6B992731C5B8";
        encryptByDefault = true;
        signByDefault = true;
      };
      signature = {
        showSignature = "append";
        delimiter = "~*~-~*~-~*~-~*~";
        text = ''
          Ben Matthies
          -
          Sie können mir mit OpenPGP verschlüsselte Nachrichten schicken. Sie sollten
          Ihre Nachrichten verschlüsseln, wenn Sie Bedenken haben, dass Ihr oder mein 
          Mailanbieter (Google Mail) Ihre Nachricht mitliest.
          Hilfe für Ihr Mailprogramm: https://www.openpgp.org/software/
          Mein Public Key: https://keys.openpgp.org/search?q=matthiesbe@gmail.com
          Fingerprint: 55C7 85F0 91A0 9C19 B096 53A5 015E 6B99 2731 C5B8
          
          Damit ich Ihnen verschlüsselt antworten kann, müssen Sie Ihren eigenen (von
          Ihnen erzeugten) Public Key entweder mitschicken oder auf keys.openpgp.org 
          registrieren. '';
      };
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
      signature = {
        showSignature = "append";
        text = ''
          Ben Matthies
          Admin AG
          Max-Planck-Schule Kiel
          Winterbeker Weg 1, 24114 Kiel '';
      };
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
      signature = {
        showSignature = "append";
        text = ''
          Ben Matthies
          Student der Physik (1Ba)
          2. Fachsemester

          Wahlprüfungsausschuss
          StuPa der CAU Kiel '';
      };
      thunderbird.enable = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "intl.locale.requested" = "de";
        "extensions.ui.dictionary.hidden" = true; # Disable dictionary.
      };
    };
  };
}
