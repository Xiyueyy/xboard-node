# RUA Edge

RUA Edge 是 Ruaboard 的边缘网络运行时。它在边缘服务器上同步配置、运行网络内核并回传健康与用量信息；对外进程、服务、CLI、日志和安装目录统一使用中性的 RUA Edge 品牌。

## 运行标识

- 主程序：`rua-edge`
- 控制工具：`rua-edge-ctl`
- systemd：`rua-edge.service`
- 配置目录：`/etc/rua-edge`
- User-Agent：`RUA-Edge`

## 安装

推荐从 Ruaboard 管理端的节点详情生成一次性安装命令。通用示例：

```bash
curl -fsSL https://panel.example.com/api/public/rua-edge/install-script | \
  bash -s -- --mode machine --panel https://panel.example.com \
  --token TOKEN --machine-id 1 --kernel singbox --health-port 0 --yes
```

旧版 `/etc/xboard-node`、`xboard-node.service` 和 `xbctl` 安装会在执行新版安装器时自动迁移；面板协议仍保持兼容，不需要重建节点或入站。

## 常用命令

```bash
rua-edge-ctl status
rua-edge-ctl list
rua-edge-ctl service logs
rua-edge-ctl service restart
rua-edge-ctl upgrade
```

## 构建

```bash
make test
make build-all
```

Release 产物：

- `rua-edge-linux-amd64`
- `rua-edge-linux-arm64`
- `rua-edge-ctl-linux-amd64`
- `rua-edge-ctl-linux-arm64`
