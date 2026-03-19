#!/usr/bin/env python3

import os
import requests
from alive_progress import alive_bar
import json
from ratelimit import limits, sleep_and_retry

CALLS = 45
RATE_LIMIT = 60
FOLDER_PATH = "/home/lukas/Pictures/Wallpapers"
API_KEY = "DQlHNpjDPjKk4FyevN2cRCRVosUwINIG"
RESOLUTIONS = "1920x1080"
URL = f"https://wallhaven.cc/api/v1/search?apikey={API_KEY}"


@sleep_and_retry
@limits(calls=CALLS, period=RATE_LIMIT)
def check_limit():
    return


# def category() -> str:
#    return "&purity=" + get_purity() + "&categories=" + get_category()


def get_category() -> str:
    # 100 -> general, 010 -> anime, 001 -> people
    category = ["100", "010", "001", "110", "101", "011", "111"]
    get_category = input(
        "Enter category: [1] General [2] Anime [3] People [4] General & Anime [5] General & People [6] Anime & People [7] All => "
    )

    if not get_category or int(get_category) < 1 or int(get_category) > 7:
        return category[1]

    return category[int(get_category) - 1]


def get_purity() -> str:
    # 100 -> sfw, 010 -> sketchy, 001 -> nsfw
    purity = ["100", "010", "001", "110", "101", "011", "111"]
    get_purity = input(
        "Enter purity: [1] SFW [2] Sketchy [3] NSFW [4] SFW & Sketchy [5] SFW & NSFW [6] sketchy & NSFW [7] All => "
    )

    if not get_purity or int(get_purity) < 1 or int(get_purity) > 7:
        return purity[0]

    return purity[int(get_purity) - 1]


def get_sorting_param() -> str:
    parameters = ["date_added", "relevance", "random", "views", "favorites", "toplist"]
    choice = input(
        "Enter sorting parameter: [1] Date [2] Relevance [3] Random [4] Views [5] Favorites [6] Toplist => "
    )
    if not choice or int(choice) < 1 or int(choice) > 7:
        return parameters[0]

    return parameters[int(choice) - 1]


def get_top_range() -> str:
    range_search = ["1d", "3d", "1w", "1M", "3M", "6M", "1y"]
    choice = input(
        "Enter top list: [1] 1 Day [2] 3 Days [3] 1 week [4] 1 Month [5] 3 Month [6] 6 Month [7] 1 Year => "
    )

    if not choice or int(choice) < 1 or int(choice) > 7:
        return range_search[4]

    return range_search[int(choice) - 1]


def search() -> str:
    final_tag_list = ""
    tags = input("Enter your tags (eg. tag1 tag2...): ")
    tags = tags.split(" ")
    for tag in tags:
        final_tag_list = final_tag_list + f"+{tag}"

    return final_tag_list


def number_pages() -> str:
    pages = input("Enter number of pages to download: ")
    if not pages or not pages.isdigit() or int(pages) < 1:
        return "1"
    return pages


def final_url(
    category: str, tags: str, purity: str, list_range: str, sorting: str, page_no: str
) -> str:
    return f"{URL}{'' if not tags else f'&q={tags}'}&categories={category}&purity={purity}&toplist={list_range}&sorting={sorting}&resolutions={RESOLUTIONS}&page={page_no}"


def get_img_url_list(url: str) -> list[str]:
    img_url_list: list[str] = []
    check_limit()
    imgs_data = requests.get(url)
    page_images = json.loads(imgs_data.content)
    page_data = page_images["data"]

    for i in range(len(page_data)):
        img_url_list.append(page_data[i]["path"])

    return img_url_list


def download_images(images_url: list[str], purity: bool) -> None:
    # Initialising progress bar
    with alive_bar(len(images_url), bar="smooth", spinner="waves2") as bar:
        for i in range(len(images_url)):
            url = images_url[i]
            image_name = os.path.basename(url)
            image_path = (
                os.path.join(FOLDER_PATH, image_name)
                if purity
                else os.path.join(f"{FOLDER_PATH}/npur", image_name)
            )
            if not os.path.exists(image_path):
                check_limit()
                request_image = requests.get(url)
                if request_image.status_code == 200:
                    bar.text(f"Downloading: {image_name}")
                    with open(image_path, "ab") as image:
                        for chunk in request_image.iter_content(1024):
                            image.write(chunk)
                else:
                    print("Error occured")
            bar()


def download_page(url_list: list[str], purity: str) -> None:
    pur = True
    os.makedirs(FOLDER_PATH, exist_ok=True)
    if purity in ["010", "001", "110", "101", "011", "111"]:
        os.makedirs(f"{FOLDER_PATH}/npur", exist_ok=True)
        pur = False

    download_images(url_list, pur)


def main() -> None:
    page_number = number_pages()
    tags = search().strip()
    purity = get_purity()
    list_range = get_top_range()
    sorting = get_sorting_param()
    category = get_category()

    url_list = []

    for i in range(0, int(page_number)):
        url = final_url(category, tags, purity, list_range, sorting, str(i + 1))
        url_list.extend(get_img_url_list(url))

    download_page(url_list, purity)


if __name__ == "__main__":
    main()
