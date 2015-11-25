class Texwrapper < Formula
  desc "Run TeX and some tools like BibTeX or MakeIndex at once"
  homepage "http://obrecht.fr/texwrapper/"
  url "http://obrecht.fr/texwrapper/texwrapper.0.2.2.tar.gz"
  sha256 "408cf3678db657b0c0edf276d768dad562302451639f0ad6e705133db60dcb64"

  depends_on :tex

  def install
    system "make"
    bin.install "texwrapper"
    man1.install "texwrapper.1"
  end

  test do
    (testpath/"test.tex").write <<-EOTEX.undent
      \\documentstyle[11pt]{article}
      \\begin{document}
      \\title{Test of TeXwrapper}
      \\maketitle
      This is just a test.
      \\end{document}
    EOTEX
    system bin/"texwrapper", "-lcp", testpath/"test.tex"
    assert File.exist?(testpath/"test.ps")
  end
end
