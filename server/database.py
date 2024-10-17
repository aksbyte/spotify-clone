
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = 'postgresql://postgres:aks123@127.0.0.1:8080/fluttermusicapp'
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit = False, autoflush= False, bind=engine)

def get_db():   
    db = SessionLocal()
    try: 
        yield db
    finally:
        db.close