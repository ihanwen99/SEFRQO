import os
import pandas as pd
from pymilvus import MilvusClient

def show_several_records(db_path, collection_name, num_records=5):
    """
    Show several records from the Milvus database. Don't show the vector field.
    
    Args:
        db_path: Path to the Milvus database.
        collection_name: Name of the collection to query.
        num_records: Number of records to display.
        
    Returns:
        bool: True if successful, False otherwise.
    """
    pd.set_option('display.max_columns', None)
    pd.set_option('display.max_rows', None)
    pd.set_option('display.width', None)
    # pd.set_option('display.max_colwidth', None)
    try:
        # Connect to the vector database
        client = MilvusClient(db_path)
        
        # Check if the collection exists
        collections = client.list_collections()
        if collection_name not in collections:
            print(f"Collection '{collection_name}' does not exist!")
            return False
        
        # Query all records in the collection
        records = client.query(
            collection_name=collection_name,
            filter="",  # Empty filter expression
            limit=num_records  # Limit the number of records
        )
        
        # If there are no records
        if not records:
            print(f"No records found in collection '{collection_name}'")
            return False
            
        # Remove the 'vector' field from each record
        records_processed = []
        for record in records:
            rec = record.copy()
            rec.pop("vector", None)  # Remove vector field but keep the id
            records_processed.append(rec)
        
        # Create a DataFrame
        df = pd.DataFrame(records_processed)
        print(f"Dataframe with {num_records} records:\n{df}")
        
        return True
        
    except Exception as e:
        print(f"Failed to show records: {e}")
        return

def get_fastest_query_by_sqlid(db_path, collection_name, sql_id):
    """
    Retrieve the record from the Milvus collection whose 'sqlid' field matches the input sql_id,
    selecting the one with the shortest execution_time if multiple records exist.
    The returned record is a dictionary with all the original fields from Milvus unchanged
    (except for the 'vector' field which is removed).
    
    Args:
        db_path (str): Path to the Milvus database.
        collection_name (str): Name of the collection to query.
        sql_id (str): The sql_id to filter records by.
        
    Returns:
        dict: A dictionary representing the record with the shortest execution_time.
              Returns an empty dictionary if the collection does not exist or no matching records are found.
    """
    try:
        # Connect to the Milvus database (assuming MilvusClient is defined elsewhere)
        client = MilvusClient(db_path)
        
        # Verify the collection exists
        collections = client.list_collections()
        if collection_name not in collections:
            print(f"Collection '{collection_name}' does not exist!")
            return {}
        
        # Query records matching the provided sql_id
        filter_expr = f"sqlid == '{sql_id}'"
        records = client.query(
            collection_name=collection_name,
            filter=filter_expr,
            limit=10000  # Sufficiently large limit to capture all matching records
        )
        
        if not records:
            print(f"No records found with sqlid = {sql_id} in collection '{collection_name}'")
            return {}
        
        # Process records: remove the 'vector' field but keep all other fields intact
        processed_records = []
        for record in records:
            rec = record.copy()
            rec.pop("vector", None)
            processed_records.append(rec)
        
        # If there are multiple records, select the one with the shortest execution time.
        fastest_record = min(processed_records, key=lambda r: r['execution_time'])
        
        return fastest_record
        
    except Exception as e:
        print(f"Failed to get queries: {e}")
        return {}


def get_fastest_plan_by_sqlid(db_path, collection_name, sql_id):
    """
    Retrieve the record from the Milvus collection whose 'sqlid' field matches the input sql_id,
    selecting the one with the shortest execution_time if multiple records exist.
    The returned record is a dictionary with all the original fields from Milvus unchanged
    (except for the 'vector' field which is removed).

    Args:
        db_path (str): Path to the Milvus database.
        collection_name (str): Name of the collection to query.
        sql_id (str): The sql_id to filter records by.

    Returns:
        tuple: A tuple (plan, execution_time) representing the record with the best plan and its execution time.
               Returns an empty dictionary if the collection does not exist or no matching records are found.
    """
    try:
        # Connect to the Milvus database (assuming MilvusClient is defined elsewhere)
        client = MilvusClient(db_path)
        
        # Verify the collection exists
        collections = client.list_collections()
        if collection_name not in collections:
            print(f"Collection '{collection_name}' does not exist!")
            return "NOT FOUND", 0
        
        # Query records matching the provided sql_id
        filter_expr = f"sqlid == '{sql_id}'"
        records = client.query(
            collection_name=collection_name,
            filter=filter_expr,
            limit=10000  # Sufficiently large limit to capture all matching records
        )
        
        if not records:
            return "NOT FOUND", 0
        
        # Process records: remove the 'vector' field but keep all other fields intact
        processed_records = []
        for record in records:
            rec = record.copy()
            rec.pop("vector", None)
            processed_records.append(rec)
        
        # Select the record with the shortest execution time
        fastest_record = min(processed_records, key=lambda r: r['execution_time'])
        
        return fastest_record["plan"], fastest_record["execution_time"]
        
    except Exception as e:
        print(f"Failed to get queries: {e}")
        return "NOT FOUND", 0


