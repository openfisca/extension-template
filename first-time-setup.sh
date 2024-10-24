#!/bin/bash

# @description Check if a value is false.
# @arg $1 The value to check.
is::false() {
  case "${1:-}" in
  '' | 0 | [Nn] | [Nn][Oo] | [Ff][Aa][Ll][Ss][Ee]) echo true ;;
  *) echo false ;;
  esac
}

# @description Check if a value is true.
# @arg $1 The value to check.
is::true() {
  [[ $(is::false "${1}") == 'false' ]] && echo true || echo false
}

# @internal
colour.task() {
  echo -n "$(tput setaf 5)"
}

# @internal
colour.user() {
  echo -n "$(tput setaf 4)"
}

# @internal
colour.pass() {
  echo -n "$(tput setaf 6)"
}

# @internal
colour.warn() {
  echo -n "$(tput setaf 3)"
}

# @internal
colour.fail() {
  echo -n "$(tput setaf 1)"
}

# @internal
colour.done() {
  echo -n "$(tput setaf 2)"
}

# @internal
colour.info() {
  echo -n "$(tput setaf 7)"
}

# @internal
colour.logs() {
  echo -n "$(tput setaf 7)"
}

# @internal
colour.bold() {
  echo -n "$(tput bold)"
}

# @internal
colour.undl() {
  echo -n "$(tput sgr 0 1)"
}

# @internal
colour.none() {
  echo -n "$(tput sgr0)"
}

# @description Coloring task messages.
# @arg $1 string A value to colorise.
colour::task() {
  echo -e "$(colour.task)[⚙] $(colour.undl)$(colour.task)${1}$(colour.none)"
}

# @description Coloring user prompts.
# @arg $1 string A value to colorise.
colour::user() {
  echo -e "$(colour.user)[❯] ${1}$(colour.none)"
}

# @description Coloring work-in-progress operations.
# @arg $1 string A value to colorise.
colour::pass() {
  echo -e "$(colour.pass)[λ] ${1}$(colour.none)"
}

# @description Coloring warnings.
# @arg $1 string A value to colorise.
colour::warn() {
  echo -e "$(colour.warn)[!] ${1}$(colour.none)"
}

# @description Coloring failed operations.
# @arg $1 string A value to colorise.
colour::fail() {
  echo -e "$(colour.fail)[x] ${1}$(colour.none)"
}

# @description Coloring finished operations.
# @arg $1 string A value to colorise.
colour::done() {
  echo -e "$(colour.done)[✓] ${1}$(colour.none)"
}

# @description Coloring information messages.
# @arg $1 string A value to colorise.
colour::info() {
  echo -e "$(colour.info)[i] $(colour.bold)${1}$(colour.none)"
}

# @description Coloring logs.
# @arg $1 string A value to colorise.
colour::logs() {
  # shellcheck disable=SC1111
  echo -e "$(colour.logs) =  “${1}”$(colour.none)"
}

# @description Get the line number of a text in a file.
# @arg $1 The file to read.
# @arg $2 The text to search for.
file::find_lineno() {
  local lineno=0
  local line
  while IFS= read -r line || [[ -n ${line} ]]; do
    ((lineno++))
    if [[ ${line} == "${2}" ]]; then
      echo "${lineno}"
      return
    fi
  done <"${1}"
  echo -1
}

# @internal
string.decode.a() {
  echo "${1}" | sed 'y/āáǎàâãäåĀÁǍÀÂÃÄÅ/aaaaaaaaAAAAAAAA/'
}

# @internal
string.decode.e() {
  echo "${1}" | sed 'y/ēéěèêëĒÉĚÈÊË/eeeeeeEEEEEE/'
}

# @internal
string.decode.i() {
  echo "${1}" | sed 'y/īíǐìîïĪÍǏÌÎÏ/iiiiiiIIIIII/'
}

# @internal
string.decode.o() {
  echo "${1}" | sed 'y/ōóǒòôõöŌÓǑÒÔÕÖ/oooooooOOOOOOO/'
}

