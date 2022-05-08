# Nginx Maintenance Mode

```
           _   __      _
          / | / /___ _(_)___  _  __
         /  |/ / __ `/ / __ \| |/_/
        / /|  / /_/ / / / / />  <
       /_/ |_/\__, /_/_/ /_/_/|_|
    	      /____/
    __  ___      _       __
   /  |/  /___ _(_)___  / /____  ____  ____ _____  ________
  / /|_/ / __ `/ / __ \/ __/ _ \/ __ \/ __ `/ __ \/ ___/ _ \
 / /  / / /_/ / / / / / /_/  __/ / / / /_/ / / / / /__/  __/
/_/  /_/\__,_/_/_/ /_/\__/\___/_/ /_/\__,_/_/ /_/\___/\___/

```
[![GitHub release](https://img.shields.io/github/release/tmiland/Nginx-Maintenance-Mode.svg?style=for-the-badge)](https://github.com/tmiland/Nginx-Maintenance-Mode/releases)
[![licence](https://img.shields.io/github/license/tmiland/Nginx-Maintenance-Mode.svg?style=for-the-badge)](https://github.com/tmiland/Nginx-Maintenance-Mode/blob/master/LICENSE)
![Bash](https://img.shields.io/badge/Language-SH-4EAA25.svg?style=for-the-badge)

## Easily toggle on or off maintenance mode with nginx


### Screenshots
![screenshot](https://raw.githubusercontent.com/tmiland/Nginx-Maintenance-Mode/master/img/maintenance.png)

### Installation

#### Download and execute the script:

```bash
$ git clone https://github.com/tmiland/Nginx-Maintenance-Mode.git
$ cd Nginx-Maintenance-Mode
$ cp -rp ./maintenance-page.conf /etc/nginx/snippets/
$ git clone https://github.com/tmiland/server-error-pages.git /etc/nginx/html/server-error-pages
$ cp -rp /etc/nginx/html/server-error-pages/_site/maintenance-page.html /etc/nginx/html/server-error-pages/_site/maintenance-page_off.html
$ chmod +x maintenance.sh
```

#### Add to server directive

```
server {

## Nginx Maintenance Mode
include snippets/maintenance-page.conf;

}
```

#### Optionally

```bash
$ ln -s /path/to/Nginx-Maintenance-Mode/maintenance.sh /usr/bin/maintenance
```

#### Check for errors

```bash
$ nginx -t 
```

- Add to each virtual server in /etc/nginx/sites-available you want to enable maintenance mode on.
- Else, add to nginx.conf.

#### Usage

```bash
$ ./maintenance.sh [hostname] [on/off]
```

#### Optionally

```bash
$ maintenance [hostname] [on/off]
```

*** Note: [hostname] must match the hostname in your.hostname.com.conf/nginx.conf ***

```
server {
	server_name your.hostname.com;
  }
```

- When maintenance mode is toggled on, maintenance-page_off.html will be copied to $server_name-maintenance-page_on.html. E.g: your.hostname.com-maintenance-page_on.html
- This way you can use this with multiple virtual servers, and easily toggle on/off maintenance mode individiually for each site.
- Toggle off, deletes $server_name-maintenance-page_on.html

### Advanced usage

```bash
$ ./maintenance.sh my.hostname.com on
$ ./maintenance.sh my-other.hostname.com on
$ ./maintenance.sh hostname.com on
$ ./maintenance.sh my.hostname.com off
$ ./maintenance.sh my-other.hostname.com off
$ ./maintenance.sh hostname.com off
```

#### Logic in maintenance-page.conf

```

if (-f /etc/nginx/html/server-error-pages/_site/$server_name-maintenance-page_on.html)
{
  return 503;
}
error_page 503 @maintenance;
location @maintenance
{
  rewrite ^(.*)$ /$server_name-maintenance-page_on.html break;
  root /etc/nginx/html/server-error-pages/_site;
}

```

- If your.hostname.com-maintenance-page_on.html exists, error 503 is returned.
- If not, operation is back to normal.

## Added Bonus

#### Add support for custom error pages

*** This will add the error pages included in the repo ***

```bash
$ cp -rp ./error_pages.conf /etc/nginx/snippets/
$ cp -rp ./error_pages_content.conf /etc/nginx/snippets/
```

#### Add to server directive

*** Final configuration should look like this: ***

```
server {

## Nginx Maintenance Mode
include snippets/maintenance-page.conf;
## Custom Error Pages
include snippets/error_pages.conf;

}
```

## Scheduled maintenance

Example shell script:

Name the script, someting like: ```pg_backup_cron.sh```

```bash
#!/usr/bin/env bash

# Turn on maintenance mode
/path/to/Nginx-Maintenance-Mode/maintenance.sh hostname.com on
# Run database backups
/path/to/pgbackup/pg_backup.sh
# Turn off maintenance mode
/path/to/Nginx-Maintenance-Mode/maintenance.sh hostname.com off
exit 0
```

Add job to cron:

```
$ crontab -e
```
```
@daily bash /path/to/pgbackup/pg_backup_cron.sh > /dev/null 2>&1 #Automated PostgreSQL Backup on Linux
```

Used in this example: [pgbackup - Automated PostgreSQL Backup on Linux](https://github.com/tmiland/pgbackup)

## Why maintenance mode is important

- Helps your SEO rankings

As [recommended by Google](https://webmasters.googleblog.com/2011/01/how-to-deal-with-planned-site-downtime.html), Maintenace Mode is using the 503 service unavailable result code, which tells search engine crawlers that the downtime is temporary.

## Credits

- Server-Error-Pages
  - Source: https://github.com/alexphelps/server-error-pages
- Nginx Maintenance Mode with Integration Testing
  - Nginx Configuration Example
  - Source: https://github.com/czerasz/nginx-configuration-examples
  - Source: https://czerasz.com/2015/04/21/nginx-maintenance-mode/

## Donations
<a href="https://www.buymeacoffee.com/tmiland" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
- [PayPal me](https://paypal.me/milanddata)
- [BTC] : 33mjmoPxqfXnWNsvy8gvMZrrcG3gEa3YDM

## Web Hosting

Sign up for web hosting using this link, and receive $100 in credit over 60 days.

[DigitalOcean](https://m.do.co/c/f1f2b475fca0)

#### Disclaimer 

*** ***Use at own risk*** ***

### License

[![MIT License Image](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/MIT_logo.svg/220px-MIT_logo.svg.png)](https://github.com/tmiland/Nginx-Maintenance-Mode/blob/master/LICENSE)

[MIT License](https://github.com/tmiland/Nginx-Maintenance-Mode/blob/master/LICENSE)
