class Soju < Formula
  desc "Unified game library and Windows launchers for Apple Silicon"
  homepage "https://github.com/BCD1210/soju"
  url "https://github.com/BCD1210/soju/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "8396bac6f47ef0327d4c58582ab937c233febdc6b6992a58715ff9b414dc9f2d"
  license "GPL-3.0-or-later"
  version "1.6.3"

  depends_on :macos
  depends_on arch: :arm64

  def install
    # tools/ and third_party/ hold the C sources the bottle scripts compile
    # (tray-restore helpers, the steamwebhelper wrapper).
    libexec.install "install.sh", "scripts", "docs", "patches", "tools", "third_party", "app", "resources", "VERSION", "LICENSE", "NOTICE"
    # An exec script, not a symlink: the wrapper locates the repo from its own
    # path, and through a bin/ symlink that resolved to the brew prefix.
    bin.write_exec_script libexec/"scripts/soju"
  end

  def caveats
    <<~EOS
      Rosetta 2 is required:  softwareupdate --install-rosetta
      Then run:               soju install
      Steam support:          soju steam-install   (see `soju help`)

      Native Mac app:         soju app
      Select launchers before downloading. Steam-only skips Apple GPTK.
      The Steam rendering build requires macOS 26+ and Wine 11.0.
      Battle.net, Epic and GOG require a separate Apple GPTK download.
    EOS
  end

  test do
    assert_match "1.6.3", shell_output("#{bin}/soju --version")
    assert_predicate libexec/"resources/steam-support.json", :exist?
    assert_predicate libexec/"app/Soju.swift", :exist?
    assert_predicate libexec/"app/Library.swift", :exist?
    assert_predicate libexec/"app/SteamLogin.swift", :exist?
    assert_predicate libexec/"resources/steam-library.js", :exist?
    assert_predicate libexec/"scripts/library_services.py", :exist?
    assert_predicate libexec/"scripts/gog-launch.py", :exist?
    assert_match '"games"', shell_output("#{bin}/soju library")
    assert_match "Usage", shell_output("#{bin}/soju help")
    # doctor exercises ROOT resolution: it must find the scripts, not the prefix.
    assert_match "soju doctor", shell_output("#{bin}/soju doctor || true")
    assert_predicate libexec/"tools/soju-epic-restore.c", :exist?
  end
end
