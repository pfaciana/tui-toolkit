# TUI Toolkit

A comprehensive BASH library for creating professional terminal user interfaces. Includes dynamic tables with auto-resizing columns, styled headers, color-coded messages, and ANSI formatting utilities. Available as both a standalone library and a bpkg package.

## Installation

### Option 1: Direct Usage (Development)

Clone or download this repository and source the helpers you need:

```bash
# Load all helpers at once
source ./index.sh

# Or load specific helpers
source ./src/table.sh
```

### Option 2: BPKG Package Manager

Install via bpkg for use across multiple projects:

```bash
# Install the package
bpkg install pfaciana/tui-toolkit

# Load all helpers
source deps/tui-toolkit/index.sh

# Or load specific helpers
source deps/tui-toolkit/src/table.sh
```

## Development

### Setup

Initialize the development environment with a single command:

```bash
bpkg run init
```

This runs all setup tasks in parallel:
- Installs the bashunit testing framework
- Generates the package entry file (`index.sh`)
- Creates the snapshot test runner (`test.sh`)

### Individual Setup Commands

```bash
bpkg run install-bashunit      # Install bashunit testing framework
bpkg run build-entry-file       # Generate package entry file
bpkg run build-test-runner      # Create snapshot test runner
```

### Testing

```bash
bpkg run tests      # Run snapshot tests (tui-testkit)
bpkg run bashunit   # Run unit tests (bashunit)
```

## Components

### Table Helper

Dynamic table builder with automatic column resizing, alignment control, and ANSI color support.

### Header Helper

Styled section headers and banners with customizable borders, padding, and colors.

### Messages Helper

Status and process messages with color-coded backgrounds and icon indicators.

### ANSI Helper

Color codes, text formatting constants, cursor movement utilities, and icon definitions for terminal styling.

**Features:**

- **Dynamic column resizing**: Tables automatically redraw when new content exceeds current column widths
- **Column alignment**: Support for left, center, and right alignment per column (defined in headers only)
- **Multiple headers**: Add section headers in the middle of tables with automatic dividers
- **Divider rows**: Insert horizontal divider lines anywhere in the table
- **ANSI color support**: Full support for colored text with proper width calculations and background preservation
- **Margin and Padding**: Separate control over margin (divider-styled) and padding (cell-styled) spacing
- **Customizable styling**: Configure margin, padding, dividers, cell colors, max width, and ellipsis
- **Temporary messages**: Display loading/progress messages that auto-erase on next table operation
- **Minimal width**: Tables use the smallest width possible based on content
- **Box-drawing characters**: Clean Unicode borders

## Table Helper Usage

All examples below assume you've sourced the table helper using one of these methods:

```bash
# Method 1: Load all helpers (includes table.sh)
source ./index.sh

# Method 2: Load only table helper
source ./src/table.sh

# Method 3: After bpkg install - load all
source deps/tui-toolkit/index.sh

# Method 4: After bpkg install - load only table
source deps/tui-toolkit/src/table.sh
```

### Basic Example

```bash
print_table_start
print_table_headers "Name" "Age" "City"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_end
```

### Column Alignment

Column alignment is **only** defined in `print_table_headers` using `:` markers. Row data does not interpret `:` as alignment markers - they are treated as literal characters.

- `:Text` or `Text` = Left aligned (default)
- `Text:` = Right aligned
- `:Text:` = Center aligned

```bash
print_table_start
print_table_headers ":Left" ":Center:" "Right:"
print_table_row "A" "B" "C"
print_table_row ":literal" ":colons:" "here:"  # Colons are literal in rows
print_table_end
```

Output:
```
┌──────────┬──────────┬────────┐
│ Left     │ Center   │  Right │
├──────────┼──────────┼────────┤
│ A        │    B     │      C │
│ :literal │ :colons: │ here:  │
└──────────┴──────────┴────────┘
```

### Header Alignment

Header alignment is controlled by the `--center` flag in `print_table_start`:

```bash
print_table_start --center  # Centers all headers
print_table_headers "C1" "C2" "C3"
```

