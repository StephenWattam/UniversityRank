Web Scraping
============
Aims: to download the textual content of various university websites for later processing.

Method: Download:

 1. The home page
 2. One level of links from the home page

Use ruby, wget.

Policy
------
 
 * Three downloads will occur, one with a depth of 1, one with a depth of 2, and one that is homepage-only.
 * Server spanning is allowed.  It is both difficult to avoid (due to subdomains) and desirable to retain (more academic links, regardless of host, theoretically indicate a better score overall).
 * The user agent will be spoofed to be my user-agent at the time of sampling: `Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.56 Safari/537.17`  This is from chromium 24 on linux.
 * Wget will convert links using -k.  This doesn't make any real scientific difference but might be handy.
 * Session cookies will be stored
 * SSL will be accepted blindly
 * No attempt will be made to auth using http methods
 * Max number of redirects to follow is 5
 * The referrer will be set to the homepage url
 * The whole HTTP response will be recorded
 * Robots.txt was followed, so as not to be too evil to people (also, this represents search crawling in some way)

The final wget string is:

      `wget -r -l 1 -H -k --save-cookies cookies.tmp --keep-session-cookies --max-redirect=5 --referer=#{Shellwords::escape(line.field('url'))} --save-headers --user-agent="#{UA}" --no-directories --no-host-directories -P #{Shellwords::escape(where)} #{Shellwords::escape(line.field("url"))}`

Result
------
All files are stored in a directory that is named for its institution, under the 'webdata0,1,2' directory in data/WebScrape.  The number corresponds to the number of links followed.

Though they contain the raw HTTP headers, they retain original filenames (with .1, .2 etc suffixes added by wget's clobbering routine).  In many cases, prospecti and other non-html things are stored.
