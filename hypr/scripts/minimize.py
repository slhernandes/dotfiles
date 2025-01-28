#!/usr/bin/env python3
import os
import sys
import subprocess
import argparse
import json
import re


def get_cur_window_prop():
    output = subprocess.run(
            ["hyprctl", "activewindow", "-j"],
            shell=False,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
            )
    return json.loads(output.stdout)


def get_cur_workspace_prop():
    output = subprocess.run(
            ["hyprctl", "activeworkspace", "-j"],
            shell=False,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
            )
    return json.loads(output.stdout)


def move_window_to_special(pid):
    _ = subprocess.run(
            ["hyprctl", "dispatch",
             "movetoworkspacesilent", f"special:script_{pid}"],
            shell=False,
            encoding="utf-8",
            )


def initiate_argparse():
    parser = argparse.ArgumentParser(description="Optional app description")
    subparsers = parser.add_subparsers(help="subcommand help", dest="command")

    _ = subparsers.add_parser("minimize",
                              help="move current window to special workspace")

    parser_restore = subparsers.add_parser("restore",
                                            help="move selected window back to workspace")
    parser_restore.add_argument("pid", type=int, help="pid of window")

    _ = subparsers.add_parser("restorerofi",
                              help="use rofi to interactively restore window")

    return parser


def minimize():
    prop = get_cur_window_prop()
    pid = prop['pid']
    if pid is not None:
        move_window_to_special(pid)
    else:
        print("PID not found!", file=sys.stderr)


def restore(pid):
    prop = get_cur_workspace_prop()
    w_id = prop['id']
    print(w_id)
    _ = subprocess.run(
            ["hyprctl", "dispatch", "togglespecialworkspace", f"script_{pid}"],
            shell=False,
            encoding="utf-8",
            )
    _ = subprocess.run(
            ["hyprctl", "dispatch", "movetoworkspace", str(w_id)],
            shell=False,
            encoding="utf-8",
            )


def restorerofi():
    icons_dir = (os.getenv("XDG_CONFIG_HOME") + "/hypr/icons") or (os.getenv("HOME") + ".config/hypr/icons")
    minimized_wins = json.loads(subprocess.run(
            ["hyprctl", "clients", "-j"],
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            ).stdout)
    if len(minimized_wins) == 0:
        _ = subprocess.run(
                f"dunstify -r 818 -u low -i {icons_dir}/dialog-warning.svg \
                        \"Minimizer\" \"No minimized window\"\
                        -h string:x-canonical-private-synchronous:test",
                shell=True,
                encoding="utf-8",
                )
        exit(0)

    title_pid_map = {}
    titles = []
    pattern = r"special:script_\d+"
    for win in minimized_wins:
        if re.match(pattern, win['workspace']['name']) is None:
            continue
        pid = win['pid']
        title = f"{win['class']}: \"{win['title'][:14]}…\", (pid: {pid})"
        titles.append(title)
        title_pid_map[title] = pid
    output = subprocess.run(
            f"echo \'{"\n".join(titles)}\' | rofi -dmenu -no-custom -p restore:",
            shell=True,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            )
    pid = title_pid_map[output.stdout.strip()]
    if pid is not None:
        restore(pid)
    else:
        _ = subprocess.run(
                f"dunstify -r 818 -u low -i {icons_dir}/dialog-error.svg \
                        \"Minimizer\" \"Window not found\"\
                        -h string:x-canonical-private-synchronous:test",
                shell=True,
                encoding="utf-8",
                )
        exit(1)


if __name__ == "__main__":
    parser = initiate_argparse()
    args = parser.parse_args()
    match args.command:
        case "minimize":
            minimize()
        case "restore":
            restore(args.pid)
        case "restorerofi":
            restorerofi()
