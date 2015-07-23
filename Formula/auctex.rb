class Auctex < Formula
  desc "Emacs package for writing and formatting TeX"
  homepage "https://www.gnu.org/software/auctex/"
  url "http://ftpmirror.gnu.org/auctex/auctex-11.88.tar.gz"
  mirror "https://ftp.gnu.org/gnu/auctex/auctex-11.88.tar.gz"
  sha256 "716867d5fbcc5c67cca781d7c1984e6a3a6d5da056ec3b4f35170805bf4dc83f"

  head do
    url "http://git.savannah.gnu.org/cgit/auctex.git"
    depends_on "autoconf" => :build
  end

  depends_on :tex
  depends_on :emacs => "21.1"

  def install
    # configure fails if the texmf dir is not there yet
    (share/"texmf").mkpath

    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-texmf-dir=#{share}/texmf",
                          "--with-emacs=#{which "emacs"}",
                          "--with-lispdir=#{share}/emacs/site-lisp"

    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
    texmf files have been installed into:
      #{HOMEBREW_PREFIX}/share/texmf

    You can add it to your TEXMFHOME using:
      sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"

    Emacs Lisp files have been installed into:
      #{HOMEBREW_PREFIX}/share/emacs/site-lisp
    EOS
  end

  test do
    (testpath/".emacs").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (require 'tex-site)
    EOS
    (testpath/"test.tex").write <<-'EOS'.undent
      \documentclass{article}
      \begin{document}
      This file is incomplete.
    EOS
    system "emacs", "-l", testpath/".emacs", "--batch", "test.tex",
      "--eval=(goto-char (point-max))", "--eval=(LaTeX-close-environment)",
      "-f", "save-buffer"
    assert_equal '\end{document}', File.read("test.tex").lines.last.chomp
  end
end
