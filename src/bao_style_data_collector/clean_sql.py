def process_sql_file():
    """
    1. First remove single-line comments
    2. Then add double empty lines before multiline comments
    """
    # Step 1: Remove single-line comments first
    def remove_sql_comments(input_file, output_file):
        with open(input_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        cleaned_lines = []
        for line in lines:
            if not line.strip():
                continue
                
            if '--' in line:
                line = line[:line.find('--')]
                
            if line.strip():
                cleaned_lines.append(line.rstrip())
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(cleaned_lines))

    # Step 2: Add empty lines before multiline comments
    def add_spaces_before_comments(file_path):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find all positions of /* 
        comment_starts = []
        pos = 0
        while True:
            pos = content.find('/*', pos)
            if pos == -1:
                break
            comment_starts.append(pos)
            pos += 1

        # Insert newlines before each comment
        # We need to process from end to start to avoid messing up positions
        for pos in reversed(comment_starts):
            # Find the last newline before the comment
            last_newline = content.rfind('\n', 0, pos)
            if last_newline == -1:
                # Comment is at the start of file
                content = '\n\n' + content
            else:
                # Insert two newlines after the found newline
                content = content[:last_newline + 1] + '\n\n' + content[last_newline + 1:]

        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)

    # Execute both steps
    input_file = '/home/qihanzha/LLM4QO/src/bao_style_data_collector/q9_to_q16.sql'
    output_file = '/home/qihanzha/LLM4QO/src/bao_style_data_collector/q9_to_q16_cleaned.sql'
    
    # Step 1: Remove single-line comments
    remove_sql_comments(input_file, output_file)
    
    # Step 2: Add empty lines before multiline comments
    add_spaces_before_comments(output_file)

if __name__ == '__main__':
    process_sql_file()