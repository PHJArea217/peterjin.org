2018-10-29|3|-|-|BusyBox and its utilities

[BusyBox](https://www.busybox.net/) is a well-known toolset for Linux with many
common Unix utilities like cp, sed, ls, sh, grep, and many more. It is popular
on embedded systems like wireless routers where space may be at a premium;
BusyBox combines all these tools into a single binary with functionality shared
between utilities.

However, in addition to those common Unix utilities, there are also a few others
that may be of interest:

## httpd

BusyBox has an small HTTP server called "httpd." In my opinion, although I would
not recommend it for production use, it is still quite useful. The main use
of httpd in busybox is the "Preview in port 8080" feature of the Google Cloud
Shell. I go to a desired root directory for a web server, such as the "public"
folder for my GitLab Pages sites, and I simply run ```busybox httpd -p 8080```
in that directory to start the web server.

The primary advantage of this is that it is completely plug-and-play; no
configuration required. As such, it is useful for quickly testing website
configurations on the Cloud Shell.

## Within Docker and GitLab CI

When you pull a Docker container, you often have no idea which utilities come
built into the image. Oftentimes, you may have to install packages which take up
a lot of space and time. BusyBox is a smaller version of those packages. As a
result, if I know that a utility like ifconfig or wget is in BusyBox and I need
it for a GitLab CI pipeline or Docker container, I go straight to BusyBox.

It is arguable that many of the utilities are reduced in functionality. For
example, the xz command is decompress-only and there is no visual \("v" or "V")
support in the vi editor. However, most of the utilities are sufficient for my
needs.

Although there is a busybox [image](https://hub.docker.com/r/_/busybox) on the
Docker Hub, it does lack features such as a package manager. Similarly, although
there is an "alpine" [image](https://hub.docker.com/r/_/alpine), it's just that
I'm more familar with the Debian/Ubuntu package management system.

Maybe later I'll be able to use the "alpine" image. But for now, I'm sticking to
Debian and Ubuntu images.

## tcpsvd

This tool is not present in the Debian/Ubuntu version of busybox. However, it
does have a useful mode in conjunction with nc -- as a forwarding proxy.

```tcpsvd :: 8080 nc 192.168.1.1 80```

This command basically forwards local port 8080 to 192.168.1.1 80. Again, like
the httpd example, there is virtually no configuration required.