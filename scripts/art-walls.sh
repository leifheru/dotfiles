#!/usr/bin/env bash
# ─── Art Wallpaper Downloader ───
# Downloads high-quality artwork from official museum APIs
# with full metadata embedded into images.
#
# Sources:
#   met  — Metropolitan Museum of Art  (collectionapi.metmuseum.org)
#   aic  — Art Institute of Chicago    (api.artic.edu)
#
# Dependencies: curl, jq
# Optional:     exiftool (for metadata embedding into images)
#
# Usage: ./art-walls.sh [options] [search_query]
#   -s, --source   met|aic          (default: met)
#   -n, --count    number            (default: 5)
#   -d, --dest     directory         (default: ~/Pictures/walls)
#   -w, --min-width pixels           (default: 1920)
#   -r, --random   download random art (no query needed)
#   -h, --help     show usage

set -euo pipefail

# ── Defaults ──
SOURCE="met"
COUNT=1
DEST="$HOME/Pictures/walls"
MIN_WIDTH=1920
QUERY=""
RANDOM_MODE=false
HISTORY_FILE=""

# ── Colors ──
R='\033[0;31m'   G='\033[0;32m'   Y='\033[0;33m'
B='\033[0;34m'   M='\033[0;35m'   C='\033[0;36m'
W='\033[0;37m'   DIM='\033[2m'    BOLD='\033[1m'
RST='\033[0m'

# ── Helpers ──
info()  { echo -e "${C}▸${RST} $*"; }
ok()    { echo -e "${G}✓${RST} $*"; }
warn()  { echo -e "${Y}⚠${RST} $*"; }
err()   { echo -e "${R}✗${RST} $*" >&2; }
die()   { err "$*"; exit 1; }

usage() {
    cat <<'EOF'
┌─────────────────────────────────────────────┐
│         🎨  Art Wallpaper Downloader        │
│   Download museum art with full metadata    │
└─────────────────────────────────────────────┘

Usage: art-walls.sh [options] [search_query]

Options:
  -s, --source  <met|aic>    Museum source (default: met)
                               met = Metropolitan Museum of Art
                               aic = Art Institute of Chicago
  -n, --count   <N>          Number of artworks to download (default: 5)
  -d, --dest    <dir>        Destination directory (default: ~/Pictures/walls)
  -w, --min-width <px>       Minimum image width in pixels (default: 1920)
  -r, --random               Download random art (no search query needed)
  -h, --help                 Show this help

Examples:
  art-walls.sh --random                        # random art from MET
  art-walls.sh -r -s aic -n 10                 # 10 random from Chicago
  art-walls.sh "monet"                         # search for monet
  art-walls.sh -s aic -n 10 "landscape"        # search Chicago
  art-walls.sh -r -n 20 -d ~/Wallpapers       # 20 random to custom dir
EOF
    exit 0
}

# ── Dependency checks ──
check_deps() {
    for cmd in curl jq; do
        command -v "$cmd" &>/dev/null || die "Missing dependency: $cmd"
    done
    if ! command -v exiftool &>/dev/null; then
        warn "exiftool not found — metadata will NOT be embedded into images"
        warn "Install: sudo zypper in exiftool  (or pacman -S perl-image-exiftool / apt install libimage-exiftool-perl)"
        HAS_EXIFTOOL=false
    else
        HAS_EXIFTOOL=true
    fi
}

# ── Sanitize filename ──
sanitize() {
    echo "$1" | sed 's/[<>:"/\\|?*]/_/g' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//' | head -c 200
}

# ── Parse arguments ──
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--source)   SOURCE="$2"; shift 2 ;;
            -n|--count)    COUNT="$2"; shift 2 ;;
            -d|--dest)     DEST="$2"; shift 2 ;;
            -w|--min-width) MIN_WIDTH="$2"; shift 2 ;;
            -r|--random)   RANDOM_MODE=true; shift ;;
            -h|--help)     usage ;;
            -*)            die "Unknown option: $1" ;;
            *)             QUERY="$1"; shift ;;
        esac
    done
    if [[ -z "$QUERY" && "$RANDOM_MODE" != "true" ]]; then
        die "No search query provided. Use -r for random mode, or -h for help."
    fi
    [[ "$SOURCE" == "met" || "$SOURCE" == "aic" ]] || die "Invalid source: $SOURCE (use 'met' or 'aic')"
}

