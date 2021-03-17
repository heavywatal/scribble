mod channel;
use std::process::Command;

fn open(url: &str) {
    eprintln!("open -a Safari {}", url);
    Command::new("open")
            .arg("-a")
            .arg("Safari")
            .arg(url)
            .spawn()
            .expect("failed to execute process");
}

fn main() {
    let url = channel::get_latest_url();
    open(&url);
    println!("{}", url);
}
