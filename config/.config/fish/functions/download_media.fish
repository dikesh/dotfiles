function download_media
    # Get URL
    set -l url (rofi -dmenu \
        -p "URL" \
        -theme-str 'entry { placeholder: "https://www.instagram.com/reel/ABcD_Xyz/"; }')

    test $status -ne 0; and return
    test -z "$url"; and return

    # Select video / audio
    set -l media_type (printf "Video\nAudio" | rofi -dmenu -p "Download" -selected-row 0)

    test $status -ne 0; and return

    # Download audio / video
    switch $media_type
        case Video
            yt-dlp -t mp4 --js-runtimes node --no-playlist --cookies-from-browser chrome+gnomekeyring -o "%(title)s.%(ext)s" $url
        case Audio
            yt-dlp -x --js-runtimes node --audio-format m4a --embed-thumbnail --no-playlist -o "%(title)s.%(ext)s" $url
    end
end
