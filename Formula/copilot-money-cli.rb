class CopilotMoneyCli < Formula
  desc "Unofficial CLI client for Copilot Money"
  homepage "https://github.com/JaviSoto/copilot-money-cli"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.1.2/copilot-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "709142a7bfb2cfb01d0e188fa07cc67d20c6d0fcf5d524d411beb5cc4facf784"
    end

    on_intel do
      url "https://github.com/JaviSoto/copilot-money-cli/archive/refs/tags/v0.1.2.tar.gz"
      sha256 "a548c90bd2eab7907593a9e8f60a0984fc38ddd32dde7f0884727a0b41ccced3"
    end
  end

  on_linux do
    url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.1.2/copilot-v0.1.2-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "e39b03665981d33ff247a1a1b56f39c11b0074864d455a69fb20739de80a7b78"
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
