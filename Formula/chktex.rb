class Chktex < Formula
  desc "LaTeX semantic checker"
  homepage "http://www.nongnu.org/chktex/"
  url "https://download.savannah.gnu.org/releases/chktex/chktex-1.7.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/chktex/chktex_1.7.4.orig.tar.gz"
  sha256 "77ed995eabe7088dacf53761933da23e6bf8be14d461f364bd06e090978bf6d2"

  head do
    url "svn://svn.sv.gnu.org/chktex/trunk/chktex"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on :tex

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-'EOS'.undent
      \documentclass{article}
      \begin{document}
      Hello World!
      \end{document}
    EOS
    system bin/"chktex", "test.tex"
  end
end
