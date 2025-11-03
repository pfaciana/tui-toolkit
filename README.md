# TUI Toolkit

Common helper functions for creating visually appealing TUI (Text User Interface) interfaces in BASH. This toolkit includes dynamic tables, styled headers, ANSI colors, and message formatting. Designed to be used both as a standalone library and as a bpkg package.

## Installation

### Option 1: Direct Usage (Development)

Clone or download this repository and source the helpers you need:

```bash
# Load all helpers at once
source ./src/index.sh

# Or load specific helpers
source ./src/table.sh
```

### Option 2: BPKG Package Manager

Install via bpkg for use across multiple projects:

```bash
# Install the package
bpkg install pfaciana/tui-toolkit

# Load all helpers
source deps/tui-toolkit/src/index.sh

# Or load specific helpers
source deps/tui-toolkit/src/table.sh
```

## Helpers Included

### Table Helper

Dynamic table builder for building tables that auto-resize as data is added incrementally.

### Header Helper

Styled header/banner generator for creating section headers and titles in terminal output.

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
source ./src/index.sh

# Method 2: Load only table helper
source ./src/table.sh

# Method 3: After bpkg install - load all
source deps/tui-toolkit/src/index.sh

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

By default, headers are "open" on the right side. Use `-|` to close the box:

```bash
print_header -\| "Closed Box Header"
```

**Note:** If the text is too long for the interior width, the trailing border will not be displayed, even with the `-|` flag.

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
print_header -c -\| -p 2 -w 70 -b $'\033[0;33m\033[1m' -t $'\033[0;32m\033[1m' "Full Featured"
```

## Header Helper API Reference

### print_header

Create a styled header box with customizable options.

**Syntax:**
```bash
print_header [OPTIONS] "Title Text"
```

**Options:**
- `-w, --width N` - Set box width (default: 80)
- `-p, --padding N` - Set padding (default: 1)
  - Horizontal: N spaces left/right
  - Vertical: max(0, N-1) rows top/bottom
- `-c, --center` - Center-align text (default: left-aligned)
- `-|, --closed` - Close the box with trailing border (default: open)
  - Automatically disabled if text exceeds interior width
- `-f, --fit` - Auto-fit width to content
- `-b, --border PREFIX` - Border color prefix (default: bold cyan)
- `-t, --cell PREFIX` - Text color prefix (default: bold white)

**Examples:**
```bash
# Basic header
print_header "Section 1"

# Centered with custom width
print_header -c -w 60 "Centered Title"

# Fit to content with closed box
print_header -f -\| "Perfect Fit"

# Custom colors and padding
print_header -p 2 -b $'\033[0;33m' -t $'\033[0;32m' "Styled Header"
```

## API Reference

### print_table_start

Initialize a new table with optional configuration.

**Parameters:**
- `-m|--margin <num>` - Margin space with border styling (default: 1)
- `-p|--padding <num>` - Padding space with cell styling (default: 0)
- `-c|--center` - Center align header row (default: false)
- `-b|--border <prefix>` - ANSI prefix for border characters and margin (default: "")
- `-t|--cell <prefix>` - ANSI prefix for cell content and padding (default: "")
- `-w|--max-width <num>` - Maximum column width in characters (default: 25)
- `-e|--ellipsis <str>` - Ellipsis string for truncated content (default: "…")

**Example:**
```bash
print_table_start --margin 1 --padding 1 --center \
  --border "\033[0;34m" --cell "\033[0;30m" \
  --max-width 20 --ellipsis "..."
```

### print_table_headers

Define column headers and alignment.

**Parameters:**
- `$@` - Each argument is a column header

**Alignment markers:**
- `:Header` - Left aligned column (default)
- `Header:` - Right aligned column
- `:Header:` - Center aligned column

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

**Note:** The divider will be redrawn correctly if the table needs to resize.

### print_table_end

Print the bottom border of the table.

### print_table_message

Print a temporary message that will be erased on the next `print_table_*` call.

**Parameters:**
- `$1` - Message to print

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

For complete working examples, see the test files in the repository (available after Phase 3 when testing is integrated).

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

### Global Variables and Cleanup

The table helper uses global variables (prefixed with `_TABLE_`) to maintain state across function calls. This is intentional and necessary for the API to work.

**Variables used:**
- `_TABLE_DATA`, `_TABLE_WIDTHS`, `_TABLE_ALIGNMENTS`
- `_TABLE_MARGIN`, `_TABLE_PADDING`, `_TABLE_CENTER_HEADERS`
- `_TABLE_BORDER_PREFIX`, `_TABLE_CELL_PREFIX`
- `_TABLE_MAX_WIDTH`, `_TABLE_ELLIPSIS`
- `_TABLE_HEADER_COUNT`, `_TABLE_LINES_PRINTED`
- `_TABLE_IN_REDRAW`, `_TABLE_MESSAGE_LINES`

**Optional cleanup:**

If you need to clean up these variables after using the table (e.g., in a long-running script), use:

```bash
print_table_cleanup  # Removes all _TABLE_* variables
```

This is optional and rarely needed, as these variables are reset by `print_table_start`.

## Changelog

### Recent Changes

**Flag Naming Refactor** (Latest)
- Renamed `--divider` to `--border` (clearer naming for table frame/structure)
- Changed `--cell` short option from `-b` to `-t` (to avoid conflict with `--border`)
- Updated all internal variables: `TABLE_DIVIDER_PREFIX` → `TABLE_BORDER_PREFIX`
- Breaking change: Use `--border` instead of `--divider`, `-t` instead of `-b` for cell prefix
- Rationale: "Border" refers to table structure, "Divider" refers to horizontal separator rows

**Margin and Padding Separation**
- Split padding into margin (border-styled) and padding (cell-styled)
- Added `--margin` flag (default: 1)
- Changed `--padding` default from 1 to 0
- Breaking change: Old `--padding 1` = New `--margin 1 --padding 0`

**Alignment Parsing Cleanup**
- Removed alignment parsing from `print_table_row`
- Alignment markers (`:`) now only work in headers
- Row data treats `:` as literal characters
- Simplified code and improved performance

**Multiple Headers Support**
- `print_table_headers` can be called multiple times
- Automatic dividers above and below mid-table headers
- Column alignments reset with each new header
- Preserved during dynamic redraws

**Divider Rows**
- Added `print_table_divider` function
- Dividers preserved during table redraws
- Can be placed anywhere between rows

**Temporary Messages**
- Added `print_table_message` function
- Messages auto-erase on next table operation
- Prevents artifacts during redraws
- Replaces need for `echo` between table operations

**ANSI Background Preservation**
- Cell ANSI codes now preserve `--cell` prefix backgrounds
- Automatic wrapping of reset sequences
- Maintains background colors even when cell content has foreground colors

**Bug Fixes**
- Fixed padding on both sides (including alignment side)
- Added support for padding/margin = 0
- Fixed divider prefix application to margin spaces
- Fixed nested redraw prevention
- Fixed alignment reset with multiple headers

## Adding New Helpers

This project is designed to hold multiple helper scripts. To add a new helper:

1. **Create your helper script** in `src/` with the standard guard pattern:
   ```bash
   # Example: src/string.sh
   #!/bin/bash

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
#!/bin/bash

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

## License

MIT License - Feel free to use and modify as needed.

