#!/QOpenSys/pkgs/bin/bash
# =============================================================================
# deploy_to_qsys.sh
# =============================================================================
# PURPOSE
#   Create (if needed) a SAMSRCn library on IBM i, create all standard source
#   physical files inside it, then copy every source member from the IFS
#   workspace into the matching QSYS source member.
#
#   Intended use: run once per developer / environment to seed a native IBM i
#   development library so teams can work directly with SEU, RDi, or VS Code.
#
# USAGE
#   bash deploy_to_qsys.sh [OPTIONS]
#
# OPTIONS
#   -l, --library  <LIB>   Target library name (default: SAMSRC1)
#   -b, --base     <PATH>  IFS root of the SAMCO project folder
#                          (default: auto-detected from script location)
#   -d, --dry-run          Print actions without executing them
#   -v, --verbose          Show CL command output for every copy
#   -h, --help             Show this help message
#
# EXAMPLES
#   bash deploy_to_qsys.sh
#   bash deploy_to_qsys.sh --library SAMSRC2
#   bash deploy_to_qsys.sh --library SAMSRC2 --base /home/myuser/projects/SAMCO
#   bash deploy_to_qsys.sh --dry-run
#
# NOTES
#   - Member name  = filename prefix before the first '-' or '.',
#                    uppercased and truncated to 10 characters.
#   - Source type  = last extension of the filename (e.g. SQLRPGLE, DSPF, PF).
#   - CCSID        : IFS files are read as UTF-8 (1208) and written as EBCDIC 37.
#   - Non-source files (Rules.mk, *.md, *.json, README.*, POPULATE_*) are skipped.
#   - Script is idempotent: re-running replaces existing members (*REPLACE).
#
# MEMBER NAME MAPPING EXAMPLES
#   ART200-Work_with_article.PGM.SQLRPGLE  -> QRPGLESRC/ART200  (SQLRPGLE)
#   ART200D-Work_with_Article.DSPF         -> QDDSSRC/ART200D   (DSPF)
#   ARTICLE-Article_File.PF                -> QDDSSRC/ARTICLE   (PF)
#   APICALL-Prototypes_for_Ibm_API.RPGLEINC-> QPROTOSRC/APICALL (RPGLEINC)
#   LOG_functions.RPGLEINC                 -> QPROTOSRC/LOG_FUNC (RPGLEINC)
#   ORD100C.PGM.CLLE                       -> QCLSRC/ORD100C    (CLLE)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_BASE="$(dirname "$SCRIPT_DIR")/SAMCO"   # <project_root>/SAMCO

LIB="SAMSRC1"
BASE="$DEFAULT_BASE"
DRY_RUN=false
VERBOSE=false

ERRORS=0
COPIED=0
SKIPPED=0

# ---------------------------------------------------------------------------
# Colours (disabled when not a terminal)
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; RESET=''
fi

# ---------------------------------------------------------------------------
# Helper: usage
# ---------------------------------------------------------------------------
usage() {
  sed -n '/#.*USAGE/,/^#.*NOTES/p' "$0" | grep '^#' | sed 's/^# \?//'
  exit 0
}

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--library) LIB=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift 2 ;;   # force uppercase
    -b|--base)    BASE="$2";    shift 2 ;;
    -d|--dry-run) DRY_RUN=true; shift   ;;
    -v|--verbose) VERBOSE=true; shift   ;;
    -h|--help)    usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

# ---------------------------------------------------------------------------
# Validate
# ---------------------------------------------------------------------------
if [[ ! -d "$BASE" ]]; then
  echo -e "${RED}ERROR: Base directory not found: $BASE${RESET}" >&2
  echo "       Use --base to specify the SAMCO project folder." >&2
  exit 1
fi

