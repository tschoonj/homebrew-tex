class Latexdiff < Formula
  desc "Mark up significant differences between LATEX files"
  homepage "http://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.2.0/latexdiff-1.2.0.tar.gz"
  sha256 "b139b7a289236b4daf1e94258253869be87b6c13a0dfecddf5259140f16c96cd"

  depends_on :tex

  def install
    bin.install %w[latexdiff latexdiff-fast latexdiff-so latexdiff-vc
                   latexrevise]
    man1.install %w[latexdiff-vc.1 latexdiff.1 latexrevise.1]
    doc.install Dir["doc/*"]
    pkgshare.install %w[contrib example]
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
    assert_match expect, shell_output("#{bin}/latexdiff test[12].tex")
  end
end
