class Soju < Formula
  desc "Free Battle.net, Steam, Epic and GOG launchers on Apple Silicon"
  homepage "https://github.com/BCD1210/soju"
  url "https://github.com/BCD1210/soju/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "3c3e4112689f477f26567d4acc7f9cb17a9df7fd103491826410b8f16782d2cb"
  license "GPL-3.0-or-later"
  version "1.3.2"

  depends_on :macos
  depends_on arch: :arm64

  def install
    # tools/ and third_party/ hold the C sources the bottle scripts compile
    # (tray-restore helpers, the steamwebhelper wrapper).
    libexec.install "install.sh", "scripts", "docs", "patches", "tools", "third_party", "LICENSE", "NOTICE"
    # An exec script, not a symlink: the wrapper locates the repo from its own
    # path, and through a bin/ symlink that resolved to the brew prefix.
    bin.write_exec_script libexec/"scripts/soju"
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
    # doctor exercises ROOT resolution: it must find the scripts, not the prefix.
    assert_match "soju doctor", shell_output("#{bin}/soju doctor || true")
    assert_predicate libexec/"tools/soju-epic-restore.c", :exist?
  end
end
