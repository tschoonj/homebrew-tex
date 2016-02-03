class Rubber < Formula
  desc "Automated building of LaTeX documents"
  homepage "https://launchpad.net/rubber/"
  url "https://launchpad.net/rubber/trunk/1.4/+download/rubber-1.4.tar.gz"
  sha256 "824af6142a0e52804de2f80d571c0aade1d0297a7d359a5f1874acbb53c0f0b4"

  head "lp:rubber", :using => :bzr

  depends_on :tex
  depends_on "texinfo"

  def install
    # Disable building of PDF docs
    system "python", "setup.py", "build", "--pdf=False",
                                 "install", "--prefix=#{prefix}",
                                            "--infodir=#{info}",
                                            "--mandir=#{man}"

    bin.env_script_all_files(
      libexec/"bin",
      :PYTHONPATH => lib/"python2.7/site-packages"
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rubber --version")
  end
end
