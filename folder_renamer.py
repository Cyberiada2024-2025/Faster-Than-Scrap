import os


def find_folders(path: str) -> list[str]:
    subfolders = [f.path for f in os.scandir(path) if f.is_dir()]
    for path in list(subfolders):
        subfolders.extend(find_folders(path))

    final_folders = []
    for folder in subfolders:
        if not "." in folder:  # skip renaming of internal godot directories
            final_folders.append(folder)
    return final_folders


def rename_folders(folders: list[str]) -> None:
    for folder in folders:
        os.rename(folder, folder.lower())


def main() -> None:
    path = "faster-than-scrap/"

    folders = find_folders(path)

    rename_folders(folders)


if __name__ == "__main__":
    main()

    input("Success. Press Enter to exit.")
