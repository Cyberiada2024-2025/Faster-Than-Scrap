import os


def find_folders(path: str) -> list[str]:
    subfolders = [f.path for f in os.scandir(path) if f.is_dir()]
    for path in list(subfolders):
        if "." in path:
            continue
        new_path = path + "O"
        os.rename(path, new_path)
        find_folders(new_path)
        

    final_folders = []
    for folder in subfolders:
        if not "." in folder:  # skip renaming of internal godot directories
            final_folders.append(folder)
    return final_folders


def rename_folders(folders: list[str]) -> None:
    for folder in folders:
        os.rename(folder, folder.lower()[:-1])#+"O")


def main() -> None:
    path = "faster-than-scrap/"

    folders = find_folders(path)
    for folder in folders:
        print(folder)

    return
    rename_folders(folders)


if __name__ == "__main__":
    main()

    input("Success. Press Enter to exit.")
