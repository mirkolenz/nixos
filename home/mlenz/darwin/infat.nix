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
        html = "Safari";
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
        mailto = "Mail";
        sftp = "ForkLift";
        ssh = "Ghostty";
        tel = "FaceTime";
      };
      # https://github.com/philocalyst/infat
      types = {
        plain-text = "Zed";
        text = "Zed";
        csv = "Zed";
        image = "Preview";
        raw-image = "Preview";
        audio = "QuickTime Player";
        video = "QuickTime Player";
        movie = "QuickTime Player";
        mp4-audio = "QuickTime Player";
        quicktime = "QuickTime Player";
        mp4-movie = "QuickTime Player";
        archive = "Keka";
        sourcecode = "Zed";
        c-source = "Zed";
        cpp-source = "Zed";
        objc-source = "Zed";
        shell = "Zed";
        makefile = "Zed";
        data = "Zed";
        directory = "/System/Library/CoreServices/Finder.app";
        folder = "/System/Library/CoreServices/Finder.app";
        symlink = "/System/Library/CoreServices/Finder.app";
        executable = "Ghostty";
        unix-executable = "Ghostty";
        app-bundle = "/System/Library/CoreServices/Finder.app";
      };
    };
  };
}