### Margin and Padding

Margin and padding are separate concepts (similar to HTML/CSS):

- **Margin**: Space between column border `│` and cell area, styled with `--border` prefix
- **Padding**: Space between cell area edge and content, styled with `--cell` prefix

```bash
# Default: margin=1, padding=0
print_table_start
print_table_headers "Name" "Age"
print_table_row "Alice" "25"
print_table_end

# With padding: margin=1, padding=1
print_table_start --padding 1
print_table_headers "Name" "Age"
print_table_row "Alice" "25"
print_table_end

# Custom margin and padding with colors to show the difference
print_table_start --margin 2 --padding 1 \
  --border "\033[48;5;240m" \  # Gray background for margin
  --cell "\033[48;5;22m"        # Green background for padding
print_table_headers "Name" "Age"
print_table_row "Alice" "25"
print_table_end
```

Structure: `│ MARGIN │ PADDING │ Content │ PADDING │ MARGIN │`

### With Colors

```bash
print_table_start --border $'\033[0;34m' --cell $'\033[0;30m'
print_table_headers "Name" "Status"
print_table_row "Server" $'\033[0;32mOnline'
print_table_end
```

**Note:** Cell ANSI codes are automatically wrapped to preserve the `--cell` prefix background color.

## Header Helper Usage

The header helper creates styled section headers and banners for terminal output.

### Basic Example

```bash
source ./src/header.sh

print_header "Welcome to My Application"
```

### Center Alignment

```bash
print_header -c "Centered Title"
```

### Closed Box

By default, headers are "open" on the right side. Use `-d` or `--closed` to close the box:

```bash
print_header -d "Closed Box Header"
# or
print_header --closed "Closed Box Header"
```

**Note:** If the text is too long for the interior width, the trailing border will not be displayed, even with the `-d` flag.

### Custom Width

```bash
# Fixed width
print_header -w 60 "Custom Width"

# Fit to content
print_header -f "Exact Fit"
```

### Padding

Padding controls both horizontal (left/right spaces) and vertical (top/bottom rows) spacing:

- `-p 0`: No padding
- `-p 1`: 1 space left/right, 0 rows top/bottom (default)
- `-p 2`: 2 spaces left/right, 1 row top/bottom
- `-p 3`: 3 spaces left/right, 2 rows top/bottom

```bash
print_header -p 0 "No Padding"
print_header -p 2 "More Padding"
print_header -p 3 "Even More Padding"
```

### Custom Colors

```bash
# Custom border color (yellow)
print_header -b $'\033[0;33m\033[1m' "Yellow Border"

# Custom text color (green)
print_header -t $'\033[0;32m\033[1m' "Green Text"

# Both
print_header -b $'\033[0;35m\033[1m' -t $'\033[0;36m\033[1m' "Purple Border, Cyan Text"
```

### All Options Combined

```bash
print_header -c -d -p 2 -w 70 -b $'\033[0;33m\033[1m' -t $'\033[0;32m\033[1m' "Full Featured"
```

## Messages Helper Usage

Provides formatted output functions for status messages, icons, and process indicators.

### Status Messages

Status messages display with colored backgrounds and bold labels:

```bash
source ./src/messages.sh

print_pass "All tests passed successfully"
print_fail "Test suite failed with errors"
print_warn "Deprecated function will be removed"
print_inform "Server is running on port 3000"
```

### Icon Messages

Icon messages use symbols with colored text:

```bash
print_success "Operation completed"
print_error "Failed to connect to database"
print_warning "Low disk space detected"
print_info "Configuration loaded from file"
```

### Process Indicators

Track workflow progress with process messages:

```bash
print_step "Starting application initialization"
print_progress "Loading configuration files"
print_finish "Application ready to serve requests"
print_log "Server listening on port 3000"
```

