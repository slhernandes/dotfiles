#!/usr/bin/env python3
import os
import subprocess
import argparse
import json


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


def move_window_to_special():
    _ = subprocess.run(
            ["hyprctl", "dispatch",
             "movetoworkspacesilent", "special:minimized"],
            shell=False,
            encoding="utf-8",
            )


def initiate_argparse():
    parser = argparse.ArgumentParser(
            description="A script to minimize and restore hyprland window")
    subparsers = parser.add_subparsers(help="Subcommand help", dest="command")

    _ = subparsers.add_parser("minimize",
                              help="Move current window to special workspace")

    parser_restore = subparsers\
        .add_parser("restore",
                    help="Move selected window back to workspace")
    parser_restore.add_argument("address",
                                type=str, help="address of window (0x…)")

    _ = subparsers.add_parser("restorerofi",
                              help="Use rofi to interactively restore window")

    _ = subparsers.add_parser("info",
                              help="Output information (primarily for waybar)")

    return parser


def minimize():
    icons_dir = (os.getenv("XDG_CONFIG_HOME") + "/hypr/icons")\
            or (os.getenv("HOME") + ".config/hypr/icons")
    prop = get_cur_window_prop()
    if len(prop) != 0:
        move_window_to_special()
    else:
        _ = subprocess.run(
                f"dunstify -r 818 -u low -i {icons_dir}/dialog-warning.svg \
                        \"Minimizer\" \"No active window detected\"\
                        -h string:x-canonical-private-synchronous:test",
                shell=True,
                encoding="utf-8",
                )


def restore(address):
    prop = get_cur_workspace_prop()
    _ = subprocess.run(
            ["hyprctl", "dispatch", "movetoworkspace",
             f"{prop['id']},address:{address}"],
            shell=False,
            encoding="utf-8",
            )


def restorerofi():
    icons_dir = (os.getenv("XDG_CONFIG_HOME") + "/hypr/icons")\
            or (os.getenv("HOME") + ".config/hypr/icons")
    minimized_wins = json.loads(subprocess.run(
            ["hyprctl", "clients", "-j"],
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            ).stdout)

    title_pid_map = {}
    titles = []
    for win in minimized_wins:
        if win['workspace']['name'] != "special:minimized":
            continue
        address = win['address']
        title =\
            f"{win['class']}: \"{win['title'][:14]}…\", (address: {address})"
        titles.append(title)
        title_pid_map[title] = address
    if len(titles) == 0:
        _ = subprocess.run(
                f"dunstify -r 818 -u low -i {icons_dir}/dialog-warning.svg \
                        \"Minimizer\" \"No minimized window\"\
                        -h string:x-canonical-private-synchronous:test",
                shell=True,
                encoding="utf-8",
                )
        exit(0)
    output = subprocess.run(
            f"echo \'{"\n".join(titles)}\'\
              | rofi -dmenu -no-custom -p restore:",
            shell=True,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            ).stdout.strip()
    if len(output) > 0:
        address = title_pid_map[output]
        restore(address)
    else:
        _ = subprocess.run(
                f"dunstify -r 818 -u low -i {icons_dir}/dialog-error.svg \
                        \"Minimizer\" \"No window is chosen to be restored\"\
                        -h string:x-canonical-private-synchronous:test",
                shell=True,
                encoding="utf-8",
                )
        exit(1)


def window_count():
    minimized_wins = json.loads(subprocess.run(
            ["hyprctl", "clients", "-j"],
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            ).stdout)
    return len([win for win in minimized_wins
                if win['workspace']['name'] == "special:minimized"])


def show_info():
    info = {}
    count = window_count()
    info['text'] = str(count)
    info['tooltip'] = f"{count} minimized windows"
    print(json.dumps(info))


if __name__ == "__main__":
    parser = initiate_argparse()
    args = parser.parse_args()
    match args.command:
        case "minimize":
            minimize()
        case "restore":
            restore(args.address)
        case "restorerofi":
            restorerofi()
        case "info":
            show_info()
