class CopilotMoneyCli < Formula
desc "Unofficial CLI client for Copilot Money"
homepage "https://github.com/JaviSoto/copilot-money-cli"
version "0.1.0"
license "MIT"

on_macos do
on_arm do
url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.1.0/copilot-v0.1.0-aarch64-apple-darwin.tar.gz"
sha256 "d2d9d200894bcd5ada406d89ea10305255993b8c11fbb22264f86fd435813c32"
end

on_intel do
url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.1.0/copilot-v0.1.0-x86_64-apple-darwin.tar.gz"
sha256 "b93e6d9e0a618e1459d94c9bc0db5a410e1726493cd84fe3122f912a2b006628"
end
end

on_linux do
url "https://github.com/JaviSoto/copilot-money-cli/releases/download/v0.1.0/copilot-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
sha256 "4f2a32aee8d2c55ff5a6e4a3d173ee75499c813c88ba05856f915fcd326f05fe"
end

def install
bin.install "copilot"
end

test do
assert_match "copilot-money-cli", shell_output("#{bin}/copilot version")
end
end
