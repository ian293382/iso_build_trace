from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 配置資料庫 URL
URL_DATABASE = "mysql+mysqlconnector://root:jms112@127.0.0.1/BlogApplication"

# 創建 SQLAlchemy 引擎
engine = create_engine(URL_DATABASE)

# 創建 session 工廠
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 定義 Base
Base = declarative_base()
