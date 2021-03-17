fn get_text() -> Result<String, reqwest::Error> {
    let channel_url = "https://ch.nicovideo.jp/weathernews";
    eprintln!("get {}", channel_url);
    Ok(reqwest::blocking::get(channel_url)?.text()?)
}

fn select_latest(body: &str) -> Vec<String> {
    let document = scraper::Html::parse_document(&body);
    let selector = scraper::Selector::parse(".thumb_live.thumb_100").unwrap();
    let elements = document.select(&selector);
    elements.map(|e| e.value().attr("href").unwrap().to_string()).collect()
}

pub fn get_latest_url() -> String {
    let body = get_text().unwrap();
    let urls = select_latest(&body);
    eprintln!("{:?}", urls);
    urls[0].to_string()
}
