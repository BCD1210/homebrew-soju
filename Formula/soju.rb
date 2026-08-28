class Soju < Formula
  desc "Free Battle.net, Diablo II: Resurrected and Steam on Apple Silicon"
  homepage "https://github.com/BCD1210/soju"
  url "https://github.com/BCD1210/soju/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2275b8e294e701e1fea3ef7a086d8edd457e736f906ca03299aec1e124dd8b4b"
  license "GPL-3.0-or-later"
  version "1.1.2"

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
