class Wacrawl < Formula
  desc "Read-only WhatsApp Desktop archive CLI with corrected media captions"
  homepage "https://github.com/openclaw/wacrawl"
  url "https://github.com/openclaw/wacrawl/archive/05c5b472819d411beff6e3a941229cd9785acee2.tar.gz"
  version "0.4.3"
  sha256 "a4fa37dcc4803dbc737d01a6f1e971def986250bdf1f0d1cd97212c6e39c93ab"
  license "MIT"
  revision 1

  depends_on "go" => :build

  patch :DATA

  def install
    ENV["GOWORK"] = "off"
    system "go", "test", "-count=1", "./internal/whatsappdb"
    ldflags = "-s -w -X github.com/openclaw/wacrawl/internal/cli.version=0.4.3+codex.1"
    system "go", "build", *std_go_args(ldflags:), "./cmd/wacrawl"
  end

  test do
    assert_match "0.4.3+codex.1", shell_output("#{bin}/wacrawl --version")
  end
end

__END__
diff --git a/internal/whatsappdb/desktop_test.go b/internal/whatsappdb/desktop_test.go
index df74700..08ea866 100644
--- a/internal/whatsappdb/desktop_test.go
+++ b/internal/whatsappdb/desktop_test.go
@@ -856,6 +856,77 @@ insert into ZWAMEDIAITEM values (2, 4, 'Media/111@s.whatsapp.net/fallback.pdf',
 	}
 }
 
+func TestImportDesktopUsesMessageTypeForVCardNameFallback(t *testing.T) {
+	ctx := context.Background()
+	source := testutil.TempDir(t)
+	createFixtureDBs(t, source)
+
+	chatDB, err := sql.Open("sqlite", filepath.Join(source, chatDBName))
+	if err != nil {
+		t.Fatal(err)
+	}
+	mustExec(t, chatDB, `
+insert into ZWAMESSAGE values (5, 1, null, 2, 'image-vcard-name', 0, 700000004, null, 1, 0, '111@s.whatsapp.net', '', 'Bob');
+insert into ZWAMESSAGE values (6, 1, null, 3, 'video-vcard-name', 0, 700000005, null, 2, 0, '111@s.whatsapp.net', '', 'Bob');
+insert into ZWAMESSAGE values (7, 1, null, 4, 'image-caption', 0, 700000006, 'real image caption', 1, 0, '111@s.whatsapp.net', '', 'Bob');
+insert into ZWAMESSAGE values (8, 1, null, 5, 'document-title', 0, 700000007, null, 8, 0, '111@s.whatsapp.net', '', 'Bob');
+insert into ZWAMESSAGE values (9, 1, null, 6, 'contact-vcard-name', 0, 700000008, null, 5, 0, '111@s.whatsapp.net', '', 'Bob');
+insert into ZWAMEDIAITEM values (2, 5, '', '', null, 'aW1hZ2UtaW50ZXJuYWwtaWQ=', 0);
+insert into ZWAMEDIAITEM values (3, 6, '', '', null, 'dmlkZW8taW50ZXJuYWwtaWQ=', 0);
+insert into ZWAMEDIAITEM values (4, 7, '', '', null, 'Y2FwdGlvbi1ub3Rl', 0);
+insert into ZWAMEDIAITEM values (5, 8, '', '', '  Roadmap.pdf  ', null, 0);
+insert into ZWAMEDIAITEM values (6, 9, '', '', null, 'Taylor Example', 0);
+`)
+	if err := chatDB.Close(); err != nil {
+		t.Fatal(err)
+	}
+
+	archive, err := store.Open(ctx, filepath.Join(t.TempDir(), "wacrawl.db"))
+	if err != nil {
+		t.Fatal(err)
+	}
+	defer func() { _ = archive.Close() }()
+	if _, err := Import(ctx, archive, source); err != nil {
+		t.Fatal(err)
+	}
+
+	messages, err := archive.Messages(ctx, store.MessageFilter{ChatJID: "111@s.whatsapp.net", Limit: 20, Asc: true})
+	if err != nil {
+		t.Fatal(err)
+	}
+	want := map[string]struct {
+		messageType string
+		text        string
+		mediaTitle  string
+	}{
+		"image-vcard-name": {messageType: "image"},
+		"video-vcard-name": {messageType: "video"},
+		"image-caption":    {messageType: "image", text: "real image caption"},
+		"document-title":   {messageType: "document", text: "Roadmap.pdf", mediaTitle: "Roadmap.pdf"},
+		"contact-vcard-name": {
+			messageType: "contact", text: "Taylor Example", mediaTitle: "Taylor Example",
+		},
+	}
+	found := make(map[string]bool, len(want))
+	for _, message := range messages {
+		expected, ok := want[message.MessageID]
+		if !ok {
+			continue
+		}
+		found[message.MessageID] = true
+		if message.MessageType != expected.messageType || message.Text != expected.text || message.MediaTitle != expected.mediaTitle {
+			t.Errorf("%s fields = type %q, text %q, media title %q; want type %q, text %q, media title %q",
+				message.MessageID, message.MessageType, message.Text, message.MediaTitle,
+				expected.messageType, expected.text, expected.mediaTitle)
+		}
+	}
+	for messageID := range want {
+		if !found[messageID] {
+			t.Errorf("message %q was not imported", messageID)
+		}
+	}
+}
+
 func TestImportDesktopUsesProfilePushNames(t *testing.T) {
 	ctx := context.Background()
 	source := t.TempDir()
diff --git a/internal/whatsappdb/read.go b/internal/whatsappdb/read.go
index d8ec249..4d9e870 100644
--- a/internal/whatsappdb/read.go
+++ b/internal/whatsappdb/read.go
@@ -303,7 +303,11 @@ order by m.ZMESSAGEDATE asc, m.Z_PK asc`)
 		m.Starred = starred != 0
 		m.MessageType = messageType(m.RawType)
 		m.MediaType = mediaType(m.RawType)
-		m.MediaTitle = firstNonEmpty(mediaTitle, vcardName)
+		m.MediaTitle = strings.TrimSpace(mediaTitle)
+		if m.MessageType == "contact" {
+			// Media rows can carry non-caption identifiers in ZVCARDNAME.
+			m.MediaTitle = firstNonEmpty(m.MediaTitle, vcardName)
+		}
 		if mediaPath != "" {
 			m.MediaPath = resolveDesktopMediaPath(sourceRoot, mediaPath)
 			m.SourceMediaPathRejected = m.MediaPath == ""
