2018-09-16|1|-|-|Welcome to my blog! (and, how I've been using Google Cloud Platform these days)

One of the things that I've always wanted to do on my website is to
write a blog describing some of the things I've come about on the
Internet. Being the computer scientist that I am currently, instead of
using pre-existing templates, I decided to write the entire design from
scratch without any templates.

One of the advantages of writing the design from scratch is that you have
the freedom to customize the design exactly to your liking. Although the
current design is somewhat plain and boring, it definitely will evolve into
a more sophisticated design sometime in the future, but for right now, it's
just a black-and-white plain blog.

This blog does not use Jekyll or any other third-party static site generator.
Instead, everything is done through a shell script, and that script is
executed on GitLab CI and then uploaded to GitLab Pages. This is especially
useful whenever you need to generate content semi-dynamically: for example,
the [IERS bulletin data file](https://webclock.peterjin.org/iers-bulcd.json)
used for my web clock was generated using a .java file that downloaded the
IERS bulletins from the [official web site](https://hpiers.obspm.fr/iers/bul/)
and then manipulated them into a JSON file. This is simply not possible with
Jekyll or similar, which does not allow execution of arbitrary code.

Aside from my blog, I also have started to use Google Cloud Platform for my
website design. Currently, I only have two Cloud Functions \[n1]. One powers
my web clock, the other is used to implement the go.peterjin.org URL shortener.
The [web clock function](https://github.com/PHJArea217/nginx-clock/blob/master/cloud-function.js)
is simple \(it returns current time in JSON), but the go.peterjin.org URL
shortener is somewhat interesting.

The URL shortener was implemented using a clever trick:

* Set up a Cloudflare Page Rule that redirects the base URL go.peterjin.org/\*
to the Cloud Function, with the request path inserted into a query parameter.
* In the Cloud Function, read the query parameter. Using an if-else or switch
statement, return a 301 or 302 redirect to the appropriate full URL.

The idea is to first redirect from go.peterjin.org to the cloud function, and
then use the cloud function to redirect to the final destination. This first
redirection is needed because Cloud Functions does not support custom URLs unlike
App Engine, so I can't simply assign a custom URL to my function. However, this is
all transparent to the user. All that the user will see is the original
go.peterjin.org short URL and where it ultimately redirects. The cloudfunctions.net
URL will only be seen if an incorrect request path is entered, but it might
be cool to instead redirect it to a different URL \(e.g., a webpage that shows an
error or help/about page)

In the future, I might, instead, maintain a database of redirects in, for example,
a Cloud Storage bucket. However, for now, it's simply an if-else statement.

With that all being said, I will continue to use Google Cloud Platform for much of
my online web services. Better use it now than later; otherwise my $300 free trial
credit will be gone!

\[n1]: There actually is an additional Compute Engine VM, but it's private.
There was also an App Engine app that formerly served my
[web clock](https://webclock.peterjin.org/), but it has been disabled because
I switched to Cloud Functions for the web clock backend.

**Edit 2018-10-07**: Updated URL for cloud function