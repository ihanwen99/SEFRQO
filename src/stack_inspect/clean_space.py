#!/usr/bin/env python
import re
import sys

def remove_single_blank_lines(text):
    """
    如果在两个非空行之间只有一行空白（仅包含空格或制表符），则将这两个非空行拼接，
    如果遇到连续两个或以上的空行，则保持不变。
    正则表达式说明：
      - (?<=\S)：确保前面字符为非空字符
      - \n[ \t]*\n：匹配中间仅有空格或制表符的换行（即一行空白行）
      - (?=\S)：确保后面字符为非空字符
    """
    pattern = r'(?<=\S)\n[ \t]*\n(?=\S)'
    return re.sub(pattern, '', text)

def main():
    if len(sys.argv) < 2:
        print("Usage: python remove_newlines.py input.sql [output.sql]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else input_file

    # 读取文件内容
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # 处理内容：移除符合条件的单个空行换行
    new_content = remove_single_blank_lines(content)

    # 将处理后的内容写入文件
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(new_content)

if __name__ == '__main__':
    main()