def keep_fastest_queries_by_sqlid(db_path, collection_name, keep_all=False):
    """
    Process SQL queries in the Milvus database. If keep_all is False, keep only 
    the fastest query for each sqlid and remove others. However, if the total number 
    of records in the collection does not exceed 1000, no action will be taken.
    
    Args:
        db_path: Path to the Milvus database.
        collection_name: Name of the collection to query.
        keep_all: Boolean flag to determine whether to keep all records or only the fastest ones.
        
    Returns:
        bool: True if successful, False otherwise.
    """
    try:
        # Connect to the vector database
        client = MilvusClient(db_path)
        
        # Check if the collection exists
        collections = client.list_collections()
        if collection_name not in collections:
            print(f"Collection '{collection_name}' does not exist!")
            return False
        
        # Query all records in the collection
        records = client.query(
            collection_name=collection_name,
            filter="",  # Empty filter expression
            limit=10000  # Set a sufficiently large limit value
        )
        
        # If there are no records
        if not records:
            # print(f"No records found in collection '{collection_name}'")
            return False
        
        # If record count does not exceed 1000, do nothing
        if len(records) <= 1000:
            # print(f"Record count ({len(records)}) is not over 1000. No cleanup needed.")
            return True
        
        # Remove the 'vector' field from each record
        records_processed = []
        for record in records:
            rec = record.copy()
            rec.pop("vector", None)  # Remove vector field but keep the id
            records_processed.append(rec)
        
        # Create a DataFrame
        df = pd.DataFrame(records_processed)
        # print(f"Original dataframe:\n{df}")
        
        # Ensure the data contains the required fields
        if 'sqlid' not in df.columns or 'execution_time' not in df.columns:
            # print("The data is missing the required 'sqlid' or 'execution_time' fields")
            return False
        
        # If keep_all is True, just return without deleting anything
        if keep_all:
            # print("keep_all flag is set to True. Keeping all records.")
            return True
        
        # For each sqlid, find the record with the shortest execution time
        fastest_queries = df.loc[df.groupby('sqlid')['execution_time'].idxmin()]
        # print(f"Fastest queries dataframe:\n{fastest_queries}")
        
        # Get the IDs of records to keep
        ids_to_keep = set(fastest_queries['id'].tolist())
        
        # Get the IDs of records to delete
        ids_to_delete = [rec['id'] for rec in records_processed if rec['id'] not in ids_to_keep]
        
        # Delete the non-optimal records
        if ids_to_delete:
            # print(f"Deleting {len(ids_to_delete)} non-optimal records...")
            client.delete(
                collection_name=collection_name,
                ids=ids_to_delete
            )
            # print("Deletion completed successfully.")
        
        return True
        
    except Exception as e:
        print(f"Failed to process queries: {e}")
        return False


