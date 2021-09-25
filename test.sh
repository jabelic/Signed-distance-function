#!/bin/sh

# mac(catalina~)
    # terminalからの実行でマルチスレッド処理を行うには
    # $ vi ~/.zshrc
    # export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu` を書き加える
    # $ source ~/.zshrc
    # terminalを新たに起動して
    # $ julia hogehuga.jl

# WSLでのこのPJの実行方法
  # docker-compose up -d
  # docker-compose exec lab bash
  # echo "export JULIA_NUM_THREADS=8" >> ~/.bashrc
  # make test

assert(){
    input1="$1"
    input2="$2"
    input3="$3"
    # julia sdistance.jl $input1 $input2 --thread `sysctl -n hw.logicalcpu`
    # julia sdistance.jl $input1 $input2
    julia main.jl $input1 $input2 -t auto
    actual="$?"

    if [ "$input2" = 1 ]; then
        echo "並列処理：分割数N=$input1 \n"
    else
        echo "直列処理：分割数N=$input1 \n"
    fi
}

assert 100 1
assert 100 2
# assert 1000 1
# assert 1000 2
# docker-compose down --rmi local --volumes --remove-orphans