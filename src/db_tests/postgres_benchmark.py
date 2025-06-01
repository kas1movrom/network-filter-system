import time
import uuid
import random
import psycopg2
from statistics import mean

DB_NAME = "testdb"
DB_USER = "testuser"
DB_PASS = "password"
DB_HOST = "localhost"
RECORDS_COUNT = 100000
TEST_RUNS = 3

def generate_data(count):
    return [(str(uuid.uuid4()), random.random()) for _ in range(count)]

def run_benchmark():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST
    )
    cursor = conn.cursor()
    
    cursor.execute("DROP TABLE IF EXISTS test_data")
    cursor.execute("""
        CREATE TABLE test_data (
            id SERIAL PRIMARY KEY,
            uuid VARCHAR(36) NOT NULL,
            value FLOAT NOT NULL
        )
    """)
    conn.commit()
    
    operations = {
        "Insert": lambda: cursor.executemany(
            "INSERT INTO test_data (uuid, value) VALUES (%s, %s)",
            generate_data(RECORDS_COUNT)
        ),
        "Search with index": lambda: cursor.execute(
            "SELECT * FROM test_data WHERE uuid = %s",
            [str(uuid.uuid4())]
        ),
        "Delete all": lambda: cursor.execute("DELETE FROM test_data")
    }
    
    results = {op: [] for op in operations}
    for op_name, op_func in operations.items():
        print(f"Testing {op_name}...")
        for _ in range(TEST_RUNS):
            start = time.time()
            op_func()
            conn.commit()
            results[op_name].append(time.time() - start)
    
    cursor.close()
    conn.close()
    
    print("\nPostgreSQL Results (avg time in seconds):")
    for op, times in results.items():
        print(f"{op:20}: {mean(times):.4f}")

if __name__ == "__main__":
    run_benchmark()