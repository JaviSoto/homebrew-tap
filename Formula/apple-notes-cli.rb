class AppleNotesCli < Formula
  desc "A fast, scriptable CLI for Apple Notes (read/write + backups)"
  homepage "https://github.com/JaviSoto/apple-notes-cli"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.3/apple-notes-v0.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "43690e81cbb0e28fa2ea4e16079e337aceab4d22b129a6b20da4922e36bd275e"
    end

    on_intel do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.3/apple-notes-v0.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "74662d47289a52b18eba97a4f8656172da7dba657442d58f5415911f33dd97e0"
    end
  end

  def install
    bin.install "apple-notes"
  end

  test do
    assert_match "apple-notes", shell_output("#{bin}/apple-notes --version")
  end
end
