class Latexila < Formula
  desc "a LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/latexila/3.16/latexila-3.16.1.tar.xz"
  sha256 "ab2d769546e10c86670e86271024c023c0a87f1b72856955c1883416a9f333f0"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "vala" => :build
  depends_on "gtksourceview3"
  depends_on "gtkspell3"
  depends_on "libgee"
  depends_on "gobject-introspection"
  depends_on "gnome-icon-theme"
  depends_on "libxml2" => "with-python"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :tex => :recommended

  def install
    system "./configure", "--disable-schemas-compile",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/latexila", "--version"
  end
end
