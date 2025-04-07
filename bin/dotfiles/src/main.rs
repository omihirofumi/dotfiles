use std::{fs, path::{Path, PathBuf}};

static CONFIG_LIST_FILE: &str = "dotfiles.yaml";
static DOTFILES_DIR: &str = "/Users/hirofumiomi/Works/tools/dotfiles";

fn main() {
    let file = fs::read_to_string(CONFIG_LIST_FILE).unwrap();
    file.split('\n')
        .filter(|line| !line.is_empty())
        .for_each(|line| {
            let paths: Vec<&str> = line.split('=').map(str::trim).collect();

            if paths.len() == 2 {
                let dest = Path::new(DOTFILES_DIR).join(paths[0]);
                let source = expand_tilde(paths[1]);

                match fs::copy(&source, &dest) {
                    Ok(_) => println!("Copied from {:?} to {:?}", source, dest),
                    Err(e) => eprintln!("Failed to copy from {:?} to {:?}: {}", source, dest, e),
                }
            } else {
                eprintln!("Invalid line: {}", line);
            }
        })
}

fn expand_tilde(path: &str) -> PathBuf {
    if path.starts_with("~") {
        if let Some(home_dir) = dirs::home_dir() {
            return home_dir.join(&path[2..]);
        }
    }
    PathBuf::from(path)
}