# @internal
string.decode.u() {
  echo "${1}" | sed 'y/ūúǔùûüǖǘǚǜŪÚǓÙÛÜǕǗǙǛ/uuuuuuuuuuUUUUUUUUUU/'
}

# @description Convert a string to lowercase.
# @arg $1 The string to convert.
string::lower() {
  echo "${1}" | tr '[:upper:]' '[:lower:]'
}

# @description Decode a string to ASCII.
# @arg $1 The string to decode.
string::decode() {
  local string="${1}"
  local -r fx=(
    string.decode.a
    string.decode.e
    string.decode.i
    string.decode.o
    string.decode.u
  )
  local fn
  for fn in "${fx[@]}"; do string=$("${fn}" "${string}"); done
  echo "${string}"
}

# @description Remove special characters from a string.
# @arg $1 The string to clean.
string::sanitise() {
  echo "${1}" |
    sed -r 's/[\"'\''«»“”„‟‹›]+/-/g' |
    sed -r 's/[^a-zA-Z _-]+//g'
}

# @description Remove spaces from a string.
# @arg $1 The string to clean.
string::trim() {
  echo "${1}" | sed -r 's/[ ]+/_/g'
}

# @description Convert a string to snake case.
# @arg $1 The string to convert.
string::snake() {
  echo "${1}" | sed -r 's/[-]+/_/g'
}

# @internal
# @global BASH_SOURCE
# @global BASH_VERSION
subshell.detect() {
  local -r size="${#BASH_SOURCE[@]}"
  local -r last="${BASH_SOURCE[$((size - 1))]}"
  [[ -z ${BASH_VERSION} ]] && return 1
  [[ $0 == "${last}" ]] && echo true || echo false
}

# @description The script is being executed?
is::executed() {
  subshell.detect
}

# @description The script is being sourced?
is::sourced() {
  [[ -z $(subshell.detect) ]] && echo true || echo false
}

# @description Get the folder from a URL
# @arg $1 The URL
url::folder() {
  local -r url="${1}"
  local -r clean_url="${url%%[\?#]*}"
  local -r trimmed_url="${clean_url%/}"
  local -r folder="${trimmed_url##*/}"
  echo "${folder}"
}

# @description Check if the script should run in non-interactive mode.
# @arg $1 The jurisdiction name.
# @arg $2 The repository URL.
is::interactive() {
  [[ -z ${1:-} || -z ${2:-} ]] && echo true || echo false
}

# @description Check if the script is running in a CI environment.
# @arg $1 The CI environment variable.
is::ci() {
  is::true "${1:-}"
}

# @description Check if the repository exists.
is::repo() {
  git rev-parse --is-inside-work-tree &>/dev/null && echo true || echo false
}

# @description Check if the setup should persevere.
# @arg $1 If we are in a CI environment.
# @arg $2 If the repository exists.
setup::persevere() {
  local -r is_ci=$(is::true "${1:-}")
  local -r is_repo=$(is::true "${2:-}")
  if ! "${is_ci}" && "${is_repo}"; then echo false; else echo true; fi
}

if [[ -z ${JURISDICTION_NAME+A} ]]; then
  readonly JURISDICTION_NAME="${JURISDICTION_NAME:-}"
fi

if [[ -z ${REPOSITORY_URL+A} ]]; then
  readonly REPOSITORY_URL="${REPOSITORY_URL:-}"
fi

if [[ -z ${CI+A} ]]; then
  readonly CI="${CI:-}"
fi

if [[ -z ${DRY_MODE+A} ]]; then
  readonly DRY_MODE="${DRY_MODE:-}"
fi

if [[ -z ${SCRIPT_PATH+A} ]]; then
  readonly SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fi

if [[ -z ${DEV_MODE+A} ]]; then
  if [[ -f "${SCRIPT_PATH}/README.md" ]]; then
    readonly DEV_MODE='false'
  else
    readonly DEV_MODE='true'
  fi
fi

