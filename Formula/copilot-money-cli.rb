class CopilotMoneyCli < Formula
  desc "Unofficial CLI client for Copilot Money"
  homepage "https://github.com/JaviSoto/copilot-money-cli"
  license "MIT"

  # This formula is generated/updated automatically by the copilot-money-cli release workflow.
  # It will be filled with the latest version + sha256 per platform.

  on_macos do
    on_arm do
      url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.0.0/copilot-v0.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end

    on_intel do
      url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.0.0/copilot-v0.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.0.0/copilot-v0.0.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  end

  def install
    bin.install "copilot"
  end

  test do
    assert_match "copilot-money-cli", shell_output("#{bin}/copilot version")
  end
end
