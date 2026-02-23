# pdf2imgpdf

`pdf2imgpdf` は、指定したディレクトリ内にある複数ページのPDFファイルを一括で読み込み、全ページを縦に結合した「1枚の画像のPDF」に変換するコマンドラインツールです。Go言語で記述されています。

テキスト情報を含むPDFを、完全に画像化（ラスタライズ）して再保存したい場合に便利です。

## ✨ 特徴

- **一括処理**: ディレクトリを指定するだけで、中にある `.pdf` ファイルをすべて自動処理します。
- **縦長結合**: 複数ページに渡るPDFを、物理的に1枚の縦に長い画像として結合します。
- **高画質**: 300DPIの高解像度で画像をレンダリングします。
- **上書き防止**: 変換後のファイルは `元のファイル名_image.pdf` として保存され、二重処理を防ぐ機構が備わっています。

## ⚠️ 前提条件 (必須)

このツールは、内部で画像処理エンジンとして **ImageMagick** を呼び出しています。そのため、ツールを実行する環境に ImageMagick と Ghostscript がインストールされている必要があります。

本リポジトリの `Makefile` を使用することで、各OS向けの依存ツールを簡単にインストールできます。

### 依存ツールのインストール

お使いのOSに合わせて、以下のコマンドを実行してください。

**macOS** (Homebrewを使用)
```bash
make deps-mac
```

**Ubuntu / Debian** (aptを使用)

```bash
make deps-ubuntu
```
(注: Linux環境の場合、ImageMagickのセキュリティポリシー設定 /etc/ImageMagick-6/policy.xml でPDFの読み書き権限を変更する必要がある場合があります)

**Windows** (wingetを使用)

```bash
make deps-windows
```
(注: インストール後、パスを反映させるためにターミナル（コマンドプロンプトやPowerShell）を一度再起動してください)

🚀 インストール方法
ソースコードからビルドしてインストールするには、Go言語の環境（1.18以上推奨）が必要です。

```bash
git clone [https://github.com/yourusername/pdf2imgpdf.git](https://github.com/yourusername/pdf2imgpdf.git)
cd pdf2imgpdf

# ビルドしてシステムのPATH（/usr/local/bin）にインストールする場合
sudo make install

# 現在のディレクトリにビルド済みバイナリを作成するだけの場合
make build
```

## 💡 使い方
ターミナルでコマンドを実行し、引数に変換したいPDFが含まれるディレクトリのパスを渡します。

```bash
pdf2imgpdf /path/to/your/pdf_directory
```

実行例:

```bash
$ pdf2imgpdf ./documents
ディレクトリ './documents' 内のPDFを処理します...
--------------------------------------------------
変換中: report.pdf
✅ 完了: report_image.pdf
変換中: presentation.pdf
✅ 完了: presentation_image.pdf
--------------------------------------------------
すべての処理が完了しました！
```

## 🛠️ 開発者向けコマンド (Makefile)
- `make build-all`: Windows, macOS (Intel/Apple Silicon), Linux 向けのバイナリを一括でクロスコンパイルします。
- `make clean`: 生成されたバイナリファイル群を削除してディレクトリをきれいにします。
