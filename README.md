# GoFile Uploader

A Simple Script to upload Files to https://gofile.io via Terminal (CLI). Written in Bash.

## Features

- Upload files using the official GoFile API
- Single and multiple file uploads
- Fast servers with no file size limits
- Optional Telegram notifications
- Environment-based configuration (.env)

## Requirements

- `curl`
- `jq`

## Configuration

Create a `.env` file in the same directory as `upload.sh` and add your Telegram credentials.

### .env Template

```env
# Telegram (Optional)
BOT_TOKEN=
CHAT_ID=
```

> Leave `BOT_TOKEN` and `CHAT_ID` empty if you don't want Telegram notifications.

## Usage

Download the script:

```bash
wget -O upload.sh https://raw.githubusercontent.com/EternalMikaelson/gofile-uploader/refs/heads/main/upload.sh
chmod +x upload.sh
```

Upload a single file:

```bash
./upload.sh path/to/file
```

Upload multiple files:

```bash
./upload.sh path/to/file1 path/to/file2
```

Or if you're already in the same directory as the files:

```bash
./upload.sh boot.img vendor_boot.img ROM.zip
```

## Telegram Output

> ✅ Upload Complete
>
> 📁 filename.zip *(clickable download link)*
>
> 📦 2.8 GB
## Terminal Output

> 📁 filename.zip
>
> 📦 2.8 GB
>
> ⬆️ Uploading to GoFile...
>
> ✅ Upload Complete!
>
> 🔗 https://gofile.io/d/XXXXXXXX
>
> 📨 Telegram notification sent. **or** ℹ️ Telegram not configured. Skipping notification.

## Credits

- https://gofile.io — Official GoFile API
- [Sushrut1101](https://github.com/Sushrut1101) — Original GoFile uploader script
- [EternalMikaelson](https://github.com/EternalMikaelson) — Telegram integration and project improvements
