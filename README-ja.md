<div align="center">
    <img alt="NixOS" src="assets/nix-snowflake.svg" width="120px"/>
    <h1>❖ LudovicoのDotfiles ❖</h1>
    <p>
        <img src="https://img.shields.io/github/stars/ludovicopiero/dotfiles?style=for-the-badge&labelColor=1B2330&color=ef65ea" alt="GitHubリポジトリのスター数"/>
        <img src="https://img.shields.io/github/last-commit/ludovicopiero/dotfiles?style=for-the-badge&labelColor=1B2330&color=ef65ea" alt="GitHub最終コミット"/>
        <img src="https://img.shields.io/github/repo-size/ludovicopiero/dotfiles?style=for-the-badge&labelColor=1B2330&color=ef65ea" alt="GitHubリポジトリのサイズ"/>
        <a href="https://nixos.org" target="_blank">
            <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=1B2330&logo=NixOS&logoColor=white&color=ef65ea" alt="NixOS不安定版"/>
        </a>
    </p>
</div>

---

> [!WARNING]
> これは私の個人的なNixOS設定であり、進行中の作業です。
> このセットアップは、Nixの学習と自身のコンピュータ管理を目的としています。
> **この構成を使用したことによる損害について、私は一切責任を負いません。自己責任でご利用ください。**

---

## **✨ スクリーンショット**

<div align="center">
    <img src="assets/ss.png" alt="スクリーンショット" width="100%"/>
</div>

---

## **📚 リソース**

NixおよびNixOSについて詳しく学ぶには、以下をご覧ください:

- [NixOSマニュアル](https://nixos.org/manual/nixos/stable/)
- [Nixpkgsマニュアル](https://nixos.org/manual/nixpkgs/stable/)

---

## **📂 モジュールの構造**

この設定は、`modules/`ディレクトリにあるモジュラー構造に基づいています。`modules/default.nix`ファイルは、このディレクトリ内のすべての`.nix`ファイルを自動的にインポートするように設計されており、システムのさまざまな部分をクリーンでスケーラブルな方法で管理できます。

モジュールは次のように構成されています：

| パス         | 説明                                                                                 |
| ------------ | ------------------------------------------------------------------------------------ |
| `etc/`       | システム全体のコア設定。                                                             |
| `etc/fonts`  | 用途別のフォント設定（メイン、ターミナル、CJK、絵文字）を管理します。                |
| `etc/shared` | ユーザー、変数、セキュリティ、秘密（`sops`）、`hjem`のための共有モジュール。         |
| `etc/theme`  | GTKとQtのテーマ設定を行い、一貫したルックアンドフィールを保証します。                |
| `hyprland/`  | Hyprlandウィンドウマネージャに特化した設定。                                         |
| `programs/`  | シェル、エディタ、ブラウザなどのユーザーレベルのアプリケーションの設定を管理します。 |
| `services/`  | greetdやpipewireなどのシステムレベルのサービスを定義・設定します。                   |

各モジュールは自己完結型であり、その中で定義されたオプション（多くは `mine` 属性セット以下にあります）を通じて設定できます。

---
