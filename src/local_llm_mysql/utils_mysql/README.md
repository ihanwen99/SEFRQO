# MySQL Query Analyzer

A MySQL query analysis tool supporting two analysis modes: query plan only (EXPLAIN) and full execution analysis (ANALYZE).

## Features

- 🔄 **Dual Mode Support**: EXPLAIN mode (no query execution) and ANALYZE mode (actual query execution)
- 📊 Detailed query execution plan analysis (EXPLAIN FORMAT=JSON)
- ⏱️ Precise execution time measurement (ANALYZE mode)
- 📈 Rich query execution statistics (ANALYZE mode)
- 🔍 Support for MySQL 8.0.18+ EXPLAIN ANALYZE
- 📝 Multiple output formats (console/file)
- 🛠️ Command line and programmatic interface
- ⚠️ Safe query plan analysis (EXPLAIN mode doesn't execute queries)

## Installation

Install dependencies:

```bash
pip install mysql-connector-python
```

## Usage

### Command Line Usage

```bash
# Interactive SQL input (default analyze mode)
python3 mysql_explain_analyzer.py

# Direct SQL query analysis (full execution analysis)
python3 mysql_explain_analyzer.py --sql "SELECT COUNT(*) FROM title"

# Query plan only, no execution
python3 mysql_explain_analyzer.py --mode explain --sql "SELECT COUNT(*) FROM title"

# Read SQL from file
python3 mysql_explain_analyzer.py --file query.sql --mode explain

# Specify output file
python3 mysql_explain_analyzer.py --sql "SELECT * FROM title LIMIT 10" --output result.txt

# Custom connection parameters and mode
python3 mysql_explain_analyzer.py \
    --host 127.0.0.1 \
    --port 3306 \
    --user qihanzha \
    --database imdbload \
    --mode explain \
    --sql "SELECT COUNT(*) FROM title"
```

### Mode Description

- **`--mode explain`**: Query plan only, no execution (safe)
- **`--mode analyze`**: Full analysis, actual query execution with performance data (default)

### Programmatic Interface

```python
from mysql_explain_analyzer import MySQLQueryAnalyzer

# Create analyzer (EXPLAIN mode - no query execution)
explain_analyzer = MySQLQueryAnalyzer(
    host="127.0.0.1",
    port=3306,
    user="qihanzha", 
    database="imdbload",
    mode="explain"  # Query plan only
)

# Create analyzer (ANALYZE mode - actual query execution)
analyze_analyzer = MySQLQueryAnalyzer(
    host="127.0.0.1",
    port=3306,
    user="qihanzha", 
    database="imdbload",
    mode="analyze"  # Full execution analysis
)

# Connect and analyze
if explain_analyzer.connect():
    # Safe query plan retrieval
    result = explain_analyzer.analyze_query("SELECT COUNT(*) FROM title")
    print(result)
    explain_analyzer.disconnect()
```

## Output Description

The analysis report includes the following sections:

### 1. Basic Information
- MySQL version
- Database name
- Query SQL
- Analysis time

### 2. Query Execution Plan
- Query cost estimation
- Table access methods
- Index usage
- Join types
- Filter conditions

### 3. Execution Time and Results
- Precise execution time (seconds)
- Number of rows returned

### 4. Execution Statistics
Detailed statistics organized by category:

#### Read Operations
- `Handler_read_first`: Number of first index entry reads
- `Handler_read_key`: Number of key-based reads
- `Handler_read_next`: Number of next row reads in index order
- `Handler_read_rnd`: Number of fixed position row reads

#### Joins and Scans
- `Select_full_join`: Number of full table joins
- `Select_range`: Number of range scans
- `Select_scan`: Number of full table scans

#### Sort Operations
- `Sort_merge_passes`: Number of sort merge passes
- `Sort_rows`: Number of sorted rows
- `Sort_scan`: Number of sort scans

#### Temporary Tables
- `Created_tmp_tables`: Number of temporary tables created
- `Created_tmp_disk_tables`: Number of disk temporary tables created

## Connection Configuration

Default connection parameters:
- Host: 127.0.0.1
- Port: 3306
- User: qihanzha
- Database: imdbload
- Password: qihanzha (can be modified via command line or code)

## Supported MySQL Versions

- MySQL 5.7+: Basic functionality (EXPLAIN FORMAT=JSON)
- MySQL 8.0.18+: Full functionality (including EXPLAIN ANALYZE)

## Important Notes

### EXPLAIN Mode (Recommended for Production)
1. ✅ **Safe**: Doesn't actually execute queries, won't affect data
2. ✅ **Fast**: Only retrieves query plan, very quick
3. ✅ **Use Cases**: Production environment query optimization, viewing execution plans

### ANALYZE Mode (Use with Caution)
1. ⚠️ **Actually executes queries**: Including SELECT, UPDATE, DELETE, etc.
2. ⚠️ **Potentially slow**: Large queries may take a long time
3. ⚠️ **Production risks**: May affect performance, modification operations will actually modify data
4. ✅ **Real data**: Actual execution times and statistics

### General Notes
1. Ensure sufficient database permissions
2. Statistics are session-level, reset before each query (ANALYZE mode only)
3. MySQL 8.0.18+ supports EXPLAIN ANALYZE functionality

## Troubleshooting

### Connection Failed
```
✗ Database connection failed: Access denied for user 'qihanzha'@'localhost'
```
Check username, password, and permissions.

### Insufficient Permissions
```
EXPLAIN FORMAT=JSON execution failed: Access denied
```
Ensure user has query permissions for relevant tables.

### Version Not Supported
If MySQL version is below 8.0.18, EXPLAIN ANALYZE will be skipped, using only EXPLAIN FORMAT=JSON.

## Example Output

### EXPLAIN Mode Output (No Query Execution)

```
================================================================================
MySQL Query Plan Analysis Report - 2025-01-06 10:30:45
================================================================================
MySQL Version: 8.0.28-0ubuntu0.20.04.3
Database: imdbload
Analysis Mode: Query Plan Analysis Only
⚠️  Note: Current mode is EXPLAIN, query will not be executed

Query SQL:
----------------------------------------
SELECT COUNT(*) FROM title WHERE production_year > 2000

================================================================================
Query Execution Plan (EXPLAIN FORMAT=JSON)
================================================================================
Query Block:
  - Select ID: 1
  - Query Cost: 524288.25
  Table Operation:
    - Table Name: title
    - Access Type: range
    - Rows Examined Per Scan: 1571072
    - Filter Percentage: 100.0%
    - Read Cost: 157107.0
    - Evaluation Cost: 157107.2
    - Used Index: idx_production_year

================================================================================
EXPLAIN Mode Summary
================================================================================
✓ Query plan analysis complete
✓ Query not executed, no actual performance data
💡 For actual execution data, use --mode analyze
```

### ANALYZE Mode Output (Actual Query Execution)

```
================================================================================
MySQL Full Query Analysis Report - 2025-01-06 10:30:45
================================================================================
MySQL Version: 8.0.28-0ubuntu0.20.04.3
Database: imdbload
Analysis Mode: Full Query Analysis
⚠️  Note: Current mode is ANALYZE, query will be executed

Query SQL:
----------------------------------------
SELECT COUNT(*) FROM title WHERE production_year > 2000

================================================================================
Query Execution Plan (EXPLAIN FORMAT=JSON)
================================================================================
Query Block:
  - Select ID: 1
  - Query Cost: 524288.25
  Table Operation:
    - Table Name: title
    - Access Type: range
    - Rows Examined Per Scan: 1571072
    - Filter Percentage: 100.0%
    - Read Cost: 157107.0
    - Evaluation Cost: 157107.2
    - Used Index: idx_production_year

================================================================================
Execution Time and Results
================================================================================
Execution Time: 0.1234 seconds
Rows Returned: 1

================================================================================
Query Execution Statistics
================================================================================

Read Operations:
  - Handler_read_first: 1
  - Handler_read_next: 1571072

Joins and Scans:
  - Select_range: 1
``` 