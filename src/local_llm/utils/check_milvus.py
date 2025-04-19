#!/usr/bin/env python3
from pymilvus import MilvusClient
import os

def check_vector_db(milvus_db_path, collection_name):
    # check if the database file exists
    if not os.path.isfile(milvus_db_path):
        print(f"Milvus database file not found: {milvus_db_path}")
        return

    # connect to Milvus database
    try:
        client = MilvusClient(milvus_db_path)
        print(f"Successfully connected to Milvus database: {milvus_db_path}")
    except Exception as e:
        print(f"Failed to connect to Milvus database: {e}")
        return

    # list all collections
    try:
        collections = client.list_collections()
        print("Collections in the current database:")
        for coll in collections:
            print(f"  - {coll}")
    except Exception as e:
        print(f"Failed to list collections: {e}")
        return

    # check if the specified collection exists
    if collection_name not in collections:
        print(f"Collection '{collection_name}' does not exist!")
        return
    else:
        print(f"Collection '{collection_name}' exists.")

    # get the number of entities in the collection (use get_collection_stats to get statistics)
    try:
        stats = client.get_collection_stats(collection_name)
        count = stats.get("row_count", None)
        print(f"Collection '{collection_name}' has {count} records.")
    except Exception as e:
        print(f"Failed to get collection entity count: {e}")
    
    # query and display partial records (assume the stored fields include "id", "sql", "plan")
    try:
        # Note: When calling query, the first parameter is the collection name, and the subsequent parameters are passed by position.
        results = client.query(collection_name, "id >= 0", ["id", "sql", "plan"])
        print("Partial example records:")
        for i, record in enumerate(results):
            if i >= 5:  # only print the first 5 records
                break
            print(record)
    except Exception as e:
        print(f"Failed to query records: {e}")

if __name__ == "__main__":
    milvus_db_path = "/home/qihanzha/LLM4QO/src/local_llm/milvus_demo_stack.db"
    collection_name = "sql_collection"
    check_vector_db(milvus_db_path, collection_name)
