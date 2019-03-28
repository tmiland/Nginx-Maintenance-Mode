# Nginx Maintenance Mode

[![GitHub release](https://img.shields.io/github/release/tmiland/Nginx-Maintenance-Mode.svg?style=for-the-badge)](https://github.com/tmiland/Nginx-Maintenance-Mode/releases)
[![licence](https://img.shields.io/github/license/tmiland/Nginx-Maintenance-Mode.svg?style=for-the-badge)](https://github.com/tmiland/Nginx-Maintenance-Mode/blob/master/LICENSE)
![Bash](https://img.shields.io/badge/Language-SH-4EAA25.svg?style=for-the-badge)

## Easily toggle on or off maintenance mode with nginx


## Screenshots
![screenshot](https://raw.githubusercontent.com/tmiland/Nginx-Maintenance-Mode/master/img/maintenance.png)

## Installation

#### Download and execute the script:

```bash
$ git clone https://github.com/tmiland/Nginx-Maintenance-Mode.git
$ cd Nginx-Maintenance-Mode
$ cp -rp ./maintenance-page.conf /etc/nginx/snippets/
$ git clone https://github.com/alexphelps/server-error-pages.git /etc/nginx/html/server-error-pages
$ cp -rp /etc/nginx/html/server-error-pages/_site/maintenance-page.html /etc/nginx/html/server-error-pages/_site/maintenance-page_off.html
$ nginx -t # Check for errors, if found, correct them and;
$ chmod +x maintenance.sh
```

### Add to server directive

```
## Nginx Maintenance Mode
include snippets/maintenance-page.conf;
```

- Add to each virtual server in /etc/nginx/sites-available you want to enable maintenance mode on.
- Else, add to nginx.conf.

## Usage

```bash
$ ./maintenance.sh [hostname] [on/off]
```
*** Note: [hostname] must match the hostname in your.hostname.com.conf/nginx.conf ***

## E.G

```
server {
	server_name your.hostname.com;
  }
```

- When maintenance mode is toggled on, maintenance-page_off.html will be copied to $server_name-maintenance-page_on.html. E.g: your.hostname.com-maintenance-page_on.html
- This way you can use this with multiple virtual servers, and easily toggle on/off maintenance mode individiually for each site.
- Toggle off, deletes $server_name-maintenance-page_on.html

# Advanced usage

```bash
$ ./maintenance.sh my.hostname.com on
$ ./maintenance.sh my-other.hostname.com on
$ ./maintenance.sh my.hostname.com off
$ ./maintenance.sh my-other.hostname.com off
```

## Logic in maintenance-page.conf

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

- If your.hostname.com-maintenance-page_on.html exists, a error 503 is returned.
- If not, operation is back to normal.


## Credits

- Server-Error-Pages
  - Source: https://github.com/alexphelps/server-error-pages
- Nginx Maintenance Mode with Integration Testing
  - Nginx Configuration Example
  - Source: https://github.com/czerasz/nginx-configuration-examples
  - Source: https://czerasz.com/2015/04/21/nginx-maintenance-mode/

## Donations 
- [PayPal me](https://paypal.me/milanddata)
- [BTC] : 3MV69DmhzCqwUnbryeHrKDQxBaM724iJC2
- [BCH] : qznnyvpxym7a8he2ps9m6l44s373fecfnv86h2vwq2

## Web Hosting

Sign up for web hosting using this link, and receive $100 in credit over 60 days.

[DigitalOcean](https://m.do.co/c/f1f2b475fca0)

#### Disclaimer 

*** ***Use at own risk*** ***

### License

[![MIT License Image](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/MIT_logo.svg/220px-MIT_logo.svg.png)](https://github.com/tmiland/Nginx-Maintenance-Mode/blob/master/LICENSE)

[MIT License](https://github.com/tmiland/Nginx-Maintenance-Mode/blob/master/LICENSE)
