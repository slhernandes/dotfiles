#!/usr/bin/env python3
import sys
import subprocess
import argparse


def get_cur_window_prop():
    output = subprocess.run(
            ["hyprctl", "activewindow"],
            shell=False,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
            )
    return output.stdout


def get_cur_workspace_prop():
    output = subprocess.run(
            ["hyprctl", "activeworkspace"],
            shell=False,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
            )
    return output.stdout



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

    parser_maximize = subparsers.add_parser("maximize",
                                            help="move selected window back to workspace")
    parser_maximize.add_argument("pid", type=int, help="pid of window")

    _ = subparsers.add_parser("maximizerofi",
                              help="use rofi to interactively maximize window")

    return parser


def minimize():
    prop = get_cur_window_prop()
    lines = prop.split("\n")
    pid = None
    for i in lines:
        prop_name = i.split(": ")
        if prop_name[0].strip() == "pid":
            pid = int(prop_name[1])
    if pid is not None:
        move_window_to_special(pid)
    else:
        print("PID not found!", file=sys.stderr)


def maximize(pid):
    prop = get_cur_workspace_prop()
    w_id = prop.split("\n")[0].split(" ")[2].strip()
    _ = subprocess.run(
            ["hyprctl", "dispatch", "togglespecialworkspace", f"script_{pid}"],
            shell=False,
            encoding="utf-8",
            )
    _ = subprocess.run(
            ["hyprctl", "dispatch", "movetoworkspace", w_id],
            shell=False,
            encoding="utf-8",
            )


def maximizerofi():
    minimized_wins = subprocess.run(
            "hyprctl clients | grep \'special:script_.*\' -A 8",
            shell=True,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            )
    output = minimized_wins.stdout
    if output == '':
        return
    minimized_wins = output.split("--")
    title_pid_map = {}
    titles = []

    for i in minimized_wins:
        lines = i.split("\n")
        title = ""
        pid = None
        for j in lines:
            prop_name = j.split(": ")
            if prop_name[0].strip() == "class":
                title += prop_name[1]
                title += ": "
            elif prop_name[0].strip() == "title":
                title += prop_name[1]
            elif prop_name[0].strip() == "pid":
                pid = int(prop_name[1].strip())
        title = f"{title}, (pid: {pid})"
        titles.append(title)
        title_pid_map[title] = pid
    output = subprocess.run(
            f"echo \'{"\n".join(titles)}\' | rofi -dmenu -no-custom -p maximize:",
            shell=True,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            )
    pid = title_pid_map[output.stdout.strip()]
    if pid is not None:
        maximize(pid)


if __name__ == "__main__":
    parser = initiate_argparse()
    args = parser.parse_args()
    match args.command:
        case "minimize":
            minimize()
        case "maximize":
            maximize(args.pid)
        case "maximizerofi":
            maximizerofi()
