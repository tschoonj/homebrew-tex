class Lilypond < Formula
  desc "Sheet music engraver"
  homepage "http://lilypond.org/"
  url "http://download.linuxaudio.org/lilypond/sources/v2.18/lilypond-2.18.2.tar.gz"
  sha256 "329d733765b0ba7be1878ae3f457dbbb875cc2840d2b75af4afc48c9454fba07"

  devel do
    url "http://download.linuxaudio.org/lilypond/sources/v2.19/lilypond-2.19.24.tar.gz"
    sha256 "964644c4f5ba7985da9d6289e7549cccde67305ced4610e4dc563097b93ea571"
  end

  head do
    url "http://git.savannah.gnu.org/r/lilypond.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  # LilyPond currently only builds with an older version of Guile (<1.9)
  resource "guile18" do
    url "https://ftpmirror.gnu.org/guile/guile-1.8.8.tar.gz"
    sha256 "c3471fed2e72e5b04ad133bbaaf16369e8360283679bcf19800bc1b381024050"
  end

  option "with-doc", "Build documentation in addition to binaries (may require several hours)."

  depends_on :tex
  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "pango"
  depends_on "ghostscript"
  depends_on "mftrace"
  depends_on "fontforge"
  depends_on "fondu"
  depends_on "texinfo"

  # Additional dependencies for guile1.8.
  depends_on "libtool" => :build
  depends_on "libffi"
  depends_on "libunistring"
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "readline"

  # Add dependency on keg-only Homebrew 'flex' because Apple bundles an older and incompatible
  # version of the library with 10.7 at least, seems slow keeping up with updates,
  # and the extra brew is tiny anyway.
  depends_on "flex" => :build

  if build.with? "doc"
    depends_on "netpbm"
    depends_on "imagemagick"
    depends_on "docbook"
    depends_on "dblatex" => [:python, "dbtexmf.dblatex"]
    depends_on :python if MacOS.version <= :snow_leopard
    depends_on "texi2html"
  end

  def install
    # The contents of the following block are taken from the guile18 formula
    # in homebrew/versions.
    resource("guile18").stage do
      system "./configure", "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
             "--with-lispdir=#{share}/emacs/site-lisp/lilypond"
      system "make", "install"

      # A really messed up workaround required on OS X --mkhl
      lib.cd { Dir["*.dylib"].each { |p| ln_sf p, File.basename(p, ".dylib")+".so" } }
      ENV.prepend_path "PATH", "#{bin}"
    end

    args = %W[
      --prefix=#{prefix}
      --enable-rpath
    ]
    args << "--disable-documentation" if build.without? "doc"

    if build.stable?
      args << "--with-ncsb-dir=#{Formula["ghostscript"].share}/ghostscript/fonts/"
    else
      args << "--with-fonts-dir=#{Formula["ghostscript"].share}/ghostscript/fonts/"
    end

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    # Separate steps to ensure that lilypond's custom fonts are created.
    system "make", "all"
    system "make", "install", "elispdir=#{share}/emacs/site-lisp/lilypond"

    if build.with? "doc"
      system "make", "doc"
      system "make", "install-doc"
    end
  end

  def caveats; <<-EOS.undent
    Lilypond may require a newer version of metapost. Assuming a standard install of
    MacTeX, you will need to use `tlmgr` update its installed packages:

    sudo tlmgr update --self && sudo tlmgr update --all
  EOS
  end

  test do
    (testpath/"test.ly").write <<-EOS.undent
      \\version "#{version}"
      \\header { title = "Do-Re-Mi" }
      { c' d' e' }
    EOS
    system "#{bin}/lilypond", "test.ly"
  end
end
