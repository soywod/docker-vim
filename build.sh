#!/bin/bash

PROCESS_START=$(date +%s)
IMAGE_NAME="soywod/nvim"

while [ $# -gt 0 ]; do
  param="$1"

  case $param in
    -i|--init-file)
    if [ ! -f "$2" ]; then
      echo "init.vim file not found: '$2'"
      exit 1
    fi

    INIT_FILE=$(realpath "$2")
    shift
    ;;

    -p|--plugins-file)
    if [ ! -f "$2" ]; then
      echo "plugins file not found: '$2'"
      exit 1
    fi

    PLUGINS_FILE=$(realpath "$2")
    shift
    ;;

    -n|--image-name)
    IMAGE_NAME="$2"
    shift
    ;;

    *)
    echo "command not found: '$1'"
    exit 1
    ;;
  esac
  shift
done

if [ -z "$INIT_FILE" ]; then
  if [ ! -f init.vim ]; then
    touch init.vim
  fi
else
  cp "$INIT_FILE" init.vim
fi

if [ -z "$PLUGINS_FILE" ]; then
  if [ ! -f plugins ]; then
    touch plugins
  fi
else
  cp "$PLUGINS_FILE" plugins
fi

docker build -t "$IMAGE_NAME" .

echo
echo "Done in $(($(date +%s) - ${PROCESS_START}))s"

