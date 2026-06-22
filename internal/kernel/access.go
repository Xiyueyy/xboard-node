package kernel

import "time"

// AccessTargetEvent is a compact, already-aggregated target access record
// emitted by kernels that can observe routed connections.
type AccessTargetEvent struct {
	UserID          int       `json:"user_id"`
	SourceIP        string    `json:"source_ip"`
	InboundTag      string    `json:"inbound_tag,omitempty"`
	Network         string    `json:"network,omitempty"`
	TargetHost      string    `json:"target_host"`
	TargetPort      int       `json:"target_port,omitempty"`
	OutboundTag     string    `json:"outbound_tag,omitempty"`
	ConnectionCount int       `json:"connection_count"`
	FirstSeenAt     time.Time `json:"first_seen_at"`
	LastSeenAt      time.Time `json:"last_seen_at"`
}

// AccessReporter is implemented by kernels that can flush recent per-user
// destination access records. The service sends these in the normal report
// payload so panel implementations can display 3x-ui-like target logs.
type AccessReporter interface {
	FlushAccessTargetEvents(limit int) []AccessTargetEvent
}
