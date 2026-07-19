function download_media
    # Shell variables
    set -x GUM_CONFIRM_SELECTED_BACKGROUND "#008080"

    # Get URL
    set -l url (gum input \
    --header "URL:" \
    --placeholder "https://www.instagram.com/reel/ABcD_Xyz/?igsh=Xyz_AbCE==")
    test $status -ne 0; and return

    # Download audio / video
    gum confirm --affirmative Video --negative Audio --default=true "Video / Audio"
    set -l confirm_status $status
    test $confirm_status -eq 130; and return

    if test $confirm_status -eq 0
        yt-dlp -t mp4 --no-playlist $url --cookies-from-browser chrome+gnomekeyring -o "%(title)s.%(ext)s"
    else
        yt-dlp -x --audio-format m4a --embed-thumbnail --no-playlist $url -o "%(title)s.%(ext)s"
    end
end
