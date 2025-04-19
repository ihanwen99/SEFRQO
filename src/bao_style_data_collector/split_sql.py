import re

def split_sql_files(input_file, output_file1, output_file2):
    """
    Split SQL files based on query templates Q1-Q8 and Q9-Q16.
    
    Args:
        input_file (str): Path to input SQL file
        output_file1 (str): Path to output file for Q1-Q8 queries
        output_file2 (str): Path to output file for Q9-Q16 queries
    """
    with open(input_file, 'r') as f:
        content = f.read()
    
    # Split content into individual SQL queries
    # Look for pattern "-- sql file: q" followed by number and .sql
    queries = re.split(r'(?=-- sql file: q\d+-\d+\.sql)', content)
    queries = [q for q in queries if q.strip()]  # Remove empty strings
    
    q1_to_q8 = []
    q9_to_q16 = []
    
    for query in queries:
        # Extract query number from the header
        match = re.search(r'-- sql file: q(\d+)-\d+\.sql', query)
        if match:
            query_num = int(match.group(1))
            if 1 <= query_num <= 8:
                q1_to_q8.append(query.strip())
            elif 9 <= query_num <= 16:
                q9_to_q16.append(query.strip())
    
    # Write to output files
    with open(output_file1, 'w') as f:
        f.write('\n\n'.join(q1_to_q8))
        f.write('\n')  # Add final newline
    
    with open(output_file2, 'w') as f:
        f.write('\n\n'.join(q9_to_q16))
        f.write('\n')  # Add final newline

# Example usage
if __name__ == "__main__":
    split_sql_files('SO_SQL_best.sql', 'q1_to_q8.sql', 'q9_to_q16.sql')