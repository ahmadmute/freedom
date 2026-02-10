# Freedom

**Repo:** [https://github.com/ahmadmute/freedom](https://github.com/ahmadmute/freedom)

SOCKS proxy over SSH: tunnel, set/unset proxy env, and use `curl` (or any app) through the proxy. For restricted servers – one SSH session, no second terminal needed.

## Install

One-line install (run installer script, then use `freedom`):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ahmadmute/freedom/main/install.sh)
```

Then run from anywhere:

```bash
freedom          # help
freedom shell    # on restricted server: tunnel + shell with proxy
freedom start    # start tunnel (foreground)
freedom status   # show proxy env
```

Other options:

- **Direct download** (to `/usr/local/bin`):
  ```bash
  sudo curl -sSL https://raw.githubusercontent.com/ahmadmute/freedom/main/freedom.sh -o /usr/local/bin/freedom && sudo chmod +x /usr/local/bin/freedom
  ```
- **Without sudo** (install to `~/bin`): the one-liner above will choose `~/bin` if `sudo` is not available.

If you used direct download and get `cannot execute: required file not found`, run: `sed -i 's/\r$//' /usr/local/bin/freedom` (or `~/bin/freedom`).

## Requirements

- **SSH**: `ssh` in PATH (e.g. OpenSSH, or Git Bash / WSL on Windows).
- **Server**: A remote host you can SSH into (root or any user).

## Usage

Run on **Linux/macOS** or **Windows (Git Bash / WSL)**. After [install](#install) you can use `freedom`; otherwise:

```bash
chmod +x freedom.sh
./freedom.sh
# or: freedom
```

### Commands

| Command | Description |
|--------|-------------|
| **`freedom shell [ip] [user]`** / **`./freedom.sh shell ...`** | **On the restricted server:** start tunnel in background and open a shell with proxy set. One SSH session – no second SSH needed; `apt`, `curl`, etc. use the proxy. |
| `freedom start [ip] [user]` | Start SSH SOCKS tunnel. Asks for IP and user if not given. |
| `freedom start-bg [ip] [user]` | Same as `start` but in background. |
| `freedom set` | Set `http_proxy` and `https_proxy` to `socks5h://127.0.0.1:1081`. |
| `freedom unset` | Unset proxy variables. |
| `freedom curl [url]` | Run `curl -L` through the proxy. Asks for URL if not given. |
| `freedom status` | Show proxy env (like `env \| grep proxy`). |
| `freedom stop` | Kill the SSH tunnel on port 1081. |

### Optional environment variables

- **`PROXY_PORT`** – SOCKS port (default: `1081`).
- **`SSH_USER`** – Default SSH user (e.g. `root`).

Example:

```bash
export PROXY_PORT=1081
export SSH_USER=root
freedom start
# Enter IP when prompted; SSH will ask for password.
# In another terminal:
eval $(freedom set)
freedom curl https://ifconfig.me
eval $(freedom unset)
freedom status
```

## Workflow: Restricted server (net محدود روی سرور)

When the **server** has restricted internet, run the script **on that server**. You need another machine with open internet (your PC, or a VPS) that the server can SSH to.

