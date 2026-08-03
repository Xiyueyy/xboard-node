package main

import "testing"

func TestResolveDownloadURLUsesForkReleaseByDefault(t *testing.T) {
	t.Setenv("XBOARD_NODE_DOWNLOAD_BASE", "")
	got := resolveDownloadURL("xboard-node-linux-amd64", "latest")
	want := "https://github.com/Xiyueyy/xboard-node/releases/latest/download/xboard-node-linux-amd64"
	if got != want {
		t.Fatalf("resolveDownloadURL() = %q, want %q", got, want)
	}
}

func TestResolveDownloadURLSupportsExplicitMirror(t *testing.T) {
	t.Setenv("XBOARD_NODE_DOWNLOAD_BASE", "https://mirror.example/releases/")
	got := resolveDownloadURL("xbctl-linux-arm64", "v1.2.3")
	want := "https://mirror.example/releases/download/v1.2.3/xbctl-linux-arm64"
	if got != want {
		t.Fatalf("resolveDownloadURL() = %q, want %q", got, want)
	}
}
