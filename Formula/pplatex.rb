class Pplatex < Formula
  desc "Pretty-printer for LaTeX log output"
  homepage "https://github.com/stefanhepp/pplatex"
  head "https://github.com/stefanhepp/pplatex.git"

  stable do
    url "https://github.com/stefanhepp/pplatex/archive/pplatex-1.0-rc2.tar.gz"
    sha256 "7bfab2b5a89f838e79408f57349d6eb5c561d4fc51d416c94fe17a219bac97e4"

    # typo in SConstruct; remove with next stable release
    patch do
      url "https://github.com/stefanhepp/pplatex/commit/e1f4abbd5f8242e5a4e2cc2667927d81d0326950.diff"
      sha256 "37453259f8f36845ddfc262d17f3e0d27f2079670d861c692dfc3531fb959764"
    end
  end

  depends_on "scons" => :build
  depends_on "pcre"
  depends_on :tex

  def install
    scons "PCREPATH=#{Formula["pcre"].opt_prefix}"
    bin.install "bin/pplatex", "bin/ppdflatex"
  end

  test do
    (testpath/"test.tex").write <<-'EOS'.undent
      \documentclass{article}
      \begin{document}
      Hello World!
      \end{document}
    EOS

    latex = which "latex"
    system bin/"pplatex", "--cmd", latex, "-q", "--", "test.tex"
    assert File.exist?("test.dvi")
  end
end