1. Copy `freedom.sh` to the restricted server or install with the one-liner (see [Install](#install)).
2. SSH into the restricted server: `ssh root@your-server`.
3. On the server, run:
   ```bash
   freedom shell
   ```
   (or `./freedom.sh shell` if not installed as `freedom`)
4. When asked, enter the **proxy server IP** (the machine with open internet) and SSH user. Enter the SSH password when SSH asks.
5. You get a new shell in the **same** SSH session with `http_proxy` and `https_proxy` set. Use `apt`, `curl`, `wget`, etc. as usual – they all go through the SOCKS proxy. No need to open another SSH.
6. When done, type `exit` to leave the proxy shell. Use `freedom stop` to kill the tunnel.

---

## Other workflow (local machine)

1. **Start tunnel** (will prompt for IP and user if needed, then SSH password):
   ```bash
   freedom start
   ```
   Or in background:
   ```bash
   freedom start-bg
   ```

2. **Set proxy in current shell**:
   ```bash
   eval $(freedom set)
   ```

3. **Use curl**:
   ```bash
   freedom curl https://example.com
   ```

4. **Unset proxy**:
   ```bash
   eval $(freedom unset)
   ```

5. **Check proxy**:
   ```bash
   freedom status
   ```

---

# آزادی (فارسی)

**ریپازیتوری:** [https://github.com/ahmadmute/freedom](https://github.com/ahmadmute/freedom)

پراکسی SOCKS روی SSH: تونل، ست/غیرفعال کردن پراکسی، و استفاده از `curl` (یا هر برنامه‌ای) از طریق پراکسی. برای سرورهای محدود – یک سشن SSH کافیه، نیازی به ترمینال دوم نیست.

## نصب خودکار

نصب با یک دستور (مثل Paqet؛ اسکریپت نصب اجرا می‌شود و بعد دستور `freedom` نصب می‌شود):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ahmadmute/freedom/main/install.sh)
```

بعد از هر جا فقط بنویس:

```bash
freedom          # راهنما
freedom shell    # روی سرور محدود: تونل + شل با پراکسی
freedom start    # شروع تونل (جلوی پیش)
freedom status   # نمایش وضعیت پراکسی
```

گزینه‌های دیگر: نصب مستقیم با `sudo curl ...` یا اگر sudo نداری، همان یک‌خط بالا در صورت امکان در `~/bin` نصب می‌کند.

## پیش‌نیازها

- **SSH**: `ssh` در PATH (مثلاً OpenSSH، یا Git Bash / WSL در ویندوز).
- **سرور**: یک ماشین دور که بتونی با SSH بهش وصل بشی (root یا هر کاربری).

## نحوه استفاده

روی **لینوکس/macOS** یا **ویندوز (Git Bash / WSL)** اجرا کن. بعد از [نصب خودکار](#نصب-خودکار) می‌تونی فقط `freedom` بنویسی؛ وگرنه:

```bash
chmod +x freedom.sh
./freedom.sh
# یا: freedom
```

### دستورات

| دستور | توضیح |
|--------|--------|
| **`freedom shell [ip] [user]`** / **`./freedom.sh shell ...`** | **روی سرور محدود:** تونل را در پس‌زمینه شروع کن و یک شل با پراکسی باز کن. یک سشن SSH کافیه؛ `apt`، `curl` و غیره از پراکسی استفاده می‌کنند. |
| `freedom start [ip] [user]` | شروع تونل SOCKS. اگر IP و user ندادی، می‌پرسه. |
| `freedom start-bg [ip] [user]` | مثل `start` ولی در پس‌زمینه. |
| `freedom set` | ست کردن `http_proxy` و `https_proxy` روی `socks5h://127.0.0.1:1081`. |
| `freedom unset` | حذف متغیرهای پراکسی. |
| `freedom curl [url]` | اجرای `curl` از طریق پراکسی. اگر url ندادی می‌پرسه. |
| `freedom status` | نمایش وضعیت پراکسی (مثل `env \| grep proxy`). |
| `freedom stop` | بستن تونل SSH روی پورت 1081. |

### متغیرهای اختیاری محیط

- **`PROXY_PORT`** – پورت SOCKS (پیش‌فرض: `1081`).
- **`SSH_USER`** – کاربر پیش‌فرض SSH (مثلاً `root`).

مثال:

```bash
export PROXY_PORT=1081
export SSH_USER=root
freedom start
# وقتی خواست IP و user را وارد کن؛ SSH پسورد می‌خواهد.
# در یک ترمینال دیگر:
eval $(freedom set)
freedom curl https://ifconfig.me
eval $(freedom unset)
freedom status
```

## سناریو: سرور با اینترنت محدود

وقتی **سرور** اینترنت محدود داره، اسکریپت را **روی همون سرور** اجرا کن. به یک ماشین دیگر با اینترنت آزاد (کامپیوتر خودت یا یک VPS) نیاز داری که سرور بتونه با SSH بهش وصل بشه.

1. `freedom.sh` را روی سرور محدود کپی کن یا با دستور [نصب خودکار](#نصب-خودکار) نصب کن.
2. با SSH وارد سرور شو: `ssh root@your-server`.
3. روی سرور اجرا کن:
   ```bash
   freedom shell
   ```
   (یا `./freedom.sh shell` اگر به صورت `freedom` نصب نکردی)
4. وقتی پرسید، **IP سرور پراکسی** (همان ماشین با اینترنت آزاد) و کاربر SSH را وارد کن. پسورد SSH را وقتی SSH خواست بزن.
5. یک شل جدید در **همان** سشن SSH با `http_proxy` و `https_proxy` ست‌شده باز می‌شود. از `apt`، `curl`، `wget` و غیره عادی استفاده کن – همه از طریق پراکسی SOCKS می‌روند. نیازی به باز کردن SSH دوم نیست.
6. وقتی تمام شد، `exit` بزن تا از شل پراکسی خارج بشی. برای بستن تونل: `freedom stop`.

---

## سناریو دیگر (روی ماشین لوکال)

1. **شروع تونل** (در صورت نیاز IP و user و پسورد SSH را می‌پرسد):
   ```bash
   freedom start
   ```
   یا در پس‌زمینه:
   ```bash
   freedom start-bg
   ```

2. **ست کردن پراکسی در شل فعلی**:
   ```bash
   eval $(freedom set)
   ```

3. **استفاده از curl**:
   ```bash
   freedom curl https://example.com
   ```

4. **خاموش کردن پراکسی**:
   ```bash
   eval $(freedom unset)
   ```

5. **بررسی وضعیت پراکسی**:
   ```bash
   freedom status
   ```