def update_init_collection(db_path, SQL_INIT_COLLECTION_NAME, SQL_POSTGRES_COLLECTION_NAME, SQL_ONLINE_COLLECTION_NAME):
    """
    Update the SQL_INIT_COLLECTION by adding records from SQL_ONLINE_COLLECTION_NAME 
    that have a faster execution_time than the corresponding record (same sqlid) in 
    SQL_POSTGRES_COLLECTION_NAME. The inserted records must include the 'vector' property.
    After adding the new records, the function calls keep_fastest_queries_by_sqlid to process SQL_INIT_COLLECTION.
    
    Args:
        db_path (str): Path to the Milvus database.
        SQL_INIT_COLLECTION_NAME (str): Name of the collection to be updated.
        SQL_POSTGRES_COLLECTION_NAME (str): Name of the Postgres collection.
        SQL_ONLINE_COLLECTION_NAME (str): Name of the online collection.
        
    Returns:
        bool: True if the update is successful, False otherwise.
    """
    try:
        # Connect to the Milvus database (assuming MilvusClient is defined elsewhere)
        client = MilvusClient(db_path)
        
        # Check that all required collections exist
        required_collections = [SQL_INIT_COLLECTION_NAME, SQL_POSTGRES_COLLECTION_NAME, SQL_ONLINE_COLLECTION_NAME]
        collections = client.list_collections()
        for coll in required_collections:
            if coll not in collections:
                print(f"Collection '{coll}' does not exist!")
                return False
        
        # Query all records from SQL_POSTGRES and SQL_ONLINE collections
        postgres_records = client.query(
            collection_name=SQL_POSTGRES_COLLECTION_NAME,
            filter="",
            limit=10000
        )
        online_records = client.query(
            collection_name=SQL_ONLINE_COLLECTION_NAME,
            filter="",
            limit=10000
        )
        
        if not postgres_records or not online_records:
            print("One of the collections has no records.")
            return False
        
        # Process Postgres records: remove the 'vector' field (not needed for comparison)
        def process_postgres_records(records):
            processed = []
            for record in records:
                rec = record.copy()
                rec.pop("vector", None)
                processed.append(rec)
            return processed
        
        # Process Online records: keep all fields including 'vector'
        def process_online_records(records):
            return [record.copy() for record in records]
        
        postgres_records = process_postgres_records(postgres_records)
        online_records = process_online_records(online_records)
        
        # Use pandas to group by sqlid and select the record with the shortest execution_time for each group
        import pandas as pd
        
        df_postgres = pd.DataFrame(postgres_records)
        df_online = pd.DataFrame(online_records)
        
        # Ensure required fields exist
        for df, name in [(df_postgres, "Postgres"), (df_online, "Online")]:
            if 'sqlid' not in df.columns or 'execution_time' not in df.columns:
                print(f"{name} records are missing required fields 'sqlid' or 'execution_time'.")
                return False
        
        # For each sqlid, select the record with the minimum execution_time
        postgres_fastest_df = df_postgres.loc[df_postgres.groupby('sqlid')['execution_time'].idxmin()]
        online_fastest_df = df_online.loc[df_online.groupby('sqlid')['execution_time'].idxmin()]
        
        # Get complete records with their original sqlid values
        postgres_fastest = {}
        for idx, row in postgres_fastest_df.iterrows():
            postgres_fastest[row['sqlid']] = row.to_dict()
            
        online_fastest = {}
        for idx, row in online_fastest_df.iterrows():
            online_fastest[row['sqlid']] = row.to_dict()
        
        # Prepare the list of online records that are faster than the corresponding postgres record
        records_to_add = []
        for sqlid, online_rec in online_fastest.items():
            if sqlid in postgres_fastest and online_rec['execution_time'] < postgres_fastest[sqlid]['execution_time'] and online_rec['plan'].strip() != postgres_fastest[sqlid]['plan'].strip():
                # Make sure sqlid is included in the record
                # It should already be there, but we'll ensure it explicitly
                if 'sqlid' not in online_rec or online_rec['sqlid'] != sqlid:
                    online_rec['sqlid'] = sqlid
                records_to_add.append(online_rec)
        
        # Only perform addition operation (without deleting existing records)
        if records_to_add:
            for online_record in records_to_add:
                # 按要求使用 insert 的方式，将单个记录以列表形式传入 data 参数
                client.insert(
                    collection_name=SQL_INIT_COLLECTION_NAME,
                    data=[online_record]
                )
            print(f"Inserted {len(records_to_add)} new online records into {SQL_INIT_COLLECTION_NAME}.")
        else:
            print("No new records qualified for insertion.")
        
        # Call keep_fastest_queries_by_sqlid to process SQL_INIT_COLLECTION after insertion
        result = keep_fastest_queries_by_sqlid(db_path, SQL_INIT_COLLECTION_NAME, keep_all=False)
        if not result:
            print("keep_fastest_queries_by_sqlid failed.")
            return False
        
        return True
        
    except Exception as e:
        print(f"Failed to update init collection: {e}")
        return False
# Example usage

def get_next_id(client_milvus, collection_name):
    """
    Get the next available ID for insertion in a Milvus collection.
    Returns max ID + 1 if records exist, otherwise returns 1.
    
    Args:
        client_milvus: Milvus client instance
        collection_name: Name of the collection to query
        
    Returns:
        int: Next available ID for insertion
    """
    try:
        # get all records in the collection
        records = client_milvus.query(
            collection_name=collection_name,
            filter="",
            limit=10000  
        )
        
        # if the collection is empty, return 0
        if not records or len(records) == 0:
            return 0
        
        # find the max id in the records
        all_ids = [record['id'] for record in records if 'id' in record]
        if not all_ids:
            return 0
            
        max_id = max(all_ids)
        return max_id + 1
            
    except Exception as e:
        print(f"Error querying max ID: {e}")
        raise e
    

if __name__ == "__main__":
    db_name = "imdbload"
    db_path = f"/home/qihanzha/LLM4QO/src/local_llm/online_records/{db_name}_online_vec.db"
    collection = "sql_online_collection"
    collection_init = "sql_init_collection"
    collection_postgres = "sql_postgres_collection"
    keep_all = True  
    
    # success = keep_fastest_queries_by_sqlid(db_path, collection, keep_all)
    # if success:
    #     if not keep_all:
    #         print("Successfully removed non-optimal SQL queries from the database.")
    #     else:
    #         print("No changes were made to the database as keep_all was set to True.")
    # else:
    #     print("Failed to process SQL queries.")
        
    # show_several_records(db_path, collection_init, num_records=150)
    # show_several_records(db_path, collection, num_records=150)
    # show_several_records(db_path, collection_postgres, num_records=150)
    # res = get_fastest_query_by_sqlid(db_path, collection, "1a796.sql")
    # print(res)
    # res1, res2 = get_fastest_plan_by_sqlid(db_path, collection, "1a796.sql")
    # print(res1)
    # print(res2)
    client_milvus = MilvusClient(db_path)
    res = get_next_id(client_milvus, collection_postgres)
    print(res)