# ── Download history (dedup) ──
HISTORY_FILE=""

init_history() {
    HISTORY_FILE="${DEST}/.art-walls-history"
    touch "$HISTORY_FILE"
}

is_downloaded() {
    local id="$1"
    grep -qxF "$id" "$HISTORY_FILE" 2>/dev/null
}

record_download() {
    local id="$1"
    echo "$id" >> "$HISTORY_FILE"
}

# ── Write metadata sidecar ──
write_sidecar() {
    local file="$1"
    shift
    # All remaining args are key=value pairs
    {
        echo "═══════════════════════════════════════════"
        echo "  ARTWORK METADATA"
        echo "═══════════════════════════════════════════"
        echo ""
        while [[ $# -gt 0 ]]; do
            local key="${1%%=*}"
            local val="${1#*=}"
            if [[ -n "$val" ]]; then
                printf "  %-16s %s\n" "$key:" "$val"
            fi
            shift
        done
        echo ""
        echo "═══════════════════════════════════════════"
        echo "  Downloaded by art-walls.sh"
        echo "  $(date '+%Y-%m-%d %H:%M:%S')"
        echo "═══════════════════════════════════════════"
    } > "$file"
}

# ── Embed metadata with exiftool ──
embed_metadata() {
    local imgfile="$1" title="$2" artist="$3" description="$4"
    local date="$5" medium="$6" source_url="$7" keywords="$8"

    [[ "$HAS_EXIFTOOL" == "true" ]] || return 0

    local args=(-overwrite_original -ignoreMinorErrors -q)

    [[ -n "$title" ]]       && args+=("-XMP:Title=$title" "-IPTC:ObjectName=$title")
    [[ -n "$artist" ]]      && args+=("-XMP:Creator=$artist" "-IPTC:By-line=$artist")
    [[ -n "$description" ]] && args+=("-XMP:Description=$description" "-IPTC:Caption-Abstract=$description")
    [[ -n "$date" ]]        && args+=("-XMP:DateCreated=$date")
    [[ -n "$medium" ]]      && args+=("-XMP:Format=$medium")
    [[ -n "$source_url" ]]  && args+=("-XMP:Source=$source_url" "-IPTC:Source=$source_url")
    args+=("-XMP:Rights=Public Domain / CC0" "-IPTC:CopyrightNotice=Public Domain / CC0")

    # Handle keywords (comma-separated → multiple tags)
    if [[ -n "$keywords" ]]; then
        IFS=',' read -ra kw_arr <<< "$keywords"
        for kw in "${kw_arr[@]}"; do
            kw="$(echo "$kw" | sed 's/^ *//;s/ *$//')"
            [[ -n "$kw" ]] && args+=("-XMP:Subject+=$kw" "-IPTC:Keywords+=$kw")
        done
    fi

    exiftool "${args[@]}" "$imgfile" 2>/dev/null || true
}

# ══════════════════════════════════════════════
#  METROPOLITAN MUSEUM OF ART
# ══════════════════════════════════════════════

met_search() {
    local query="$1" count="$2"
    local ids

    if [[ "$RANDOM_MODE" == "true" ]]; then
        info "Fetching random art from the Metropolitan Museum..."
        # Use search API with public domain filter to ensure all results have images
        local all_url="https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isPublicDomain=true&q=*"
        local all_result
        all_result=$(curl -s --fail --connect-timeout 15 --max-time 60 "$all_url") || die "MET search API failed"
        local total
        total=$(echo "$all_result" | jq -r '.total // 0')
        info "Pool: ${BOLD}$total${RST} public domain artworks with images"

        # Pick a random slice of IDs, then shuffle that slice
        local fetch_count=$(( count * 10 ))
        local rand_start=$(( (RANDOM * RANDOM) % (total > fetch_count ? total - fetch_count : 1) ))
        ids=$(echo "$all_result" | jq -r ".objectIDs[$rand_start:$rand_start+$fetch_count][]" | shuf)
    else
        info "Searching Metropolitan Museum for: ${BOLD}$query${RST}"
        local encoded_q
        encoded_q=$(jq -rn --arg q "$query" '$q | @uri')
        local search_url="https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isPublicDomain=true&q=${encoded_q}"
        local result
        result=$(curl -s --fail --connect-timeout 15 --max-time 30 "$search_url") || die "MET search API failed"

        local total
        total=$(echo "$result" | jq -r '.total // 0')
        info "Found ${BOLD}$total${RST} results"

        if [[ "$total" -eq 0 ]]; then
            warn "No results found for '$query'"
            return 1
        fi

        local fetch_count=$(( count * 8 ))
        ids=$(echo "$result" | jq -r ".objectIDs[:$fetch_count][]" | shuf | head -n "$fetch_count")
    fi

    local downloaded=0
    while IFS= read -r oid && [[ $downloaded -lt $count ]]; do
        # Skip already-downloaded objects
        if is_downloaded "met:$oid"; then
            continue
        fi
        met_download_object "$oid" && {
            record_download "met:$oid"
            (( downloaded++ ))
        } || true
    done <<< "$ids"

    if [[ $downloaded -eq 0 ]]; then
        warn "No wallpaper-suitable images found (try a broader search or lower --min-width)"
        return 1
    fi

    ok "Downloaded ${BOLD}$downloaded${RST} artworks from the Metropolitan Museum"
}

met_download_object() {
    local oid="$1"
    local obj_url="https://collectionapi.metmuseum.org/public/collection/v1/objects/$oid"
    local obj
    obj=$(curl -s --fail --connect-timeout 10 --max-time 20 "$obj_url" 2>/dev/null) || return 1

    # Check for image
    local img_url
    img_url=$(echo "$obj" | jq -r '.primaryImage // empty')
    [[ -n "$img_url" ]] || return 1

    # Extract metadata
    local title artist date medium department culture period
    local dimensions credit_line obj_url_web classification tags_str
    title=$(echo "$obj" | jq -r '.title // "Untitled"')
    artist=$(echo "$obj" | jq -r '.artistDisplayName // "Unknown Artist"')
    date=$(echo "$obj" | jq -r '.objectDate // ""')
    medium=$(echo "$obj" | jq -r '.medium // ""')
    department=$(echo "$obj" | jq -r '.department // ""')
    culture=$(echo "$obj" | jq -r '.culture // ""')
    period=$(echo "$obj" | jq -r '.period // ""')
    dimensions=$(echo "$obj" | jq -r '.dimensions // ""')
    credit_line=$(echo "$obj" | jq -r '.creditLine // ""')
    obj_url_web=$(echo "$obj" | jq -r '.objectURL // ""')
    classification=$(echo "$obj" | jq -r '.classification // ""')
    tags_str=$(echo "$obj" | jq -r '[.tags[]?.term] | join(", ")' 2>/dev/null || echo "")

    local artist_bio artist_nationality
    artist_bio=$(echo "$obj" | jq -r '.artistDisplayBio // ""')
    artist_nationality=$(echo "$obj" | jq -r '.artistNationality // ""')

    # Build description
    local description=""
    [[ -n "$title" ]]    && description="$title"
    [[ -n "$artist" && "$artist" != "Unknown Artist" ]] && description="$description by $artist"
    [[ -n "$date" ]]     && description="$description ($date)"
    [[ -n "$medium" ]]   && description="$description. $medium"
    [[ -n "$culture" ]]  && description="$description. Culture: $culture"
    [[ -n "$period" ]]   && description="$description. Period: $period"

    # Build filename
    local safe_artist safe_title ext filename
    safe_artist=$(sanitize "$artist")
    safe_title=$(sanitize "$title")
    ext="${img_url##*.}"
    ext="${ext%%\?*}"
    [[ -n "$ext" ]] || ext="jpg"
    ext="${ext,,}"

    if [[ "$safe_artist" == "Unknown Artist" || -z "$safe_artist" ]]; then
        filename="${safe_title}.${ext}"
    else
        filename="${safe_artist} - ${safe_title}.${ext}"
    fi

    # Check if already exists
    if [[ -f "$DEST/$filename" ]]; then
        info "${DIM}Skipping (exists): $filename${RST}"
        return 1
    fi

    # Download
    info "Downloading: ${BOLD}$title${RST} by ${M}$artist${RST}"
    local tmpfile
    tmpfile=$(mktemp "$DEST/.tmp_XXXXXX")
    if ! curl -sL --fail --connect-timeout 15 --max-time 120 -o "$tmpfile" "$img_url" 2>/dev/null; then
        rm -f "$tmpfile"
        return 1
    fi

    # Check image dimensions if `identify` is available
    if command -v identify &>/dev/null; then
        local img_width
        img_width=$(identify -format "%w" "$tmpfile" 2>/dev/null || echo "0")
        if [[ "$img_width" -lt "$MIN_WIDTH" ]]; then
            info "${DIM}  Skipping (${img_width}px < ${MIN_WIDTH}px min width)${RST}"
            rm -f "$tmpfile"
            return 1
        fi
    fi

    mv "$tmpfile" "$DEST/$filename"
    chmod 644 "$DEST/$filename"

    # Embed metadata
    embed_metadata "$DEST/$filename" \
        "$title" "$artist" "$description" "$date" "$medium" "$obj_url_web" "$tags_str"

    # Write sidecar
    local sidecar="${DEST}/${filename%.*}.txt"
    write_sidecar "$sidecar" \
        "Title=$title" \
        "Artist=$artist" \
        "Artist Bio=$artist_bio" \
        "Nationality=$artist_nationality" \
        "Date=$date" \
        "Medium=$medium" \
        "Dimensions=$dimensions" \
        "Classification=$classification" \
        "Department=$department" \
        "Culture=$culture" \
        "Period=$period" \
        "Credit=$credit_line" \
        "Tags=$tags_str" \
        "Source=Metropolitan Museum of Art" \
        "URL=$obj_url_web" \
        "Image URL=$img_url" \
        "License=Public Domain / CC0"

    ok "  Saved: ${BOLD}$filename${RST}"
    [[ "$HAS_EXIFTOOL" == "true" ]] && ok "  ${DIM}Metadata embedded${RST}"
    return 0
}

# ══════════════════════════════════════════════
#  ART INSTITUTE OF CHICAGO
# ══════════════════════════════════════════════

aic_search() {
    local query="$1" count="$2"
    local aic_fields="id,title,image_id,artist_display,date_display,medium_display,dimensions,department_title,classification_title,artwork_type_title,provenance_text,publication_history,exhibition_history,credit_line,place_of_origin,style_title,term_titles,thumbnail"
    local fetch_count=$(( count * 4 ))
    local result

    if [[ "$RANDOM_MODE" == "true" ]]; then
        info "Fetching random art from the Art Institute of Chicago..."
        # Get total count first, then pick a random page
        local count_result
        count_result=$(curl -sg --fail --connect-timeout 15 --max-time 15 "https://api.artic.edu/api/v1/artworks/search?query[term][is_public_domain]=true&limit=0" 2>/dev/null) || die "AIC count API failed"
        local total_available
        total_available=$(echo "$count_result" | jq -r '.pagination.total // 0')
        info "Pool: ${BOLD}$total_available${RST} public domain artworks"

        if [[ "$total_available" -eq 0 ]]; then
            warn "No public domain artworks available"
            return 1
        fi

        # Pick a random page (AIC limits deep pagination to 10000)
        local max_offset=$(( total_available < 10000 ? total_available : 10000 ))
        local rand_page=$(( (RANDOM * RANDOM) % (max_offset / fetch_count + 1) + 1 ))
        result=$(curl -sg --fail --connect-timeout 15 --max-time 30 "https://api.artic.edu/api/v1/artworks/search?query[term][is_public_domain]=true&fields=${aic_fields}&limit=${fetch_count}&page=${rand_page}" 2>/dev/null) || die "AIC search API failed"
    else
        info "Searching Art Institute of Chicago for: ${BOLD}$query${RST}"
        local encoded_q
        encoded_q=$(jq -rn --arg q "$query" '$q | @uri')
        result=$(curl -sg --fail --connect-timeout 15 --max-time 30 "https://api.artic.edu/api/v1/artworks/search?q=${encoded_q}&query[term][is_public_domain]=true&fields=${aic_fields}&limit=${fetch_count}" 2>/dev/null) || die "AIC search API failed"
    fi

    local total
    total=$(echo "$result" | jq -r '.pagination.total // 0')
    [[ "$RANDOM_MODE" != "true" ]] && info "Found ${BOLD}$total${RST} results"

    if [[ "$total" -eq 0 ]]; then
        warn "No results found"
        return 1
    fi

    # Get the config for IIIF base URL
    local iiif_base
    iiif_base=$(echo "$result" | jq -r '.config.iiif_url // "https://www.artic.edu/iiif/2"')

    local downloaded=0
    local data_len
    data_len=$(echo "$result" | jq -r '.data | length')

    for (( i=0; i<data_len && downloaded<count; i++ )); do
        local item
        item=$(echo "$result" | jq -r ".data[$i]")

        local image_id artwork_id
        image_id=$(echo "$item" | jq -r '.image_id // empty')
        artwork_id=$(echo "$item" | jq -r '.id // empty')
        [[ -n "$image_id" && "$image_id" != "null" ]] || continue

        # Skip already-downloaded objects
        if is_downloaded "aic:$artwork_id"; then
            continue
        fi

        aic_download_artwork "$item" "$iiif_base" "$image_id" "$artwork_id" && {
            record_download "aic:$artwork_id"
            (( downloaded++ ))
        } || true
    done

    if [[ $downloaded -eq 0 ]]; then
        warn "No wallpaper-suitable images found (try a broader search or lower --min-width)"
        return 1
    fi

    ok "Downloaded ${BOLD}$downloaded${RST} artworks from the Art Institute of Chicago"
}

aic_download_artwork() {
    local item="$1" iiif_base="$2" image_id="$3" artwork_id="$4"

    # Build IIIF URL — use max available size for public domain
    # full/max means the server decides the largest available
    local img_url="${iiif_base}/${image_id}/full/1686,/0/default.jpg"

    # Extract metadata
    local title artist date medium department classification
    local origin style dimensions credit_line provenance
    local terms_str thumbnail_alt
    title=$(echo "$item" | jq -r '.title // "Untitled"')
    artist=$(echo "$item" | jq -r '.artist_display // "Unknown Artist"')
    date=$(echo "$item" | jq -r '.date_display // ""')
    medium=$(echo "$item" | jq -r '.medium_display // ""')
    department=$(echo "$item" | jq -r '.department_title // ""')
    classification=$(echo "$item" | jq -r '.classification_title // ""')
    origin=$(echo "$item" | jq -r '.place_of_origin // ""')
    style=$(echo "$item" | jq -r '.style_title // ""')
    dimensions=$(echo "$item" | jq -r '.dimensions // ""')
    credit_line=$(echo "$item" | jq -r '.credit_line // ""')
    provenance=$(echo "$item" | jq -r '.provenance_text // ""')
    terms_str=$(echo "$item" | jq -r '[.term_titles[]?] | join(", ")' 2>/dev/null || echo "")
    thumbnail_alt=$(echo "$item" | jq -r '.thumbnail.alt_text // ""')

    # Check thumbnail dims for early filtering
    local thumb_w
    thumb_w=$(echo "$item" | jq -r '.thumbnail.width // 0')
    if [[ "$thumb_w" != "null" && "$thumb_w" -gt 0 && "$thumb_w" -lt "$MIN_WIDTH" ]]; then
        return 1
    fi

    # Build description
    local description="$title"
    [[ -n "$artist" && "$artist" != "Unknown Artist" ]] && description="$description by $artist"
    [[ -n "$date" ]] && description="$description ($date)"
    [[ -n "$medium" ]] && description="$description. $medium"
    [[ -n "$origin" ]] && description="$description. Origin: $origin"
    [[ -n "$thumbnail_alt" ]] && description="$description. $thumbnail_alt"

    local obj_url_web="https://www.artic.edu/artworks/${artwork_id}"

    # Build filename — extract just the first line of artist (AIC has multi-line)
    local artist_first
    artist_first=$(echo "$artist" | head -1 | sed 's/[[:space:]]*$//')
    local safe_artist safe_title filename
    safe_artist=$(sanitize "$artist_first")
    safe_title=$(sanitize "$title")

    if [[ "$safe_artist" == "Unknown Artist" || -z "$safe_artist" ]]; then
        filename="${safe_title}.jpg"
    else
        filename="${safe_artist} - ${safe_title}.jpg"
    fi

    # Check if already exists
    if [[ -f "$DEST/$filename" ]]; then
        info "${DIM}Skipping (exists): $filename${RST}"
        return 1
    fi

    # Download
    info "Downloading: ${BOLD}$title${RST} by ${M}$artist_first${RST}"
    local tmpfile
    tmpfile=$(mktemp "$DEST/.tmp_XXXXXX")
    if ! curl -sL --fail --connect-timeout 15 --max-time 120 -o "$tmpfile" "$img_url" 2>/dev/null; then
        rm -f "$tmpfile"
        return 1
    fi

    # Verify it's not an error / too small
    local fsize
    fsize=$(stat -c%s "$tmpfile" 2>/dev/null || echo "0")
    if [[ "$fsize" -lt 10000 ]]; then
        rm -f "$tmpfile"
        return 1
    fi

    mv "$tmpfile" "$DEST/$filename"
    chmod 644 "$DEST/$filename"

    # Embed metadata
    embed_metadata "$DEST/$filename" \
        "$title" "$artist_first" "$description" "$date" "$medium" "$obj_url_web" "$terms_str"

    # Write sidecar
    local sidecar="${DEST}/${filename%.*}.txt"
    write_sidecar "$sidecar" \
        "Title=$title" \
        "Artist=$artist" \
        "Date=$date" \
        "Medium=$medium" \
        "Dimensions=$dimensions" \
        "Classification=$classification" \
        "Department=$department" \
        "Origin=$origin" \
        "Style=$style" \
        "Credit=$credit_line" \
        "Provenance=$provenance" \
        "Tags=$terms_str" \
        "Description=$thumbnail_alt" \
        "Source=Art Institute of Chicago" \
        "URL=$obj_url_web" \
        "Image URL=$img_url" \
        "License=Public Domain / CC0"

    ok "  Saved: ${BOLD}$filename${RST}"
    [[ "$HAS_EXIFTOOL" == "true" ]] && ok "  ${DIM}Metadata embedded${RST}"
    return 0
}

# ══════════════════════════════════════════════
#  MAIN
# ══════════════════════════════════════════════

main() {
    parse_args "$@"
    check_deps

    echo ""
    echo -e "${BOLD}┌─────────────────────────────────────────────┐${RST}"
    echo -e "${BOLD}│         🎨  Art Wallpaper Downloader        │${RST}"
    echo -e "${BOLD}└─────────────────────────────────────────────┘${RST}"
    echo ""
    info "Source:    ${BOLD}$SOURCE${RST}"
    if [[ "$RANDOM_MODE" == "true" ]]; then
        info "Mode:      ${BOLD}🎲 Random${RST}"
    else
        info "Query:     ${BOLD}$QUERY${RST}"
    fi
    info "Count:     ${BOLD}$COUNT${RST}"
    info "Min width: ${BOLD}${MIN_WIDTH}px${RST}"
    info "Dest:      ${BOLD}$DEST${RST}"
    echo ""

    mkdir -p "$DEST"
    init_history

    local history_count
    history_count=$(wc -l < "$HISTORY_FILE" 2>/dev/null || echo 0)
    [[ "$history_count" -gt 0 ]] && info "${DIM}History: $history_count previously downloaded (will skip)${RST}"

    case "$SOURCE" in
        met) met_search "$QUERY" "$COUNT" ;;
        aic) aic_search "$QUERY" "$COUNT" ;;
    esac

    echo ""
    ok "All done! Wallpapers saved to: ${BOLD}$DEST${RST}"
}

main "$@"