if [[ ${#LIB} -gt 10 ]]; then
  echo -e "${RED}ERROR: Library name '$LIB' exceeds 10 characters.${RESET}" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Helper: derive member name from filename
#   Strip description after first '-', then after first '.'
#   Uppercase, truncate to 10 chars
# ---------------------------------------------------------------------------
mbr_name() {
  local f="$1"
  local base="${f%%-*}"   # strip from first '-' (removes descriptions)
  base="${base%%.*}"       # strip from first '.' (handles no-dash filenames)
  echo "$base" | tr '[:lower:]' '[:upper:]' | cut -c1-10
}

# ---------------------------------------------------------------------------
# Helper: derive source type from last extension
# ---------------------------------------------------------------------------
src_type() {
  local f="$1"
  echo "${f##*.}" | tr '[:lower:]' '[:upper:]'
}

# ---------------------------------------------------------------------------
# Helper: decide whether a filename should be skipped (non-source)
#   Returns 0 (true) if the file should be skipped
# ---------------------------------------------------------------------------
skip_file() {
  case "$1" in
    Rules.mk|Rules.mk.*|*.md|*.json|readme.*|README.*|POPULATE_*|.DS_Store|.ibmi.json) return 0 ;;
    *) return 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Helper: copy one IFS stream file into a QSYS source member
# ---------------------------------------------------------------------------
copy_member() {
  local ifs_file="$1"
  local srcpf="$2"
  local filename
  filename=$(basename "$ifs_file")
  local mbr
  mbr=$(mbr_name "$filename")
  local stype
  stype=$(src_type "$filename")
  local qsys_path="/QSYS.LIB/${LIB}.LIB/${srcpf}.FILE/${mbr}.MBR"

  printf "  %-14s %-12s %-12s\n" "${srcpf}" "${mbr}" "(${stype})"

  if $DRY_RUN; then
    COPIED=$((COPIED + 1))
    return
  fi

  # Create member (ADDPFM); silently ignore if already exists
  system "QSYS/ADDPFM FILE(${LIB}/${srcpf}) MBR(${mbr}) SRCTYPE(${stype})" \
    > /dev/null 2>&1 || true

  # Copy stream file -> source member
  local out
  out=$(system "QSYS/CPYFRMSTMF FROMSTMF('${ifs_file}') TOMBR('${qsys_path}') \
    MBROPT(*REPLACE) STMFCCSID(1208) DBFCCSID(37)" 2>&1)
  local rc=$?

  if [ $rc -ne 0 ]; then
    echo -e "    ${RED}*** ERROR: ${out}${RESET}"
    ERRORS=$((ERRORS + 1))
  else
    $VERBOSE && echo "    ${out}"
    COPIED=$((COPIED + 1))
  fi
}

# ---------------------------------------------------------------------------
# Helper: process an entire source folder
#   process_folder <IFS_FOLDER> <SRCPF> <EXT1> [EXT2 ...]
# ---------------------------------------------------------------------------
process_folder() {
  local folder="$1"
  local srcpf="$2"
  shift 2
  local extensions=("$@")

  # Folder may not exist in this workspace (e.g. QIWSSRC on some clones)
  if [[ ! -d "$folder" ]]; then
    echo -e "  ${YELLOW}(skipping — folder not found: $folder)${RESET}"
    return
  fi

  local found=false
  for f in "$folder"/*; do
    [[ -f "$f" ]] || continue
    local fname
    fname=$(basename "$f")

    # Skip non-source files
    skip_file "$fname" && { SKIPPED=$((SKIPPED + 1)); continue; }

    # Check extension match
    local ext="${fname##*.}"
    local ext_upper
    ext_upper=$(echo "$ext" | tr '[:lower:]' '[:upper:]')
    local match=false
    for e in "${extensions[@]}"; do
      if [[ "$(echo "$e" | tr '[:lower:]' '[:upper:]')" == "$ext_upper" ]]; then
        match=true
        break
      fi
    done

    $match || { SKIPPED=$((SKIPPED + 1)); continue; }

    found=true
    copy_member "$f" "$srcpf"
  done

  $found || echo -e "  ${YELLOW}(no matching source files found)${RESET}"
}

# ---------------------------------------------------------------------------
# Step 1 — Ensure library exists
# ---------------------------------------------------------------------------
ensure_library() {
  echo -e "${BOLD}[1/3] Library: ${LIB}${RESET}"

  if $DRY_RUN; then
    echo -e "  ${CYAN}(dry-run) Would create library ${LIB} if it does not exist${RESET}"
    return
  fi

  # Check if library exists; create if not
  if system "QSYS/CHKOBJ OBJ(QSYS/${LIB}) OBJTYPE(*LIB)" > /dev/null 2>&1; then
    echo -e "  ${GREEN}Library ${LIB} already exists — skipping creation${RESET}"
  else
    echo "  Creating library ${LIB}..."
    system "QSYS/CRTLIB LIB(${LIB}) TYPE(*PROD) \
      TEXT('SAMCO Application Source - Dev on IBM i') \
      AUT(*EXCLUDE)" > /dev/null
    echo -e "  ${GREEN}Library ${LIB} created${RESET}"
  fi
}

# ---------------------------------------------------------------------------
# Step 2 — Ensure all source physical files exist
# ---------------------------------------------------------------------------
ensure_srcpfs() {
  echo -e "${BOLD}[2/3] Source physical files in ${LIB}${RESET}"

  # Map: srcpf -> description
  declare -A SRCPF_DESC=(
    [QRPGLESRC]="RPG ILE Source"
    [QPROTOSRC]="RPG Prototypes and Includes"
    [QDDSSRC]="DDS Source"
    [QCLSRC]="CL Source"
    [QSQLSRC]="SQL Source"
    [QSRVSRC]="Binder Source"
    [QBNDSRC]="Binding Directory Source"
    [QCBLSRC]="COBOL Source"
    [QCMDSRC]="Command Source"
    [QCPPSRC]="C++ Source"
    [QCSRC]="C Source"
    [QDTASRC]="Data Area and Queue Source"
    [QILESRC]="ILE Program Build Source"
    [QILESRVSRC]="ILE Service Program Build Source"
    [QIWSSRC]="IWS Web Service Source"
    [QMSGSRC]="Message File Source"
    [QPNLSRC]="Panel Group and Menu Source"
    [QRPGSRC]="OPM RPG Source"
    [QSQLCPPSRC]="SQL C++ Source"
    [QSQLCSRC]="SQL C Source"
    [QTRGSRC]="SQL Trigger Source"
    [QTESTSRC]="RPGUnit Test Cases"
  )

  for srcpf in QRPGLESRC QPROTOSRC QDDSSRC QCLSRC QSQLSRC QSRVSRC QBNDSRC \
               QCBLSRC QCMDSRC QCPPSRC QCSRC QDTASRC QILESRC QILESRVSRC \
               QIWSSRC QMSGSRC QPNLSRC QRPGSRC QSQLCPPSRC QSQLCSRC QTRGSRC \
               QTESTSRC; do
    if $DRY_RUN; then
      printf "  %-14s  ${CYAN}(dry-run) Would create if absent${RESET}\n" "$srcpf"
      continue
    fi

    # Check if source PF already exists
    if system "QSYS/CHKOBJ OBJ(${LIB}/${srcpf}) OBJTYPE(*FILE)" > /dev/null 2>&1; then
      printf "  %-14s  ${GREEN}already exists${RESET}\n" "$srcpf"
    else
      local desc="${SRCPF_DESC[$srcpf]:-Source Physical File}"
      system "QSYS/CRTSRCPF FILE(${LIB}/${srcpf}) RCDLEN(112) \
        TEXT('${desc}') AUT(*EXCLUDE)" > /dev/null
      printf "  %-14s  ${GREEN}created${RESET}\n" "$srcpf"
    fi
  done
}

# ---------------------------------------------------------------------------
# Step 3 — Populate members from IFS
# ---------------------------------------------------------------------------
populate_members() {
  echo -e "${BOLD}[3/3] Copying source members into ${LIB}${RESET}"
  echo ""
  printf "  ${BOLD}%-14s %-12s %-12s${RESET}\n" "SRCPF" "MEMBER" "TYPE"
  printf "  %s\n" "$(printf '%0.s-' {1..40})"

  # ---- QRPGLESRC (ILE RPG / SQL RPG) ------------------------------------
  echo -e "\n  ${CYAN}[ QRPGLESRC ]${RESET}"
  process_folder "$BASE/QRPGLESRC" "QRPGLESRC" \
    RPGLE SQLRPGLE RPGLEINC

  # ---- QPROTOSRC (shared prototypes / copybooks) -------------------------
  echo -e "\n  ${CYAN}[ QPROTOSRC ]${RESET}"
  process_folder "$BASE/QPROTOSRC" "QPROTOSRC" \
    RPGLEINC rpgleinc

  # ---- QDDSSRC (DDS — display, physical, logical, printer files) ---------
  echo -e "\n  ${CYAN}[ QDDSSRC ]${RESET}"
  process_folder "$BASE/QDDSSRC" "QDDSSRC" \
    DSPF PF LF PRTF

  # ---- QCLSRC (CL programs) ----------------------------------------------
  echo -e "\n  ${CYAN}[ QCLSRC ]${RESET}"
  process_folder "$BASE/QCLSRC" "QCLSRC" \
    CLP CLLE CL

  # ---- QSQLSRC (SQL objects: procedures, views, UDFs, triggers ...) ------
  echo -e "\n  ${CYAN}[ QSQLSRC ]${RESET}"
  process_folder "$BASE/QSQLSRC" "QSQLSRC" \
    SQLPRC VIEW TABLE SQLUDF SQLTRG SQLSEQ sqlvar SQL

  # ---- QSRVSRC (binder language source .BND) -----------------------------
  echo -e "\n  ${CYAN}[ QSRVSRC ]${RESET}"
  process_folder "$BASE/QSRVSRC" "QSRVSRC" \
    BND

  # ---- QBNDSRC (binding directory source) --------------------------------
  echo -e "\n  ${CYAN}[ QBNDSRC ]${RESET}"
  process_folder "$BASE/QBNDSRC" "QBNDSRC" \
    BNDDIR

  # ---- QCBLSRC (COBOL) ---------------------------------------------------
  echo -e "\n  ${CYAN}[ QCBLSRC ]${RESET}"
  process_folder "$BASE/QCBLSRC" "QCBLSRC" \
    CBLLE SQLCBLLE CBL

  # ---- QCMDSRC (command definitions) ------------------------------------
  echo -e "\n  ${CYAN}[ QCMDSRC ]${RESET}"
  process_folder "$BASE/QCMDSRC" "QCMDSRC" \
    CMD CMDSRC

  # ---- QCPPSRC (C++) -----------------------------------------------------
  echo -e "\n  ${CYAN}[ QCPPSRC ]${RESET}"
  process_folder "$BASE/QCPPSRC" "QCPPSRC" \
    CPP

  # ---- QCSRC (C) ---------------------------------------------------------
  echo -e "\n  ${CYAN}[ QCSRC ]${RESET}"
  process_folder "$BASE/QCSRC" "QCSRC" \
    C

  # ---- QDTASRC (data area / data queue source) ---------------------------
  echo -e "\n  ${CYAN}[ QDTASRC ]${RESET}"
  process_folder "$BASE/QDTASRC" "QDTASRC" \
    DTAARA DTAQ

  # ---- QILESRC (ILE program build source) --------------------------------
  echo -e "\n  ${CYAN}[ QILESRC ]${RESET}"
  process_folder "$BASE/QILESRC" "QILESRC" \
    ILEPGM

  # ---- QILESRVSRC (ILE service program build source) ---------------------
  echo -e "\n  ${CYAN}[ QILESRVSRC ]${RESET}"
  process_folder "$BASE/QILESRVSRC" "QILESRVSRC" \
    ILESRVPGM

  # ---- QIWSSRC (IWS web service XML descriptors) -------------------------
  echo -e "\n  ${CYAN}[ QIWSSRC ]${RESET}"
  process_folder "$BASE/QIWSSRC" "QIWSSRC" \
    xml XML

  # ---- QMSGSRC (message file source) ------------------------------------
  echo -e "\n  ${CYAN}[ QMSGSRC ]${RESET}"
  process_folder "$BASE/QMSGSRC" "QMSGSRC" \
    MSGF

  # ---- QPNLSRC (panel groups, menus, workstation customisation) ----------
  echo -e "\n  ${CYAN}[ QPNLSRC ]${RESET}"
  process_folder "$BASE/QPNLSRC" "QPNLSRC" \
    PNLGRPSRC MENUSRC wscstsrc WSCSTSRC

  # ---- common/ (SAMREF reference PF) --------------------------------------
  echo -e "\n  ${CYAN}[ common/ -> QDDSSRC ]${RESET}"
  process_folder "$BASE/common" "QDDSSRC" \
    PF

  # ---- functionsVAT/ — files route to multiple source files ---------------
  echo -e "\n  ${CYAN}[ functionsVAT/ -> QDDSSRC (PF) ]${RESET}"
  process_folder "$BASE/functionsVAT" "QDDSSRC" \
    PF
  echo -e "\n  ${CYAN}[ functionsVAT/ -> QRPGLESRC (RPGLE) ]${RESET}"
  process_folder "$BASE/functionsVAT" "QRPGLESRC" \
    RPGLE
  echo -e "\n  ${CYAN}[ functionsVAT/ -> QPROTOSRC (RPGLEINC) ]${RESET}"
  process_folder "$BASE/functionsVAT" "QPROTOSRC" \
    RPGLEINC
  echo -e "\n  ${CYAN}[ functionsVAT/ -> QSRVSRC (BND) ]${RESET}"
  process_folder "$BASE/functionsVAT" "QSRVSRC" \
    BND

  # ---- includes/ (shared CL copybooks) ------------------------------------
  echo -e "\n  ${CYAN}[ includes/ -> QCLSRC (CLLE) ]${RESET}"
  process_folder "$BASE/includes" "QCLSRC" \
    CLLE CL CLP

  # ---- globalization/ — language sub-folders → QRPGLESRC ------------------
  echo -e "\n  ${CYAN}[ globalization/CHS/ -> QRPGLESRC ]${RESET}"
  process_folder "$BASE/globalization/CHS" "QRPGLESRC" \
    RPGLE SQLRPGLE
  echo -e "\n  ${CYAN}[ globalization/DEU/ -> QRPGLESRC ]${RESET}"
  process_folder "$BASE/globalization/DEU" "QRPGLESRC" \
    RPGLE SQLRPGLE
  echo -e "\n  ${CYAN}[ globalization/HEB/ -> QRPGLESRC ]${RESET}"
  process_folder "$BASE/globalization/HEB" "QRPGLESRC" \
    RPGLE SQLRPGLE

  # ---- QRPGSRC (OPM RPG) -------------------------------------------------
  echo -e "\n  ${CYAN}[ QRPGSRC ]${RESET}"
  process_folder "$BASE/QRPGSRC" "QRPGSRC" \
    RPG

  # ---- QSQLCPPSRC (SQL C++) ----------------------------------------------
  echo -e "\n  ${CYAN}[ QSQLCPPSRC ]${RESET}"
  process_folder "$BASE/QSQLCPPSRC" "QSQLCPPSRC" \
    SQLCPP

  # ---- QSQLCSRC (SQL C) --------------------------------------------------
  echo -e "\n  ${CYAN}[ QSQLCSRC ]${RESET}"
  process_folder "$BASE/QSQLCSRC" "QSQLCSRC" \
    SQLC

  # ---- QTRGSRC (SQL trigger source) -------------------------------------
  echo -e "\n  ${CYAN}[ QTRGSRC ]${RESET}"
  process_folder "$BASE/QTRGSRC" "QTRGSRC" \
    SYSTRG

  # ---- QTESTSRC (RPGUnit test suites — lowercase folder name) ------------
  echo -e "\n  ${CYAN}[ QTESTSRC ]${RESET}"
  # Try both qtestsrc (local workspace case) and QTESTSRC (IFS)
  local testsrc_dir="$BASE/qtestsrc"
  [[ -d "$testsrc_dir" ]] || testsrc_dir="$BASE/QTESTSRC"
  process_folder "$testsrc_dir" "QTESTSRC" \
    RPGLE SQLRPGLE
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}============================================================${RESET}"
echo -e "${BOLD}  SAMCO → IBM i QSYS Deployment Script${RESET}"
echo -e "${BOLD}============================================================${RESET}"
echo -e "  Library  : ${CYAN}${LIB}${RESET}"
echo -e "  Base dir : ${CYAN}${BASE}${RESET}"
$DRY_RUN && echo -e "  Mode     : ${YELLOW}DRY RUN — no changes will be made${RESET}"
echo ""

ensure_library
echo ""
ensure_srcpfs
echo ""
populate_members

echo ""
echo -e "${BOLD}============================================================${RESET}"
if [ $ERRORS -gt 0 ]; then
  echo -e "  ${RED}COMPLETED WITH ERRORS${RESET}"
else
  echo -e "  ${GREEN}COMPLETED SUCCESSFULLY${RESET}"
fi
echo -e "  Copied : ${GREEN}${COPIED}${RESET}"
echo -e "  Skipped: ${YELLOW}${SKIPPED}${RESET}"
echo -e "  Errors : ${RED}${ERRORS}${RESET}"
echo -e "${BOLD}============================================================${RESET}"
echo ""

exit $ERRORS
