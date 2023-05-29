# Ubuntu22.04のイメージ

# ベースイメージとして、NVIDIAのCUDAランタイムとUbuntu 22.04を使用しています。
# CUDAランタイムは、NVIDIAのGPUを使用するための必要なランタイム環境を提供します。
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# RUN=install
# パッケージマネージャであるapt-getを使用して、パッケージリストを更新します。
RUN apt-get update -y
# インストールされているパッケージを最新バージョンにアップグレードします。
RUN apt-get upgrade -y
# ディストリビューション全体のアップグレードを実行します。
RUN apt-get dist-upgrade -y
# 不要なパッケージを削除します。
RUN apt-get autoremove -y
# パッケージキャッシュから不要なパッケージファイルを削除します。
RUN apt-get autoclean -y

# gnupg2とcurlパッケージをインストールします。
# gnupg2は、デジタル署名やセキュアな通信に使用されるツールです。
# curlは、URLを使用してデータを転送するためのツールです。
RUN apt-get install -y gnupg2 curl
# software-properties-commonとtzdataパッケージをインストールします。
# software-properties-commonは、ソフトウェアのリポジトリを管理するためのツールです。
# tzdataは、タイムゾーンデータを提供します。
RUN apt-get install -y software-properties-common tzdata
# タイムゾーンを"Asia/Tokyo"に設定します。
ENV TZ=Asia/Tokyo
# deadsnakesのPPA（Personal Package Archive）をaptリポジトリに追加します。
# deadsnakes PPAには、複数のPythonバージョンが含まれています。
RUN add-apt-repository ppa:deadsnakes/ppa

# 環境変数LC_ALLをC.UTF-8に設定します。
ENV LC_ALL C.UTF-8
# 環境変数LANGをC.UTF-8に設定します。
ENV LANG C.UTF-8

# パッケージマネージャであるapt-getを使用して、パッケージリストを更新します。
RUN apt-get update -y
# Python 3.11をインストールします。
RUN apt-get install python3.11 -y
# Python 3.11の開発用パッケージをインストールします。
RUN apt-get install python3.11-dev -y
# Python 3.11のTkinterパッケージをインストールします。
RUN apt-get install python3.11-tk -y

# 既存のPythonパッケージ管理ツールであるpipを削除します。
RUN apt-get remove python-pip
# Python 3.11のdistutilsパッケージをインストールします。
RUN apt-get -y install python3.11-distutils
# curlコマンドを使用して、get-pip.pyスクリプトをダウンロードし、Python 3.11で実行します。
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11
# インストールされたpipのバージョンを表示します。
RUN python3.11 -m pip --version

RUN python3.11 -m pip install -U setuptools==65.5.0
RUN python3.11 -m pip install -U pip wheel stable-baselines3 python-dotenv torch-tb-profiler
RUN python3.11 -m pip install --pre torch --extra-index-url https://download.pytorch.org/whl/nightly/cu118
