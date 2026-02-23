# 変数定義
APP_NAME := pdf2imgpdf
SRC := main.go
INSTALL_DIR := /usr/local/bin

.PHONY: all build clean install build-linux build-mac build-mac-arm build-windows build-all deps-mac deps-ubuntu deps-windows

# デフォルトの挙動（引数なしで make を実行したとき）
all: build

# --------------------------------------------------
# 1. 依存ツールのインストール (ImageMagick & Ghostscript)
# --------------------------------------------------

# macOS向け (Homebrewを使用)
deps-mac:
	@echo "==> macOS: 依存ツールをインストール中..."
	brew install imagemagick ghostscript
	@echo "==> 完了！"

# Ubuntu / Debian向け (aptを使用)
deps-ubuntu:
	@echo "==> Ubuntu/Debian: 依存ツールをインストール中..."
	sudo apt-get update
	sudo apt-get install -y imagemagick ghostscript
	@echo "==> 完了！"

# Windows向け (wingetを使用)
deps-windows:
	@echo "==> Windows: 依存ツールをインストール中..."
	winget install ImageMagick.ImageMagick
	winget install ArtifexSoftware.GhostScript
	@echo "==> 完了！ (※環境パスを反映させるため、ターミナルを再起動してください)"

# --------------------------------------------------
# 2. ビルドとインストール
# --------------------------------------------------

# 現在の環境向けにビルド
build:
	@echo "==> ビルド中: $(APP_NAME)"
	go build -o $(APP_NAME) $(SRC)
	@echo "==> ビルド完了: $(APP_NAME)"

# ビルドしたバイナリをシステムのPATH（/usr/local/bin）にインストールする（※sudoが必要な場合があります）
install: build
	@echo "==> インストール中: $(INSTALL_DIR)/$(APP_NAME)"
	install -m 755 $(APP_NAME) $(INSTALL_DIR)/$(APP_NAME)
	@echo "==> インストール完了！"

# ビルド成果物の削除
clean:
	@echo "==> クリーンアップ中..."
	rm -f $(APP_NAME)
	rm -f $(APP_NAME)-*
	@echo "==> クリーンアップ完了"

# --------------------------------------------------
# 3. クロスコンパイル
# --------------------------------------------------

build-linux:
	@echo "==> Linux向けにビルド中..."
	GOOS=linux GOARCH=amd64 go build -o $(APP_NAME)-linux-amd64 $(SRC)

build-mac:
	@echo "==> macOS (Intel) 向けにビルド中..."
	GOOS=darwin GOARCH=amd64 go build -o $(APP_NAME)-darwin-amd64 $(SRC)

build-mac-arm:
	@echo "==> macOS (Apple Silicon) 向けにビルド中..."
	GOOS=darwin GOARCH=arm64 go build -o $(APP_NAME)-darwin-arm64 $(SRC)

build-windows:
	@echo "==> Windows向けにビルド中..."
	GOOS=windows GOARCH=amd64 go build -o $(APP_NAME)-windows-amd64.exe $(SRC)

# 全プラットフォーム向けに一括ビルド
build-all: build-linux build-mac build-mac-arm build-windows
	@echo "==> すべてのプラットフォーム向けのビルドが完了しました！"
