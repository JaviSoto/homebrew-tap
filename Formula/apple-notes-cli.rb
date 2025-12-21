class AppleNotesCli < Formula
  desc "A fast, scriptable CLI for Apple Notes (read/write + backups)"
  homepage "https://github.com/JaviSoto/apple-notes-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.1/apple-notes-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "ad40cf455ac2a94777a58bfd3107a398bc537c6aa362631f8b521443539d853c"
    end

    on_intel do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.1/apple-notes-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "c47513af4b86f58b480708761ef45c051bcd34d2a947933bd5f8c829533b204c"
    end
  end

  def install
    bin.install "apple-notes"
  end

  test do
    assert_match "apple-notes", shell_output("#{bin}/apple-notes --version")
  end
end
