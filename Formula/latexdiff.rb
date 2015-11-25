class Latexdiff < Formula
  desc "Mark up significant differences between LATEX files"
  homepage "http://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/archive/1.1.0.tar.gz"
  sha256 "e5fc439ac82fcce902134d207f751577abe4939a7ad7ed2df8f9989041701167"

  depends_on :tex

  def install
    bin.install "dist/latexdiff"
    bin.install "dist/latexdiff-vc"
    bin.install "dist/latexrevise"

    man1.install "dist/latexdiff.1"
    man1.install "dist/latexdiff-vc.1"
    man1.install "dist/latexrevise.1"
  end

  test do
    (testpath/"test1.tex").write <<-EOS.undent
      \\documentclass{article}
      \\begin{document}
      Hello, world.
      \\end{document}
    EOS

    (testpath/"test2.tex").write <<-EOS.undent
      \\documentclass{article}
      \\begin{document}
      Goodnight, moon.
      \\end{document}
    EOS

    expect = /^\\DIFdelbegin \s+
               \\DIFdel      \{ Hello,[ ]world \}
               \\DIFdelend   \s+
               \\DIFaddbegin \s+
               \\DIFadd      \{ Goodnight,[ ]moon \}
               \\DIFaddend   \s+
               \.$/x
    assert_match(expect, shell_output("latexdiff #{testpath}/test[12].tex"))
  end
end