**Tip:** For long-running operations, combine process messages with cursor movement to create ephemeral status updates. See [Best Practices: Ephemeral Messages](#best-practices-ephemeral-messages) in the ANSI Helper section.

### Customization

```bash
# Custom status labels
print_pass "Database migration" "MIGRATED"
print_fail "Connection test" "TIMEOUT"

# Custom icons
print_success "Deployment complete" "🚀"
print_step "Building project" "🔨"

# Suppress trailing newline
print_progress -n "Processing..."
sleep 2
print_success " Done!"

# Adjust spacing (default: 2 spaces)
print_pass -p 4 "Extra spacing"
print_inform -p 0 "No spacing"
```

## Header Helper API Reference

### print_header

Creates a styled header box with customizable borders, padding, and colors.

**Syntax:**
```bash
print_header [OPTIONS] "Title Text"
```

**Options:**
- `-w, --width N` - Box width (default: 80)
- `-p, --padding N` - Padding (default: 1)
  - Horizontal: N spaces left/right
  - Vertical: max(0, N-1) rows top/bottom
- `-c, --center` - Center-align text (default: left-aligned)
- `-d, --closed` - Close box with trailing border (default: open)
  - Automatically disabled if text exceeds interior width
- `-f, --fit` - Auto-fit width to content
- `-b, --border PREFIX` - Border color ANSI prefix (default: bold cyan)
- `-t, --cell PREFIX` - Text color ANSI prefix (default: bold white)

**Examples:**
```bash
# Basic header
print_header "Section 1"

# Centered with custom width
print_header -c -w 60 "Centered Title"

# Fit to content with closed box
print_header -f -d "Perfect Fit"

# Custom colors and padding
print_header -p 2 -b $'\033[0;33m' -t $'\033[0;32m' "Styled Header"
```

## Messages Helper API Reference

### Status Messages

Status messages display with colored backgrounds and bold labels.

#### print_pass

Print a PASS status message with green background.

**Syntax:**
```bash
print_pass [OPTIONS] "message" [status]
```

**Options:**
- `-n` - Suppress trailing newline
- `-s, --status STATUS` - Custom status label (default: "PASS")
- `-p, --padding N` - Spaces between status and message (default: 2)

**Example:**
```bash
print_pass "All tests passed"
print_pass "Database migration" "MIGRATED"
print_pass -n "Processing..."
```

#### print_fail

Print a FAIL status message with red background.

**Syntax:**
```bash
print_fail [OPTIONS] "message" [status]
```

**Options:**
- `-n` - Suppress trailing newline
- `-s, --status STATUS` - Custom status label (default: "FAIL")
- `-p, --padding N` - Spaces between status and message (default: 2)

#### print_warn

Print a WARN status message with yellow background.

**Syntax:**
```bash
print_warn [OPTIONS] "message" [status]
```

**Options:**
- `-n` - Suppress trailing newline
- `-s, --status STATUS` - Custom status label (default: "WARN")
- `-p, --padding N` - Spaces between status and message (default: 2)

#### print_inform

Print an INFO status message with cyan background.

**Syntax:**
```bash
print_inform [OPTIONS] "message" [status]
```

**Options:**
- `-n` - Suppress trailing newline
- `-s, --status STATUS` - Custom status label (default: "INFO")
- `-p, --padding N` - Spaces between status and message (default: 2)

### Icon Messages

Icon messages use symbols with colored text.

#### print_success

Print a success message with ✓ icon (green).

**Syntax:**
```bash
print_success [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "✓")

#### print_error

Print an error message with ✗ icon (red).

**Syntax:**
```bash
print_error [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "✗")

#### print_warning

Print a warning message with ⚠ icon (yellow).

**Syntax:**
```bash
print_warning [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "⚠")

#### print_info

Print an info message with ℹ icon (cyan).

**Syntax:**
```bash
print_info [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "ℹ")

### Process Indicators

Process indicators track workflow progress.

#### print_step

Print a step message with 📍 icon (cyan).

**Syntax:**
```bash
print_step [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "📍")

#### print_progress

Print a progress message with ⏳ icon (yellow).

**Syntax:**
```bash
print_progress [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "⏳")

#### print_finish

Print a finish message with 🏁 icon (green).

**Syntax:**
```bash
print_finish [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "🏁")

#### print_log

Print a log message with ➤ icon.

**Syntax:**
```bash
print_log [OPTIONS] "message" [icon]
```

**Options:**
- `-n` - Suppress trailing newline
- `-i, --icon ICON` - Custom icon (default: "➤")

### Utility Functions

#### spaces

Generate a string of N spaces.

**Syntax:**
```bash
spaces N
```

**Parameters:**
- `N` - Number of spaces to generate

**Example:**
```bash
echo "A$(spaces 5)B"  # Output: "A     B"
```

## ANSI Helper API Reference

Provides color codes, text formatting, cursor movement, and icon constants for terminal styling.

### Foreground Colors

Standard colors:
- `BK` - Black (`\033[0;30m`)
- `RD` - Red (`\033[0;31m`)
- `GN` - Green (`\033[0;32m`)
- `YL` - Yellow (`\033[0;33m`)
- `BL` - Blue (`\033[0;34m`)
- `MG` - Magenta (`\033[0;35m`)
- `CY` - Cyan (`\033[0;36m`)
- `WH` - White (`\033[0;37m`)
- `GR` - Gray (`\033[0;90m`)

Bright colors:
- `BRT_BK` - Bright Black (`\033[90m`)
- `BRT_RD` - Bright Red (`\033[91m`)
- `BRT_GN` - Bright Green (`\033[92m`)
- `BRT_YL` - Bright Yellow (`\033[93m`)
- `BRT_BL` - Bright Blue (`\033[94m`)
- `BRT_MG` - Bright Magenta (`\033[95m`)
- `BRT_CY` - Bright Cyan (`\033[96m`)
- `BRT_WH` - Bright White (`\033[97m`)

### Background Colors

Standard backgrounds:
- `BG_BK` - Black background (`\033[40m`)
- `BG_RD` - Red background (`\033[41m`)
- `BG_GN` - Green background (`\033[42m`)
- `BG_YL` - Yellow background (`\033[43m`)
- `BG_BL` - Blue background (`\033[44m`)
- `BG_MG` - Magenta background (`\033[45m`)
- `BG_CY` - Cyan background (`\033[46m`)
- `BG_WH` - White background (`\033[47m`)
- `BG_GR` - Gray background (`\033[100m`)

Bright backgrounds:
- `BG_BRT_BK` - Bright Black background (`\033[100m`)
- `BG_BRT_RD` - Bright Red background (`\033[101m`)
- `BG_BRT_GN` - Bright Green background (`\033[102m`)
- `BG_BRT_YL` - Bright Yellow background (`\033[103m`)
- `BG_BRT_BL` - Bright Blue background (`\033[104m`)
- `BG_BRT_MG` - Bright Magenta background (`\033[105m`)
- `BG_BRT_CY` - Bright Cyan background (`\033[106m`)
- `BG_BRT_WH` - Bright White background (`\033[107m`)

### Text Formatting

Basic formatting:
- `NC` - No color / Reset (`\033[0m`)
- `BOLD` - Bold text (`\033[1m`)
- `DIM` - Dim/Faint text (`\033[2m`)
- `ITALIC` - Italic text (`\033[3m`)
- `UNDERLINE` - Underlined text (`\033[4m`)
- `BLINK` - Slow blink (`\033[5m`)
- `SWAP` - Reverse/Inverse video (`\033[7m`)
- `STRIKE` - Strikethrough text (`\033[9m`)

Reset formatting:
- `NO_BOLD` - Normal intensity (`\033[22m`)
- `NO_DIM` - Normal intensity (`\033[22m`)
- `NO_ITALIC` - Not italic (`\033[23m`)
- `NO_UNDERLINE` - Not underlined (`\033[24m`)
- `NO_BLINK` - Not blinking (`\033[25m`)
- `NO_SWAP` - Not reversed (`\033[27m`)
- `NO_STRIKE` - Not strikethrough (`\033[29m`)

### Cursor Movement Functions

#### delete_lines

Delete the previous N lines as if they were never printed.

**Syntax:**
```bash
delete_lines N
```

**Parameters:**
- `N > 0` - Delete N lines above the cursor
- `N < 0` - Delete |N| lines below the cursor
- `N = 0` - Clear the current line

**Example:**
```bash
echo "Line 1"
echo "Line 2"
echo "Line 3"
delete_lines 2  # Removes "Line 2" and "Line 3"
```

#### delete_line

Delete the previous line (alias for `delete_lines 1`).

**Syntax:**
```bash
delete_line
```

**Example:**
```bash
echo "This will be deleted"
delete_line
echo "This remains"
```

**Common use case - Ephemeral status messages:**
```bash
source ./src/messages.sh

echo "Starting process..."
perform_long_task
delete_line  # Remove the temporary message
echo "Process complete!"
```

#### clear_current_line

Clear the current line (alias for `delete_lines 0`).

**Syntax:**
```bash
clear_current_line
```

**Example:**
```bash
echo -n "Loading..."
sleep 1
clear_current_line
echo "Done!"
```

### Icons

- `ICON_SUCCESS` - ✓
- `ICON_ERROR` - ✗
- `ICON_INFO` - ℹ
- `ICON_WARNING` - ⚠
- `ICON_PROGRESS` - ⏳
- `ICON_STEP` - 📍
- `ICON_FINISHED` - 🏁

### Examples

**Basic colors:**
```bash
source ./src/ansi.sh

echo "${BOLD}${GN}Success!${NC}"
echo "${BG_RD}${WH} ERROR ${NC} Something went wrong"
echo "${ICON_SUCCESS} Task completed"
```

**Bright colors:**
```bash
echo "${BRT_GN}Bright green text${NC}"
echo "${BG_BRT_BL}${BRT_WH}Bright blue background${NC}"
```

**Text formatting:**
```bash
echo "${ITALIC}Italic text${NO_ITALIC}"
echo "${UNDERLINE}Underlined text${NO_UNDERLINE}"
echo "${STRIKE}Strikethrough text${NO_STRIKE}"
```

**Cursor movement:**
```bash
echo "Processing..."
sleep 1
delete_line
echo "Complete!"
```

### Best Practices: Ephemeral Messages

When working with long-running tasks, use ephemeral messages to provide real-time feedback without cluttering the terminal output. The pattern is:

1. Print a temporary status message (step, progress, or any message)
2. Perform the long-running operation
3. Use `delete_line` or `delete_lines` to clean up the temporary message
4. Print the final result

**Example with progress messages:**
```bash
source ./src/ansi.sh
source ./src/messages.sh

# Show ephemeral progress message
print_progress "Downloading files..."
download_large_file
delete_line  # Clean up the progress message

# Show final result
print_success "Download complete"
```

**Example with step messages:**
```bash
# Show ephemeral step
print_step "Compiling source code..."
run_compiler
delete_line  # Remove the step message

# Show final status
print_pass "Build successful"
```

**Example with multiple ephemeral messages:**
```bash
print_step "Step 1: Initializing..."
initialize_system
delete_line

print_step "Step 2: Processing data..."
process_data
delete_line

print_step "Step 3: Finalizing..."
finalize
delete_line

# Only the final message remains
print_finish "All steps completed successfully"
```

**When to use ephemeral messages:**
- Long-running operations where users need feedback that something is happening
- Multi-step processes where intermediate steps don't need to persist
- Progress updates that would clutter the output if left visible
- Temporary status messages during initialization or setup

**When NOT to use ephemeral messages:**
- Important status information that users need to review later
- Error messages or warnings that require attention
- Audit trails or logs of completed actions
- Final results or summaries

## Table Helper API Reference

### print_table_start

```bash
print_table_start [OPTIONS]
```

Initializes a new table with optional configuration.

**Options:**
- `-m, --margin N` - Margin space with border styling (default: 1)
- `-p, --padding N` - Padding space with cell styling (default: 0)
- `-c, --center` - Center-align header row (default: false)
- `-b, --border PREFIX` - ANSI prefix for borders and margin (default: "")
- `-t, --cell PREFIX` - ANSI prefix for cell content and padding (default: "")
- `-w, --max-width N` - Maximum column width (default: 25)
- `-e, --ellipsis STR` - Ellipsis for truncated content (default: "…")

**Example:**
```bash
print_table_start --margin 1 --padding 1 --center \
  --border "\033[0;34m" --cell "\033[0;30m" \
  --max-width 20 --ellipsis "..."
```

### print_table_headers

```bash
print_table_headers "Column1" "Column2" ...
```

Defines column headers and alignment. Can be called multiple times to create section headers.

**Alignment markers:**
- `:Header` - Left-aligned (default)
- `Header:` - Right-aligned
- `:Header:` - Center-aligned

**Multiple headers:**
- Can be called multiple times within the same table to create section headers
- When called after the first time, it adds a header row in the middle of the table with dividers above and below
- Resets column alignment for subsequent rows
- Header alignment (left or center) is preserved based on the `--center` flag
- Will trigger a redraw if header content exceeds current column widths

**Example:**
```bash
print_table_headers "Name" "Age" "City"
print_table_row "Alice" "25" "NYC"
print_table_headers "Product" "Price" "Stock"
print_table_row "Widget" "$10" "100"
```
Output:
```
┌─────────┬───────┬───────┐
│ Name    │ Age   │ City  │
├─────────┼───────┼───────┤
│ Alice   │ 25    │ NYC   │
├─────────┼───────┼───────┤
│ Product │ Price │ Stock │
├─────────┼───────┼───────┤
│ Widget  │ $10   │ 100   │
└─────────┴───────┴───────┘
```

### print_table_row

Add a data row to the table.

**Parameters:**
- `$@` - Each argument is a cell value

**Notes:**
- Cells inherit alignment from headers
- Alignment markers (`:`) in row data are treated as literal characters, not alignment instructions
- The table will automatically redraw if any cell exceeds the current column width
- Any temporary messages will be erased when a row is added

### print_table_divider

Print a horizontal divider row (same style as the header divider).

**Parameters:** None

**Example:**
```bash
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_divider
print_table_row "Charlie" "35" "SF"
```

Inserts a horizontal divider row. Preserved during table redraws.

### print_table_end

```bash
print_table_end
```

Prints the bottom border and completes the table.

### print_table_message

Print a temporary message that will be erased on the next `print_table_*` call.

**Parameters:**
- `$1` - Message to print

```bash
print_table_message "Loading..."
```

**Behavior:**
- Messages are temporary and only persist until the next `print_table_*` function is called
- If multiple `print_table_message` calls are made in sequence, each new message replaces the previous one
- Messages are automatically erased when `print_table_row`, `print_table_headers`, or `print_table_end` is called
- Useful for showing loading/progress messages that disappear when the next row is added

**Important:** Do NOT use `echo` between `print_table_headers` and `print_table_end`. Use `print_table_message` instead to ensure messages are properly tracked and erased.

## Advanced Features

### Multiple Headers in Same Table

You can call `print_table_headers` multiple times to create section headers:

```bash
print_table_start
print_table_headers "Name" "Age" "City"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_headers "Product" "Price" "Stock"  # Second header
print_table_row "Widget" "$10" "100"
print_table_end
```

Output:
```
┌─────────┬───────┬───────┐
│ Name    │ Age   │ City  │
├─────────┼───────┼───────┤
│ Alice   │ 25    │ NYC   │
│ Bob     │ 30    │ LA    │
├─────────┼───────┼───────┤  ← Divider above
│ Product │ Price │ Stock │  ← Second header
├─────────┼───────┼───────┤  ← Divider below
│ Widget  │ $10   │ 100   │
└─────────┴─────────┴───────┘
```

**Behavior:**
- Dividers are automatically added above and below mid-table headers
- Column alignments are reset based on the new header
- Header alignment (left/center) follows the `--center` flag
- Table will redraw if new header content exceeds current column widths

### Divider Rows

Insert horizontal divider lines anywhere:

```bash
print_table_start
print_table_headers "Name" "Age"
print_table_row "Alice" "25"
print_table_row "Bob" "30"
print_table_divider              # Manual divider
print_table_row "Charlie" "35"
print_table_end
```

Output:
```
┌─────────┬─────┐
│ Name    │ Age │
├─────────┼─────┤
│ Alice   │ 25  │
│ Bob     │ 30  │
├─────────┼─────┤  ← Manual divider
│ Charlie │ 35  │
└─────────┴─────┘
```

**Note:** Dividers are preserved during table redraws.

### Temporary Messages

Display messages that auto-erase on the next table operation:

```bash
print_table_start
print_table_headers "Name" "Status"
print_table_message "Loading data..."  # Temporary message
sleep 1
print_table_row "Server1" "Online"     # Message is erased
print_table_message "Processing..."    # New temporary message
sleep 1
print_table_row "Server2" "Online"     # Message is erased
print_table_end
```

**Important:** Do NOT use `echo` between table operations. Use `print_table_message` instead to ensure proper tracking and erasure.

## Examples

For complete working examples, see the test files in the `tests/` directory:

- **ANSI Helper**: `tests/ansi.test.sh` - Tests for cursor movement functions (delete_lines, delete_line, clear_current_line)
- **Header Helper**: `tests/header.test.sh` - Tests for styled headers with various configurations
- **Messages Helper**: `tests/messages.*.test.sh` - Tests for status, icon, and process messages
- **Table Helper**: `tests/table.*.test.sh` - Comprehensive tests for table features including alignment, colors, dividers, multi-headers, and more

All tests include snapshot files in `tests/__snapshots__/` that show expected output.

## Implementation Details

### Dynamic Redrawing

The table automatically redraws when:
- A cell's content exceeds the current column width
- A header's content exceeds the current column width
- A temporary message needs to be erased

The redraw process:
1. Erases all previously printed table lines using ANSI cursor movement
2. Recalculates column widths based on all data
3. Redraws the entire table with new widths
4. Preserves dividers and multiple headers in their correct positions

### ANSI Color Handling

The implementation properly handles ANSI escape sequences:
- **Width calculation**: ANSI codes are stripped before measuring text width
- **Background preservation**: Cell ANSI codes are wrapped to preserve `--cell` prefix backgrounds
- **Reset handling**: ANSI reset sequences (`\033[0m`, `\033[0;XXm`) trigger re-application of cell prefix

Example of background preservation:
```bash
# Cell prefix with yellow background
--cell "\033[43m"

# Cell content with cyan foreground (includes reset)
cell_content="\033[0;36mText"

# Automatically wrapped to preserve yellow background:
# \033[0m\033[43m\033[36mText
```

### Alignment Parsing

Alignment markers (`:`) are **only** parsed in `print_table_headers`:
- Headers: `:Text:` → center alignment, clean text = "Text"
- Rows: `:Text:` → literal text ":Text:" (no parsing)

This ensures:
- Clear separation of concerns (headers define structure, rows contain data)
- Literal colons can be used in data without escaping
- Simpler, more predictable behavior

### Margin vs Padding

The spacing model follows HTML/CSS concepts:

```
┌─────────────────────────────────┐
│ M M │ P P │ Content │ P P │ M M │
└─────────────────────────────────┘
  ^^^   ^^^             ^^^   ^^^
border  cell           cell border
 style  style         style  style
```

- **Margin** (M): Styled with `--border` prefix
- **Padding** (P): Styled with `--cell` prefix
- **Content**: Styled with `--cell` prefix (or cell's own ANSI codes)

This allows fine-grained control over background colors and styling.

### Guard Mechanisms

Several guard mechanisms prevent issues:
- `TABLE_IN_REDRAW`: Prevents recursive redraw calls
- `TABLE_MESSAGE_LINES`: Tracks temporary messages separately from table lines
- Alignment parsing only in headers: Prevents unintended alignment changes

## Adding New Helpers

This project is designed to hold multiple helper scripts. To add a new helper:

1. **Create your helper script** in `src/` with the standard guard pattern:
   ```bash
   # Example: src/string.sh
   #!/usr/bin/env bash

   # Standard guard pattern - prevents double-sourcing
   if [[ -n "${_STRING_LOADED:-}" ]]; then
       return 0
   fi
   _STRING_LOADED=1

   string_trim() {
       local text="$1"
       # ... implementation
   }

   string_upper() {
       local text="$1"
       # ... implementation
   }
   ```

2. **Add to bpkg.json** scripts array:
   ```json
   {
     "scripts": [
       "src/index.sh",
       "src/ansi.sh",
       "src/messages.sh",
       "src/table.sh",
       "src/string.sh"
     ]
   }
   ```

3. **Test it works**:
   ```bash
   # Auto-loaded via index.sh
   source ./src/index.sh
   string_trim "  hello  "

   # Or load individually
   source ./src/string.sh
   string_trim "  hello  "

   # Test double-sourcing (should not error)
   source ./src/string.sh
   source ./src/string.sh
   ```

### Guard Pattern Standard

**All helper files in `src/` (except `index.sh`) must use the sentinel guard pattern:**

```bash
#!/usr/bin/env bash

if [[ -n "${_FILENAME_LOADED:-}" ]]; then
    return 0
fi
_FILENAME_LOADED=1

# Rest of your code...
```

**Why?**
- Prevents errors from double-sourcing files with `readonly` variables
- Improves performance (skips re-sourcing)
- Standard practice in bash libraries
- Each file guards itself - consumers don't need to check

**Naming convention:**
- Use `_FILENAME_LOADED` where `FILENAME` matches your file name
- Example: `ansi.sh` → `_ANSI_LOADED`, `table.sh` → `_TABLE_LOADED`
- Always use uppercase with underscores

The `src/index.sh` file automatically sources all `.sh` files in the `src/` directory, so new helpers are immediately available when using the index approach.

### Writing Tests

This project uses a dual-compatible testing approach that works with both **tui-testkit** snapshot testing and **TypedDevs bashunit** snapshot testing.

All snapshot test files must follow these requirements to ensure compatibility:

#### 1. Source the bashunit-compatible adapter

Every test file must include this line at the top:

```bash
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"
```
#### 2. Wrap snapshot assertions with tee redirection

**CRITICAL:** All snapshot assertions must use this pattern:

```bash
assert_match_snapshot "$({
    # Your test code here
} | tee >(cat >&2))"
```

**Why this is required:**
- Enables real-time output streaming during test execution
- Works with `bpkg run tests -d` (debug mode)
- Allows direct execution for debugging: `./tests/your.test.sh`

#### 3. End file with run_tests call

Every test file must end with some variation of `run_tests` call (custom args are optional):

```bash
run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"
```

Or simpler:

```bash
run_tests -h "\n\n➤➤➤  {name}"
```

The `-h` flag specifies the header template. `{name}` is replaced with the test file name.

#### Complete Test File Example

```bash
#!/usr/bin/env bash

# Source your helper functions
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"

# Source the bashunit-compatible adapter (REQUIRED)
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_table() {
    set_test_title "Basic table with auto-sizing columns"

    # CRITICAL: Wrap with tee redirection
    assert_match_snapshot "$({
        print_table_start
        print_table_headers "Name" "Age" "City"
        print_table_row "Alice" "25" "NYC"
        print_table_row "Bob" "30" "LA"
        print_table_end
    } | tee >(cat >&2))"
}

function test_centered_headers() {
    set_test_title "Centered headers"

    assert_match_snapshot "$({
        print_table_start --center
        print_table_headers "C1" "C2" "C3"
        print_table_row "A" "B" "C"
        print_table_end
    } | tee >(cat >&2))"
}

# REQUIRED: Call run_tests at the end
run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"
```

### Running Tests

```bash
# Run all snapshot tests
bpkg run tests

# Run with debug output (shows real-time output)
bpkg run tests -d

# Run specific test file
bpkg run tests -i table.base

# Update snapshots
bpkg run tests -u

# Run unit tests (bashunit)
bpkg run bashunit

# Run a single test file directly for debugging
./tests/table.base.test.sh
```