if [[ -z ${ROOT_PATH+A} ]]; then
  if ${DEV_MODE}; then
    readonly ROOT_PATH=$(cd "${SCRIPT_PATH}/../.." && pwd)
  else
    readonly ROOT_PATH=${SCRIPT_PATH}
  fi
fi

if [[ -z ${ROOT_DIR+A} ]]; then
  readonly ROOT_DIR=${ROOT_PATH##*/}
fi

# @description Define the welcome message.
msg::welcome() {
  local -r version='0.1.1'
  cat <<MSG
Welcome to the OpenFisca Extension Template setup script v${version}!

This script will guide you through the process of setting up a new OpenFisca
jurisdiction from start to finish. We will begin now...
MSG
}

# @description Define the ci/repo validation message.
msg::stop() {
  cat <<MSG
It seems you cloned this repository, or already initialised it. Refusing to go
    further as you might lose work. If you are certain this is a new repository,
    run 'cd "${ROOT_PATH}" && rm -rf .git' to erase the history.
MSG
}

# @description Define the prompt for the jurisdiction name.
msg::prompt_name() {
  cat <<MSG
The name of the jurisdiction (usually a city or a region, e.g. Île-d'Yeu,
    Val-d'Isère...) you will model the rules of:
MSG
}

# @description Define the prompt for the url of the repository.
msg::prompt_url() {
  cat <<MSG
Your Git repository URL (i.e.
    https://githost.example/organisation/openfisca-jurisdiction):
MSG
}

# @description Define the message whether to continue or not.
msg::prompt_continue() {
  cat <<MSG
Would you like to continue (type Y for yes, N for no):
MSG
}

# @description Define the good bye message.
msg::goodbye() {
  cat <<MSG
The setup script has finished. You can now start writing your legislation with
    OpenFisca 🎉. Happy rules-as-coding!
MSG
}

# @description Define the byebye message.
# @arg $1 The jurisdiction label.
msg::byebye() {
  cat <<MSG
Bootstrap complete, you can now push this codebase to your remote repository.

    First, set up the remote with 'git remote add origin <SSH repository URL>'.
    You can then 'git push origin main' and refer to the README.md.
    The parent directory name has been changed, you can use
    'cd ../openfisca-${1} to navigate to it.
MSG
}

# @description Define the message for when running in dry mode.
msg::dry_mode() {
  cat <<MSG
»skipping the next step as we are running in dry mode«
MSG
}

# @description Set up the jurisdiction name label
# @arg $1 The jurisdiction name.
setup::name_label() {
  local name="${1}"
  local -r fx=(string::decode string::lower string::sanitise string::trim)
  local fn
  for fn in "${fx[@]}"; do name=$("${fn}" "${name}"); done
  echo "${name}"
}

# @description Snake case the jurisdiction name.
# @arg $1 The jurisdiction name label.
setup::name_snake() {
  string::snake "${1}"
}

# @description Get the repository folder.
# @arg $1 The repository URL.
setup::repository_folder() {
  url::folder "${1}"
}

# @description Get the last line number of the bootstrapping section.
setup::readme_lineno() {
  file::find_lineno README.md '## Writing the Legislation'
}

# @description Get the last line number of the changelog section.
setup::changelog_lineno() {
  file::find_lineno CHANGELOG.md '# Example Entry'
}

# @description First commit.
# @arg $1 The parent folder.
# @arg $2 The setup name label.
# @arg $3 The first commit message.
# @arg $4 If we are running in dry mode.
setup::first_commit() {
  if "${4:-false}"; then return; fi
  cd ..
  mv "${1}" openfisca-"${2}"
  cd openfisca-"${2}"
  git init --initial-branch=main &>/dev/null 2>&1
  git add .
  git commit --no-gpg-sign --quiet --message "${3}" \
    --author='OpenFisca Bot <bot@openfisca.org>'
}

# @description Replace default extension_template references
# Use intermediate backup files (`-i`) with a weird syntax due to lack of
# portable 'no backup' option. See: https://stackoverflow.com/q/5694228/594053.
# @arg $1 The jurisdiction name label.
# @arg $2 The jurisdiction snake cased.
# @arg $3 The normal jurisdiction name.
# @arg $4 The list of files to replace.
# @arg $5 If we are running in dry mode.
setup::replace_references() {
  if "${5:-false}"; then return; fi
  sed -i.template "s|openfisca-extension_template|openfisca-${1}|g" \
    README.md Makefile pyproject.toml CONTRIBUTING.md
  # shellcheck disable=SC2086
  sed -i.template "s|extension_template|${2}|g" \
    README.md pyproject.toml Makefile MANIFEST.in ${4}
  sed -i.template "s|Extension-Template|${3}|g" \
    README.md pyproject.toml .github/PULL_REQUEST_TEMPLATE.md CONTRIBUTING.md
  find . -name "*.template" -type f -delete
}

# @description Remove bootstrap instructions.
# @arg $1 The last line number of the bootstrapping section in the README.md.
# @arg $2 If we are running in dry mode.
setup::remove_bootstrap_instructions() {
  if "${2:-false}"; then return; fi
  sed -i.template -e "3,${1}d" README.md
  find . -name "*.template" -type f -delete
}

# @description Prepare README.md and CONTRIBUTING.md.
# @arg $1 The repository URL.
# @arg $2 If we are running in dry mode.
setup::prepare_readme_contributing() {
  if "${2:-false}"; then return; fi
  sed -i.template "s|https://example.com/repository|${1}|g" \
    README.md CONTRIBUTING.md
  find . -name "*.template" -type f -delete
}

# @description Prepare CHANGELOG.md.
# @arg $1 The last line number of the changelog section in the CHANGELOG.md.
# @arg $2 If we are running in dry mode.
setup::prepare_changelog() {
  if "${2:-false}"; then return; fi
  sed -i.template -e "1,${1}d" CHANGELOG.md
  find . -name "*.template" -type f -delete
}

# @description Prepare pyproject.toml.
# @arg $1 The repository URL.
# @arg $2 The repository folder.
# @arg $3 If we are running in dry mode.
setup::prepare_pyproject() {
  if "${3:-false}"; then return; fi
  sed -i.template \
    "s|https://github.com/openfisca/extension-template|${1}|g" \
    pyproject.toml
  sed -i.template 's|:: 5 - Production/Stable|:: 1 - Planning|g' pyproject.toml
  sed -i.template 's|^version = "[0-9.]*"|version = "0.0.1"|g' pyproject.toml
  sed -i.template "s|repository_folder|${2}|g" README.md
  find . -name "*.template" -type f -delete
}

# @description Rename the package.
# @arg $1 The new package name.
# @arg $2 If we are running in dry mode.
setup::rename_package() {
  if "${2:-false}"; then return; fi
  git mv openfisca_extension_template "${1}"
}

# Remove single use first time setup files
# @arg $1 If we are running in dry mode.
setup::remove_files() {
  if "${1:-false}"; then return; fi
  git rm .github/workflows/first-time-setup.yml &>/dev/null 2>&1
  git rm bashdep.sh &>/dev/null 2>&1
  git rm build.sh &>/dev/null 2>&1
  git rm first-time-setup.sh &>/dev/null 2>&1
  git rm -r src/first_time_setup &>/dev/null 2>&1
  git rm -r tests/first_time_setup &>/dev/null 2>&1
}

# @description Second commit and first tag.
# @arg $1 The second commit message.
# @arg $2 If we are running in dry mode.
setup::second_commit() {
  if "${2:-false}"; then return; fi
  git add .
  git commit --no-gpg-sign --quiet --message "${1}" \
    --author='OpenFisca Bot <bot@openfisca.org>'
  git tag '0.0.1'
}

# @description Gather information from environment variables.
# @arg $1 The jurisdiction name.
# @arg $2 The repository URL.
# @arg $3 If it is an interactive mode.
status::gather_info() {
  echo ''
  colour::task 'Gathering environment variables'
  echo ''
  colour::pass "Jurisdiction name:"
  colour::logs "${1:-[unset]}"
  colour::pass 'Repository URL:'
  colour::logs "${2:-[unset]}"
  colour::pass 'Interactive mode (inferred):'
  colour::logs "${3}"
}

# @description Check if we can continue.
# @arg $1 If we are in a CI environment.
# @arg $2 If the repository exists.
# @arg $3 If the setup should persevere.
# @arg $4 If the setup should be dry.
status::check_continue() {
  echo ''
  colour::task 'Checking if we can continue'
  echo ''
  colour::pass 'Are we in a CI environment?'
  colour::logs "${1}"
  colour::pass 'Is there an existing repository already?'
  colour::logs "${2}"
  if "${3}" || "${4}"; then
    colour::pass 'Can the setup continue?'
    colour::logs "${3}"
    if "${4}"; then
      colour::warn '»persevering because the setup is being run in dry mode«'
    fi
  else
    colour::warn 'Can the setup continue?'
    colour::logs "${3}"
  fi
}

# @description Print a pre-setup summary.
# @arg $1 The jurisdiction name.
# @arg $2 The jurisdiction name snake.
# @arg $3 The repository URL.
status::pre_summary() {
  echo ''
  colour::done 'Jurisdiction title set to:'
  colour::logs "${1:-[unset]}"
  colour::done 'Jurisdiction Python label set to:'
  colour::logs "${2:-[unset]}"
  colour::done 'Git repository URL set to:'
  colour::logs "${3:-[unset]}"
}

# @description User interruption.
# @internal
main.trap.interrupted() {
  local -r exit_code=$?
  trap - SIGINT
  echo ''
  echo -e "$(colour::warn 'Interrupted')" >&2
  exit "${exit_code}"
}

# @description Cleanup on exit.
# @internal
main.trap.cleanup() {
  local exit_code=$?
  trap - EXIT
  echo -e "$(colour::info 'Exiting, bye!')"
  exit "${exit_code}"
}

# @description Generic error message.
# @arg $1 The message to display.
# @internal
main.error() {
  local -r message="${1}"
  echo -e "$(colour::fail "${message}")" >&2
}

# @description Main function to drive the script.
main() {
  # Exit immediately if a command exits with a non-zero status.
  set -o errexit
  # Ensure that the ERR trap is inherited by shell functions.
  set -o errtrace
  # More verbosity when something within a function fails.
  set -o functrace
  # Treat unset variables as an error and exit immediately.
  set -o nounset
  # Prevent errors in a pipeline from being masked.
  set -o pipefail
  # Make word splitting happen only on newlines and tab characters.
  IFS=$'\n\t'

  # Define a cleanup functions to be called on script exit or interruption.
  trap main.trap.interrupted SIGINT
  trap main.trap.cleanup EXIT

  # Make sure we are not being sourced. Exit if it is the case.
  if "$(is::sourced)"; then
    main.error 'This script should not be sourced but executed directly'
    exit 1
  fi

  # Support being called from anywhere on the file system.
  cd "${ROOT_PATH}"

  # Define the variables we will use.
  local name="${JURISDICTION_NAME}"
  local url="${REPOSITORY_URL}"
  local -r interactive=$(is::interactive "${name}" "${url}")
  local -r ci=$(is::ci "${CI}")
  local -r repo=$(is::repo)
  local -r persevere="$(setup::persevere "${ci}" "${repo}")"
  local -r dry=$(is::true "${DRY_MODE}")
  local -r module='openfisca_extension_template'
  local -r first_commit='Initial import from OpenFisca-Extension_Template'
  local -r second_commit='Customise extension_template through script'

  # Check if we can continue.
  colour::info "$(msg::welcome)"
  status::gather_info "${name}" "${url}" "${interactive}"
  status::check_continue "${ci}" "${repo}" "${persevere}" "${dry}"
  if ! "${persevere}" && ! "${dry}"; then
    echo ''
    main.error "$(msg::stop)"
    echo ''
    exit 2
  fi

  echo ''
  colour::task 'We will now start setting up your new package'

  # Process the jurisdiction name.
  if [[ -z ${name} ]]; then echo ''; fi
  while [[ -z ${name} ]]; do
    echo -e -n "$(colour::user "$(msg::prompt_name)")"
    IFS= read -r -p ' ' name
  done
  readonly name
  local -r label=$(setup::name_label "${name}")
  local -r snake=$(setup::name_snake "${label}")

  # Process the repository URL.
  if [[ -z ${url} ]]; then echo ''; fi
  while [[ -z ${url} ]]; do
    echo -e -n "$(colour::user "$(msg::prompt_url)")"
    IFS= read -r -p ' ' url
  done
  readonly url
  local -r folder=$(setup::repository_folder "${url}")

  status::pre_summary "${name}" "${snake}" "${url}"

  # Shall we proceed?
  echo ''
  local continue=$(is::false "${interactive}")
  local prompt=$(colour::user "$(msg::prompt_continue)")
  if "${continue}"; then echo -e "${prompt} Y"; fi
  while ! "${continue}"; do
    echo -e -n "${prompt}"
    IFS= read -r -p ' ' continue
    continue=$(is::true "${continue}")
    if ! "${continue}"; then break; fi
  done
  unset prompt
  readonly continue
  echo -e "$(colour::logs "${continue}")"
  if ! "${continue}"; then echo '' && exit 3; fi

  echo ''
  colour::task 'Now we can proceed with the setup'

  local -r package="openfisca_${snake}"
  local -r lineno_readme=$(setup::readme_lineno)
  if [[ ${lineno_readme} -eq -1 ]]; then
    echo ''
    main.error 'Could not find the last line number of the README.md section'
    echo ''
    exit 4
  fi
  local -r lineno_changelog=$(setup::changelog_lineno)
  if [[ ${lineno_changelog} -eq -1 ]]; then
    echo ''
    main.error 'Could not find the last line number of the CHANGELOG.md section'
    echo ''
    exit 5
  fi

  # Initialise the repository.
  if ! "${ci}" || "${dry}"; then
    echo ''
    if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
    colour::pass 'Initialise git repository...'
    setup::first_commit "${ROOT_DIR}" "${label}" "${first_commit}" "${dry}"
    colour::pass "Commit made to 'main' with message:"
    colour::logs "${first_commit}"
  fi

  # And go on...
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Replace default extension_template references'
  local -r files=$(git ls-files "src/${module}")
  setup::replace_references "${label}" "${snake}" "${name}" "${files}" "${dry}"
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Remove bootstrap instructions'
  setup::remove_bootstrap_instructions "${lineno_readme}" "${dry}"
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Prepare README.md and CONTRIBUTING.md'
  setup::prepare_readme_contributing "${url}" "${dry}"
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Prepare CHANGELOG.md'
  setup::prepare_changelog "${lineno_changelog}" "${dry}"
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Prepare pyproject.toml'
  setup::prepare_pyproject "${url}" "${folder}" "${dry}"
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Rename package to:'
  colour::logs "${package}"
  setup::rename_package "${package}" "${dry}"
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Remove single use first time setup files'
  setup::remove_files "${dry}"

  # Committing and tagging take directly place in the GitHub Actions workflow.
  if "${ci}"; then
    echo ''
    colour::done "$(msg::goodbye)"
    echo ''
    exit 0
  fi

  # Second commit and first tag.
  if "${dry}"; then colour::warn "$(msg::dry_mode)"; fi
  colour::pass 'Committing and tagging...'
  setup::second_commit "${second_commit}" "${dry}"
  colour::pass "Second commit and first tag made on 'main' branch:"
  colour::logs "${second_commit}"

  # And finish! :)
  echo ''
  colour::done "$(msg::byebye "${label}")"
  echo ''
}

main "$@"
