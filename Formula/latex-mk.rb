class LatexMk < Formula
  desc "System for simplifying the management of LaTeX documents"
  homepage "http://latex-mk.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/latex-mk/latex-mk/latex-mk-2.1/latex-mk-2.1.tar.gz"
  sha256 "6e9df1c60dafdadccc00c44dc966330fe300256dcb829cd1b04647d7b7956dde"

  depends_on :tex
  depends_on "ghostscript" => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-'EOS'.undent
      \documentclass{article}
      \begin{document}
      Hello World!
      \end{document}
    EOS

    system bin/"latex-mk", "test.tex"
    assert File.exist?("test.dvi")
  end
end
