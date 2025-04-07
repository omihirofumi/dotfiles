mod yaml;

struct Config {
    dir: String,
    dotfiles: Vec<Dotfile>,
}

struct Dotfile {
    name: String,
    src: String,
}
