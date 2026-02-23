package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	// 引数の確認
	if len(os.Args) < 2 {
		fmt.Println("使用方法: pdf2imgpdf <ディレクトリパス>")
		os.Exit(1)
	}

	dirPath := os.Args[1]

	// ディレクトリの存在確認
	info, err := os.Stat(dirPath)
	if err != nil || !info.IsDir() {
		fmt.Printf("エラー: 有効なディレクトリパスを指定してください (%s)\n", dirPath)
		os.Exit(1)
	}

	// 出力ディレクトリの作成
	imgpdfDir := filepath.Join(dirPath, "imgpdf")
	if err := os.MkdirAll(imgpdfDir, 0755); err != nil {
		fmt.Printf("エラー: 出力ディレクトリの作成に失敗しました (%v)\n", err)
		os.Exit(1)
	}

	fmt.Printf("ディレクトリ '%s' 内のPDFを処理します...\n", dirPath)
	fmt.Printf("出力先: %s\n", imgpdfDir)
	fmt.Println("--------------------------------------------------")

	// ディレクトリ内を走査
	err = filepath.Walk(dirPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// ディレクトリ自体はスキップ
		if info.IsDir() {
			// imgpdfディレクトリはスキップ
			if path == imgpdfDir {
				return filepath.SkipDir
			}
			return nil
		}

		// 拡張子が .pdf 以外のファイルはスキップ
		ext := strings.ToLower(filepath.Ext(path))
		if ext != ".pdf" {
			return nil
		}

		// 既に変換済みのファイル（_image.pdf）は無限ループを防ぐためスキップ
		if strings.HasSuffix(strings.ToLower(path), "_image.pdf") {
			return nil
		}

		// 出力ファイル名の生成
		baseName := strings.TrimSuffix(info.Name(), filepath.Ext(info.Name()))
		outFileName := fmt.Sprintf("%s_image.pdf", baseName)
		outPath := filepath.Join(imgpdfDir, outFileName)

		fmt.Printf("変換中: %s\n", info.Name())

		// ImageMagickコマンドの実行
		// -density 300 : 300DPIで読み込み
		// -append : 複数ページを縦に結合 (横にする場合は +append)
		cmd := exec.Command("magick", "-density", "300", path, "-append", outPath)

		// エラー内容が分かるように標準エラー出力をコンソールに繋ぐ
		cmd.Stderr = os.Stderr

		if err := cmd.Run(); err != nil {
			fmt.Printf("❌ エラー: %s の変換に失敗しました (%v)\n", info.Name(), err)
		} else {
			fmt.Printf("✅ 完了: %s\n", outFileName)
		}

		return nil
	})

	if err != nil {
		fmt.Printf("\n処理中にエラーが発生しました: %v\n", err)
	} else {
		fmt.Println("--------------------------------------------------")
		fmt.Println("すべての処理が完了しました！")
	}
}
