### 目录结构

```
├── home              # home manager 配置信息
│  ├── core.nix       # 核心的通用配置，由其他配置引入
│  ├── desktop.nix    # 桌面环境配置
│  ├── server.nix     # 服务器配置
├── modules           # 通用模块，不同机器可以根据的需要引入
│  ├── home           # home manager 通用模块
│  │  └── -
│  └── nixos          # nixos 通用模块
├── overlays          # 安装包的修改配置
│  └── -
├── pkgs
│  └── -
├── profiles          # 不同机器的配置文件
│  ├── appolo         # 主服务器配置
│  ├── gaea           # 主用机配置
│  └── luna           # 虚拟机配置
├── secrets
│  └── _public_keys_
├── flake.lock
├── flake.nix         # nix flake 入口
├── nixos-install.sh  # nixos 全新安装脚本
└── flake.lock
```

### 如何安装？

0. 准备一个 64 位的 nixos [minimal iso image](https://channels.nixos.org/nixos-22.11/latest-nixos-minimal-x86_64-linux.iso) 烧录好,然后进入 live 系统。
1. 分区

使用 fdisk 或 parted 工具进行分区。现在假设两个分区为:`/dev/sda1` `/dev/sda2`。

2. 格式化分区

```bash
  mkfs.fat -F 32 /dev/sda1  # boot / EFI 分区
  mkfs.ext4 /dev/sda2       # 系统分区
```

3. 挂载

```bash
  mount /dev/sda2 /mnt/nix
  mkdir -p /mnt/boot
  mount /dev/sda1 /mnt/boot
```

4. 生成一个基本的配置

```bash
  nixos-generate-config --root /mnt
```

5. 克隆仓库到本地

```bash
nix-shell -p git
git clone  https://github.com/synebula/.nix.git /mnt/.nix
cd /mnt/.nix/
nix develop --extra-experimental-features "nix-command flakes"
```

6. 将 /mnt/etc/nixos 中的 `hardware-configuration.nix` 拷贝到 `/mnt/.nix/profiles/<profile>/hardware-configuration.nix`， 其中`<profile>`指需要的 profile。

```bash
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/.nix/profiles/<profile>/hardware-configuration.nix
```
7. 用户名修改: 编辑 `/mnt/.nix/flake.nix` 修改 **username** 变量。

8. 使用 `mkpasswd {PASSWORD} -m sha-512` 命令生成的密码哈希串替换掉 `/mnt/.nix/modules/nixos/user-group.nix` 中的 `users.users.<name>.hashedPassword` 值替换掉。


9. 安装

```bash
nixos-install --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org" --no-root-passwd --flake .#<profile>

# 或者

./nixos-install <profile>
```

10. 重启

```bash
reboot
```

### 日常更新系统脚本

``` bash
./nixos-switch
```