class Soju < Formula
  desc "Free Battle.net, Diablo II: Resurrected and Steam on Apple Silicon"
  homepage "https://github.com/BCD1210/soju"
  url "https://github.com/BCD1210/soju/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e6a5d8b1eb738f72bfc111566c55a9ce8ecf95ad9e86c4d1d69235bb26a1d264"
  license "GPL-3.0-or-later"
  version "1.2.0"

  depends_on :macos
  depends_on arch: :arm64

  def install
    libexec.install "install.sh", "scripts", "docs", "patches", "LICENSE", "NOTICE"
    bin.install_symlink libexec/"scripts/soju"
  end

  def caveats
    <<~EOS
      Rosetta 2 is required:  softwareupdate --install-rosetta
      Then run:               soju install
      Steam support:          soju steam-install   (see `soju help`)

      The installer will walk you through downloading Apple's free
      Game Porting Toolkit (Apple forbids redistributing it).
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/soju help")
  end
end
