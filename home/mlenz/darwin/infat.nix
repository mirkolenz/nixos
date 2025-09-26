{ ... }:
{
  programs.infat = {
    enable = true;
    settings = {
      extensions = {
        bash = "Zed";
        bib = "Zed";
        cjs = "Zed";
        cls = "Zed";
        css = "Zed";
        env = "Zed";
        fish = "Zed";
        gz = "Keka";
        ini = "Zed";
        js = "Zed";
        json = "Zed";
        jsx = "Zed";
        lock = "Zed";
        log = "Zed";
        md = "Zed";
        mdx = "Zed";
        mjs = "Zed";
        nix = "Zed";
        pdf = "PDF Expert";
        py = "Zed";
        pyi = "Zed";
        sh = "Zed";
        sty = "Zed";
        tar = "Keka";
        tex = "Zed";
        tgz = "Keka";
        toml = "Zed";
        ts = "Zed";
        tsx = "Zed";
        txt = "Zed";
        typ = "Zed";
        xml = "Zed";
        xz = "Keka";
        yaml = "Zed";
        yml = "Zed";
        zip = "Keka";
        zsh = "Zed";
      };
      # /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump URLSchemeBinding
      # https://en.wikipedia.org/wiki/List_of_URI_schemes
      schemes = {
        ftp = "ForkLift";
        http = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app";
        mailto = "Mail";
        sftp = "ForkLift";
        ssh = "Ghostty";
        tel = "FaceTime";
      };
      # https://github.com/philocalyst/infat/blob/70db7979d8247b33d9c0f75f550e029089ffb6a2/infat-lib/src/uti.rs#L385
      types = {
        text = "Zed";
        image = "Preview";
        audio = "QuickTime Player";
        video = "QuickTime Player";
        movie = "QuickTime Player";
        archive = "Keka";
        sourcecode = "Zed";
        shell = "Zed";
        makefile = "Zed";
        executable = "Ghostty";
      };
    };
  };
}
