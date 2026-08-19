package main

import "testing"

func TestResolveDownloadURLUsesForkReleaseByDefault(t *testing.T) {
	t.Setenv("RUA_EDGE_DOWNLOAD_BASE", "")
	t.Setenv("XBOARD_NODE_DOWNLOAD_BASE", "")
	got := resolveDownloadURL("rua-edge-linux-amd64", "latest")
	want := "https://github.com/Xiyueyy/xboard-node/releases/latest/download/rua-edge-linux-amd64"
	if got != want {
		t.Fatalf("resolveDownloadURL() = %q, want %q", got, want)
	}
}

func TestResolveDownloadURLSupportsExplicitMirror(t *testing.T) {
	t.Setenv("RUA_EDGE_DOWNLOAD_BASE", "https://mirror.example/releases/")
	t.Setenv("XBOARD_NODE_DOWNLOAD_BASE", "")
	got := resolveDownloadURL("rua-edge-ctl-linux-arm64", "v1.2.3")
	want := "https://mirror.example/releases/download/v1.2.3/rua-edge-ctl-linux-arm64"
	if got != want {
		t.Fatalf("resolveDownloadURL() = %q, want %q", got, want)
	}
}
