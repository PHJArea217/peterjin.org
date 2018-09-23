#!/bin/sh -e

OUTPUT_DIR="public/blog/"
BLOG_POSTS_DIR="blog-posts/"
DISQUS_BASE_URL="https://www.peterjin.org/"

mkdir -p "$OUTPUT_DIR"

sed_text() {
	sed -n '/^<!-- BEGIN '"$1"' -->$/,/^<!-- END '"$1"' -->$/p' "$2"
}

insert_disqus_comments() {
	cat <<EOF
<script>
var disqus_config = function () {
	this.page.url = "$DISQUS_BASE_URL${OUTPUT_DIR##public/}/$1.html"
	this.page.identifier = "$1"
}
</script>
EOF
}

sed_text HEADER blog-template.html > "$OUTPUT_DIR/index.html"

BP_TEMP_FILE="$(mktemp)"
[ -f "$BP_TEMP_FILE" ]

for x in "$BLOG_POSTS_DIR"/*.md; do
	OUTPUT_FILE="${x##*/}"
	OUTPUT_FILE="${OUTPUT_FILE%%.md}.html"
	sed -n 1p "$x" | (IFS='|' read BP_DATE BP_SORTKEY BP_RESV1 BP_RESV2 BP_SUBJECT;
		if [ "${BP_DATE##X}" != "${BP_DATE}" ]; then
			exit 0
		fi
		printf '<!-- %s --><li><a href="%s">%s: %s</a></li>\n' "$BP_SORTKEY" "$OUTPUT_FILE" "$BP_DATE" "$BP_SUBJECT" >> "$BP_TEMP_FILE"	
		
		# saves redirection required on every line following
		exec > "$OUTPUT_DIR/$OUTPUT_FILE"
		
		sed_text HEADER blogpost-template.html
		printf '<title>%s - www.peterjin.org</title>\n' "$BP_SUBJECT"
		sed_text POSTHEADER blogpost-template.html
		insert_disqus_comments "${OUTPUT_FILE%%.html}"
		printf '<div id="blogpost-subject">%s</div><hr />\n' "$BP_SUBJECT"
		printf '<p class="blogpost-creation-date">%s</p>' "$(date -d $BP_DATE +'%d %B %Y')"
		printf '<div id="blogpost-content">\n'
		sed -n '2,$p' "$x" | markdown
		printf '</div>\n'
		sed_text FOOTER blogpost-template.html
	)
done

sort -r "$BP_TEMP_FILE" >> "$OUTPUT_DIR/index.html"

sed_text FOOTER blog-template.html >> "$OUTPUT_DIR/index.html"