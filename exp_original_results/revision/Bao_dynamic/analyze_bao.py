#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import re
import sys
import csv
import argparse
from itertools import zip_longest

def parse_args():
    p = argparse.ArgumentParser(
        description="统计每条 SQL 在 index=0 和 index≠0 时的最短执行时间（ms）及性能提升，并写入 CSV")
    p.add_argument("bao_log",
                   nargs="?",
                   default="from_script_assorted.log",
                   help="包含 BAO 日志的文件路径")
    p.add_argument("main_log",
                   nargs="?",
                   default="from_main_assorted.log",
                   help="包含 Selected index 日志的文件路径")
    p.add_argument("-o", "--output",
                   default="min_times_by_index.csv",
                   help="输出 CSV 文件路径（默认 min_times_by_index.csv）")
    return p.parse_args()

def extract_bao_records(path):
    """从 BAO 日志中抽取 (sql_file, time_s) 列表"""
    pattern = re.compile(r"^BAO\s+(\S+)\s+([0-9]+\.[0-9]+)")
    records = []
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            m = pattern.match(line)
            if m:
                records.append((m.group(1), float(m.group(2))))
    return records

def extract_indices(path):
    """从主日志中抽取所有 Selected index"""
    pattern = re.compile(r"Selected\s+[Ii]ndex[:\s]+(\d+)")
    indices = []
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            m = pattern.search(line)
            if m:
                indices.append(int(m.group(1)))
    return indices

def main():
    args = parse_args()
    bao_recs = extract_bao_records(args.bao_log)
    idxs     = extract_indices(args.main_log)

    if len(bao_recs) != len(idxs):
        sys.stderr.write(
            f"[警告] BAO 记录数 ({len(bao_recs)}) != index 记录数 ({len(idxs)})，多余部分将填 “?”\n"
        )

    # 对齐，多余的填 None
    combined = []
    for rec, idx in zip_longest(bao_recs, idxs, fillvalue=None):
        if rec is None:
            sql, t = "?", 0.0
        else:
            sql, t = rec
        idx = idx if idx is not None else "?"
        combined.append((sql, t, idx))

    # 维护 SQL 的出现顺序
    order = []
    seen = set()
    for sql, _, _ in combined:
        if sql != "?" and sql not in seen:
            seen.add(sql)
            order.append(sql)

    # 为每个 SQL 分别记录 index=0 和 index!=0 的最小时间
    stats = { sql: {'0': None, 'other': None} for sql in order }
    for sql, t, idx in combined:
        if sql == "?" or idx == "?":
            continue
        key = '0' if idx == 0 else 'other'
        prev = stats[sql][key]
        if prev is None or t < prev:
            stats[sql][key] = t

    # 写 CSV：包括最小时间和性能提升
    with open(args.output, 'w', newline='', encoding='utf-8') as csvfile:
        w = csv.writer(csvfile)
        w.writerow(["sql_file", "min_time_idx0_ms", "min_time_other_ms", "performance_gain"])
        for sql in order:
            t0 = stats[sql]['0']
            tother = stats[sql]['other']
            # ms 值字符串
            s0 = f"{t0*1000:.4f}" if t0 is not None else "?"
            s1 = f"{tother*1000:.4f}" if tother is not None else "?"
            # 计算性能提升：使用秒单位比率
            if t0 is None:
                gain_str = "?"
            else:
                best = t0 if tother is None else min(t0, tother)
                gain = (t0 - best) / t0
                gain_str = f"{gain:.4f}"
            w.writerow([sql, s0, s1, gain_str])

    print(f"已将结果写入 {args.output}")

if __name__ == "__main__":
    main()
