class CopilotMoneyCli < Formula
  desc "Unofficial CLI client for Copilot Money"
  homepage "https://github.com/JaviSoto/copilot-money-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.1.1/copilot-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "3d085a81d010093b374deba771bff54031b823db30201c929eaa169237770dcf"
    end

    on_intel do
      url "https://github.com/JaviSoto/copilot-money-cli/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "6e6ab72324b488babffe0f99ff0ef4b52795b22fc18225c9ecc99c15468b885c"
    end
  end

  on_linux do
    url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.1.1/copilot-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "23069932b8f92dabb18c9ba93e5b89da278f54563e086fe4d5f3d29f1c1fb2aa"
  end

  depends_on "rust" => :build if Hardware::CPU.intel?

  def install
    if File.exist?("copilot")
      bin.install "copilot"
      libexec.install Dir["libexec/*"] if Dir.exist?("libexec")
    else
      system "cargo", "install", *std_cargo_args(path: ".", bin: "copilot")
    end
  end

  test do
    assert_match "copilot-money-cli", shell_output("#{bin}/copilot version")
  end
end
