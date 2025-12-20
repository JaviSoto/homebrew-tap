class AppleNotesCli < Formula
  desc "A fast, scriptable CLI for Apple Notes (read/write + backups)"
  homepage "https://github.com/JaviSoto/apple-notes-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.0/apple-notes-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "06b2af61c8400df5451bb0be17e5bd23f119e0d7a4e38bfe845f93c7fe11f973"
    end

    on_intel do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.0/apple-notes-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "1617be34cb8ef230d8942f249edd3b0f6d5a4a7120f02bfce513b0a31dfbcaa1"
    end
  end

  def install
    bin.install "apple-notes"
  end

  test do
    assert_match "apple-notes", shell_output("#{bin}/apple-notes --version")
  end
end
