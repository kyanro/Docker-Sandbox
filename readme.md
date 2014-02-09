# mac でのvm の立ち上げ
~/bin/boot2docker start

# コンテナの立ち上げ
	docker run -n -d -p 4567:4567 mySinatra
`-n` ネットワーク有効。デフォルトtrue だけど明示
`-p 4567:4567` dockerを動かしているVMとコンテナのポートをマッピング
`mySinatra` image名

# vm-mac間のポートフォワーディング追加 これは一度だけでOK
# vm 止まっている時
	VBoxManage modifyvm -boot2docker-vm natpf1 "node,tcp,,4567,,4567"
## いらなくなったら
	VBoxManage modifyvm -boot2docker-vm natpf1 delete node

# vm 動いている時
	VBoxManage controlvm boot2docker-vm natpf1 "node,tcp,,4567,,4567"
## いらなくなったら
	VBoxManage controlvm boot2docker-vm natpf1 delete node

# debugのために. docker のVMとコンテナ間ではポートフォワーディングが正常に動いているか確認。	
## docker のVMにログイン
	~/bin/boot2docker ssh

## curl で確認
	curl localhost:4567 -v