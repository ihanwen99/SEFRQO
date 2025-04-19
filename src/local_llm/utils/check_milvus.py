#!/usr/bin/env python3
from pymilvus import MilvusClient
import os

def check_vector_db(milvus_db_path, collection_name):
    # 检查数据库文件是否存在
    if not os.path.isfile(milvus_db_path):
        print(f"Milvus 数据库文件未找到：{milvus_db_path}")
        return

    # 连接 Milvus 数据库
    try:
        client = MilvusClient(milvus_db_path)
        print(f"成功连接到 Milvus 数据库：{milvus_db_path}")
    except Exception as e:
        print(f"连接 Milvus 数据库失败: {e}")
        return

    # 列出所有集合
    try:
        collections = client.list_collections()
        print("当前数据库中的集合:")
        for coll in collections:
            print(f"  - {coll}")
    except Exception as e:
        print(f"列出集合失败: {e}")
        return

    # 检查指定集合是否存在
    if collection_name not in collections:
        print(f"集合 '{collection_name}' 不存在！")
        return
    else:
        print(f"集合 '{collection_name}' 存在。")

    # 获取集合中实体的数量（使用 get_collection_stats 获取统计信息）
    try:
        stats = client.get_collection_stats(collection_name)
        count = stats.get("row_count", None)
        print(f"集合 '{collection_name}' 中共有 {count} 条记录。")
    except Exception as e:
        print(f"统计集合实体数量失败: {e}")
    
    # 查询并显示部分记录（假设存储的字段包括 "id", "sql", "plan"）
    try:
        # 注意：调用 query 时，第一个参数为集合名称，后续按位置传递查询条件和输出字段
        results = client.query(collection_name, "id >= 0", ["id", "sql", "plan"])
        print("部分样例记录：")
        for i, record in enumerate(results):
            if i >= 5:  # 只打印前5条记录
                break
            print(record)
    except Exception as e:
        print(f"查询记录失败: {e}")

if __name__ == "__main__":
    milvus_db_path = "/home/qihanzha/LLM4QO/src/local_llm/milvus_demo_stack.db"
    collection_name = "sql_collection"
    check_vector_db(milvus_db_path, collection_name)
